#include <Rdefines.h>
#include <Rinternals.h>
#include "version.h"
#include "macros.h"
#include "convert.h"
#include "zerocurve.h"
#include "cxzerocurve.h"
#include "dateconv.h"
#include "date_sup.h"
#include "busday.h"
#include "ldate.h"
#include "cdsone.h"
#include "cds.h"
#include "cerror.h"
#include "rtbrent.h"
#include "tcurve.h"

#define NEW_ARRAY1(t,n)          (t *) JpmcdsMallocSafe(sizeof(t)*(n))

/*
***************************************************************************
** Calculate upfront charge.
***************************************************************************
*/

//EXPORT int JpmcdsCdsoneUpfrontCharge(cdsone.c)
SEXP calcUpfrontTest
(SEXP baseDate_input,  /* (I) Value date  for zero curve       */
 SEXP types, /* "MMMMMSSSSSSSSS"*/
 SEXP rates, /* rates[14] = {1e-9, 1e-9, 1e-9, 1e-9, 1e-9, 1e-9, 1e-9,
		1e-9, 1e-9, 1e-9, 1e-9, 1e-9, 1e-9, 1e-9};/\* (I)
		Array of swap rates *\/ */
 SEXP expiries,
 SEXP mmDCC,          /* (I) DCC of MM instruments            */

 SEXP fixedSwapFreq,   /* (I) Fixed leg freqency/interval               */
 SEXP floatSwapFreq,   /* (I) Floating leg freqency/interval            */
 SEXP fixedSwapDCC,    /* (I) DCC of fixed leg                 */
 SEXP floatSwapDCC,    /* (I) DCC of floating leg              */
 SEXP badDayConvZC, //'M'  badDayConv for zero curve
 SEXP holidays,//'None'

 // input for upfront charge calculation
 SEXP todayDate_input, /*today: T (Where T = trade date)*/
 SEXP valueDate_input, /* value date: T+3 Business Days*/
 SEXP benchmarkDate_input,/* start date of benchmark CDS for internal
				     ** clean spread bootstrapping;
				     ** accrual Begin Date  */
 SEXP startDate_input,/* Accrual Begin Date */
 SEXP endDate_input,/*  Maturity (Fixed) */
 SEXP stepinDate_input,  /* T + 1*/
 
 SEXP dccCDS, 			/* accruedDcc */
 SEXP ivlCDS,
 SEXP stubCDS,
 SEXP badDayConvCDS,
 SEXP calendar,

 SEXP parSpread,
 SEXP couponRate,
 SEXP recoveryRate,
 SEXP isPriceClean_input,
 SEXP payAccruedOnDefault_input,
 SEXP notional) 

{
  //  static char routine[] = "JpmcdsCdsoneUpfrontCharge";

  // my vars
  int n;
  TDate baseDate, today, benchmarkDate, startDate, endDate, stepinDate,valueDate;
  int isPriceClean, payAccruedOnDefault;
  SEXP upfrontPayment;
  TCurve *discCurve = NULL;
  char* pt_types;
  char* pt_holidays;
  char* pt_mmDCC;
  char* pt_fixedSwapDCC;
  char* pt_floatSwapDCC;
  char* pt_fixedSwapFreq;
  char* pt_floatSwapFreq;
  char* pt_dccCDS;
  char* pt_ivlCDS;
  char* pt_stubCDS;
  char* pt_calendar;
  char* pt_badDayConvCDS;

  // new
  char *pt_badDayConvZC;
  double parSpread_for_upf, couponRate_for_upf, recoveryRate_for_upf, notional_for_upf;
  
  // function to consolidate R input to TDate
  baseDate_input = coerceVector(baseDate_input,INTSXP);
  baseDate = JpmcdsDate((long)INTEGER(baseDate_input)[0], 
			(long)INTEGER(baseDate_input)[1], 
			(long)INTEGER(baseDate_input)[2]);

  todayDate_input = coerceVector(todayDate_input,INTSXP);
  today = JpmcdsDate((long)INTEGER(todayDate_input)[0], 
		     (long)INTEGER(todayDate_input)[1], 
		     (long)INTEGER(todayDate_input)[2]);

  valueDate_input = coerceVector(valueDate_input,INTSXP);
  valueDate = JpmcdsDate((long)INTEGER(valueDate_input)[0], 
			 (long)INTEGER(valueDate_input)[1], 
			 (long)INTEGER(valueDate_input)[2]);

  benchmarkDate_input = coerceVector(benchmarkDate_input,INTSXP);
  benchmarkDate = JpmcdsDate((long)INTEGER(benchmarkDate_input)[0], 
			     (long)INTEGER(benchmarkDate_input)[1],
			     (long)INTEGER(benchmarkDate_input)[2]);

  startDate_input = coerceVector(startDate_input,INTSXP);
  startDate = JpmcdsDate((long)INTEGER(startDate_input)[0], 
			 (long)INTEGER(startDate_input)[1], 
			 (long)INTEGER(startDate_input)[2]);

  endDate_input = coerceVector(endDate_input,INTSXP);
  endDate = JpmcdsDate((long)INTEGER(endDate_input)[0],
		       (long)INTEGER(endDate_input)[1],
		       (long)INTEGER(endDate_input)[2]);

  stepinDate_input = coerceVector(stepinDate_input,INTSXP);
  stepinDate = JpmcdsDate((long)INTEGER(stepinDate_input)[0],
		       (long)INTEGER(stepinDate_input)[1],
		       (long)INTEGER(stepinDate_input)[2]);

  types = coerceVector(types, STRSXP);
  pt_types = (char *) CHAR(STRING_ELT(types,0));
  holidays = coerceVector(holidays, STRSXP);
  pt_holidays =  (char *) CHAR(STRING_ELT(holidays, 0));
  
  n = strlen(CHAR(STRING_ELT(types, 0))); // for zerocurve
  rates = coerceVector(rates,REALSXP);

  mmDCC = coerceVector(mmDCC, STRSXP);
  pt_mmDCC = (char *) CHAR(STRING_ELT(mmDCC,0));

  fixedSwapFreq = coerceVector(fixedSwapFreq, STRSXP);
  pt_fixedSwapFreq = (char *) CHAR(STRING_ELT(fixedSwapFreq,0));

  floatSwapFreq = coerceVector(floatSwapFreq, STRSXP);
  pt_floatSwapFreq = (char *) CHAR(STRING_ELT(floatSwapFreq,0));

  fixedSwapDCC = coerceVector(fixedSwapDCC, STRSXP);
  pt_fixedSwapDCC = (char *) CHAR(STRING_ELT(fixedSwapDCC,0));

  floatSwapDCC = coerceVector(floatSwapDCC, STRSXP);
  pt_floatSwapDCC = (char *) CHAR(STRING_ELT(floatSwapDCC,0));

  calendar = coerceVector(calendar, STRSXP);
  pt_calendar = (char *) CHAR(STRING_ELT(calendar,0));

  parSpread_for_upf = *REAL(parSpread);
  couponRate_for_upf = *REAL(couponRate);
  recoveryRate_for_upf = *REAL(recoveryRate);
  isPriceClean = *INTEGER(isPriceClean_input);
  payAccruedOnDefault = *INTEGER(payAccruedOnDefault_input);
  notional_for_upf = *REAL(notional);

  badDayConvZC = coerceVector(badDayConvZC, STRSXP);
  pt_badDayConvZC = (char *) CHAR(STRING_ELT(badDayConvZC,0));

  badDayConvCDS = coerceVector(badDayConvCDS, STRSXP);
  pt_badDayConvCDS = (char *) CHAR(STRING_ELT(badDayConvCDS,0));

  TDateInterval fixedSwapIvl_curve;
  TDateInterval floatSwapIvl_curve;
  long          fixedSwapDCC_curve;
  long          floatSwapDCC_curve;
  double        fixedSwapFreq_curve;
  double        floatSwapFreq_curve;

  long mmDCC_zc_main;
  static char  *routine_zc_main = "BuildExampleZeroCurve";

  if (JpmcdsStringToDayCountConv(pt_mmDCC, &mmDCC_zc_main) != SUCCESS)
    goto done;
  
  if (JpmcdsStringToDayCountConv(pt_fixedSwapDCC, &fixedSwapDCC_curve) != SUCCESS)
    goto done;
  if (JpmcdsStringToDayCountConv(pt_floatSwapDCC, &floatSwapDCC_curve) != SUCCESS)
    goto done;
  
  if (JpmcdsStringToDateInterval(pt_fixedSwapFreq, routine_zc_main, &fixedSwapIvl_curve) != SUCCESS)
    goto done;
  if (JpmcdsStringToDateInterval(pt_floatSwapFreq, routine_zc_main, &floatSwapIvl_curve) != SUCCESS)
    goto done;
  
  if (JpmcdsDateIntervalToFreq(&fixedSwapIvl_curve, &fixedSwapFreq_curve) != SUCCESS)
    goto done;
  if (JpmcdsDateIntervalToFreq(&floatSwapIvl_curve, &floatSwapFreq_curve) != SUCCESS)
    goto done;
  
  expiries = coerceVector(expiries, VECSXP);

  TDate *dates_main;// = NULL;
  dates_main = NEW_ARRAY1(TDate, n);
  int i;
  for (i = 0; i < n; i++)
    {
      TDateInterval tmp;
      if (JpmcdsStringToDateInterval(strdup(CHAR(asChar(VECTOR_ELT(expiries, i)))), routine_zc_main, &tmp) != SUCCESS)

	{
            JpmcdsErrMsg ("%s: invalid interval for element[%d].\n", routine_zc_main, i);
            goto done;
        }
      
      if (JpmcdsDateFwdThenAdjust(baseDate, &tmp, JPMCDS_BAD_DAY_NONE, "None", dates_main+i) != SUCCESS)
      {
          JpmcdsErrMsg ("%s: invalid interval for element[%d].\n", routine_zc_main, i);
          goto done;
      }
    }

    discCurve = JpmcdsBuildIRZeroCurve(baseDate,
				       pt_types,
				       dates_main,
				       REAL(rates),
				       (long)n,
				       (long) mmDCC_zc_main,
				       (long) fixedSwapFreq_curve,
				       (long) floatSwapFreq_curve,
				       fixedSwapDCC_curve,
				       floatSwapDCC_curve,
				       (char) *pt_badDayConvZC,
				       pt_holidays);
    
    if (discCurve == NULL) JpmcdsErrMsg("IR curve not available ... \n");

    dccCDS = coerceVector(dccCDS, STRSXP);
    pt_dccCDS = (char *) CHAR(STRING_ELT(dccCDS,0));

    ivlCDS = coerceVector(ivlCDS, STRSXP);
    pt_ivlCDS = (char *) CHAR(STRING_ELT(ivlCDS,0));

    stubCDS = coerceVector(stubCDS, STRSXP);
    pt_stubCDS = (char *) CHAR(STRING_ELT(stubCDS,0));

    static char *routine = "CalcUpfrontCharge";
    TDateInterval ivl;
    TStubMethod stub;
    long dcc;

    if (JpmcdsStringToDayCountConv(pt_dccCDS, &dcc) != SUCCESS)
        goto done;
    
    if (JpmcdsStringToDateInterval(pt_ivlCDS, routine, &ivl) != SUCCESS)
        goto done;

    if (JpmcdsStringToStubMethod(pt_stubCDS, &stub) != SUCCESS)
        goto done;

    double result = -1.0;

    PROTECT(upfrontPayment = allocVector(REALSXP, 1));
    if (JpmcdsCdsoneUpfrontCharge(today,
				  valueDate,
				  benchmarkDate,
				  stepinDate,
				  startDate,
				  endDate,
				  couponRate_for_upf / 10000.0,
				  payAccruedOnDefault, //TRUE,
				  &ivl,
				  &stub, 
				  dcc,
				  (char) *pt_badDayConvCDS,
				  pt_calendar,
				  discCurve,
				  parSpread_for_upf/10000.0, 
				  recoveryRate_for_upf,
				  isPriceClean,
				  &result) != SUCCESS) 
      goto done;
 done:
    REAL(upfrontPayment)[0] = result * notional_for_upf;
    UNPROTECT(1);
    FREE(dates_main);
    return upfrontPayment;
}


