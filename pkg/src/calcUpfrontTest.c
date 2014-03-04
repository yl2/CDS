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
double CalcUpfrontChargeTest
(TCurve* curve, 
 double couponRate,
 TDate         today,
 TDate         valueDate,
 TDate         startDate,
 TDate         benchmarkStart,
 TDate         stepinDate,
 TDate         endDate,
 TBoolean      payAccOnDefault, // = TRUE,
 TDateInterval ivl,
 TStubMethod   stub,
 long          dcc,
 double        parSpread, //  = 3600,
 double        recoveryRate, // = 0.4,
 TBoolean      isPriceClean, // = FALSE,
 double        notional //= 1e7
)
{
    static char  *routine = "CalcUpfrontCharge";
    double        result = -1.0;

    if (curve == NULL)
    {
        JpmcdsErrMsg("CalcUpfrontCharge: NULL IR zero curve passed\n");
        goto done;
    }

    /* today          = JpmcdsDate(2008, 2, 1); */
    /* valueDate      = JpmcdsDate(2008, 2, 1); */
    /* benchmarkStart = JpmcdsDate(2008, 2, 2); */
    /* startDate      = JpmcdsDate(2008, 2, 8); */
    /* endDate        = JpmcdsDate(2008, 2, 12); */
    /* stepinDate     = JpmcdsDate(2008, 2, 9); */

    if (JpmcdsStringToDayCountConv("Act/360", &dcc) != SUCCESS)
        goto done;
    
    if (JpmcdsStringToDateInterval("1S", routine, &ivl) != SUCCESS)
        goto done;

    if (JpmcdsStringToStubMethod("f/s", &stub) != SUCCESS)
        goto done;

    if (JpmcdsCdsoneUpfrontCharge(today,
                                  valueDate,
                                  benchmarkStart,
                                  stepinDate,
                                  startDate,
                                  endDate,
                                  couponRate / 10000.0,
                                  payAccOnDefault,
                                  &ivl,
                                  &stub,
                                  dcc,
                                  'F',
                                  "None",
                                  curve,
                                  parSpread / 10000.0,
                                  recoveryRate,
                                  isPriceClean,
                                  &result) != SUCCESS) goto done;
done:
    return result * notional;
}


//EXPORT int JpmcdsCdsoneUpfrontCharge(cdsone.c)
SEXP calcUpfrontTest
(SEXP baseDateYear,  /* (I) Value date  for zero curve       */
 SEXP baseDateMonth,  /* (I) Value date  for zero curve       */
 SEXP baseDateDay,  /* (I) Value date  for zero curve       */

 SEXP types, //"MMMMMSSSSSSSSS"
 SEXP dates, /* (I) Array of swaps dates             */
 SEXP rates, //rates[14] = {1e-9, 1e-9, 1e-9, 1e-9, 1e-9, 1e-9, 1e-9, 1e-9, 1e-9, 1e-9, 1e-9, 1e-9, 1e-9, 1e-9};/* (I) Array of swap rates              */
 SEXP nInstr,          /* (I) Number of benchmark instruments  */
 SEXP mmDCC, //??????          /* (I) DCC of MM instruments            */
 SEXP fixedSwapFreq,   /* (I) Fixed leg freqency               */
 SEXP floatSwapFreq,   /* (I) Floating leg freqency            */
 SEXP fixedSwapDCC,    /* (I) DCC of fixed leg                 */
 SEXP floatSwapDCC,    /* (I) DCC of floating leg              */
 SEXP badDayConvZC, //'M'  badDayConv for zero curve
 SEXP holidays,//'None'
 // input for upfront charge calculation
 /* today          = JpmcdsDate(2008, 2, 1); */
 SEXP todayDateYear,  /* (I) T date  for upfront charge calculation       */
 SEXP todayDateMonth,   /* (I) T date  for upfront charge calculation       */
 SEXP todayDateDay,  /* (I) T date  for upfront charge calculation       */

 /* valueDate      = JpmcdsDate(2008, 2, 1); */
 SEXP valueDateYear,  /* (I) Value date for upfront charge calculation        */
 SEXP valueDateMonth,  /* (I) Value date  for upfront charge calculation        */
 SEXP valueDateDay,  /* (I) Value date  for upfront charge calculation        */
 

 /* benchmarkStart = JpmcdsDate(2008, 2, 2); */
 SEXP benchmarkDateYear, 
 SEXP benchmarkDateMonth,
 SEXP benchmarkDateDay,  
 
 /* startDate      = JpmcdsDate(2008, 2, 8); */
 SEXP startDateYear, 
 SEXP startDateMonth,
 SEXP startDateDay,  


 /* endDate        = JpmcdsDate(2008, 2, 12); */
 SEXP endDateYear, 
 SEXP endDateMonth,
 SEXP endDateDay,  

 /* stepinDate     = JpmcdsDate(2008, 2, 9); */
 SEXP stepinDateYear, 
 SEXP stepinDateMonth,
 SEXP stepinDateDay,  


 SEXP couponRate) 

{
  static char routine[] = "JpmcdsCdsoneUpfrontCharge";
  //int         status    = FAILURE;
  // TCurve           *flatSpreadCurve = NULL;
  
  // my vars
  int n;
  TDate baseDate, today, benchmarkDate, startDate, endDate, stepinDate,valueDate;
  SEXP status;
  TCurve *discCurve = NULL;
  char* pt_types;
  char* pt_holidays;
  char *badDayConvZC_char;
  double couponRate_for_upf;
  
  baseDateYear = coerceVector(baseDateYear,INTSXP);
  baseDateMonth = coerceVector(baseDateMonth,INTSXP);
  baseDateDay = coerceVector(baseDateDay,INTSXP);
  baseDate = JpmcdsDate((long)INTEGER(baseDateYear)[0], 
			(long)INTEGER(baseDateMonth)[0], 
			(long)INTEGER(baseDateDay)[0]);

  todayDateYear = coerceVector(todayDateYear,INTSXP);
  todayDateMonth = coerceVector(todayDateMonth,INTSXP);
  todayDateDay = coerceVector(todayDateDay,INTSXP);
  today = JpmcdsDate((long)INTEGER(todayDateYear)[0], 
		     (long)INTEGER(todayDateMonth)[0], 
		     (long)INTEGER(todayDateDay)[0]);

  valueDateYear = coerceVector(valueDateYear,INTSXP);
  valueDateMonth = coerceVector(valueDateMonth,INTSXP);
  valueDateDay = coerceVector(valueDateDay,INTSXP);
  valueDate = JpmcdsDate((long)INTEGER(valueDateYear)[0], 
			 (long)INTEGER(valueDateMonth)[0], 
			 (long)INTEGER(valueDateDay)[0]);

  benchmarkDateYear = coerceVector(benchmarkDateYear,INTSXP);
  benchmarkDateMonth = coerceVector(benchmarkDateMonth,INTSXP);
  benchmarkDateDay = coerceVector(benchmarkDateDay,INTSXP);
  benchmarkDate = JpmcdsDate((long)INTEGER(benchmarkDateYear)[0], 
			     (long)INTEGER(benchmarkDateMonth)[0],
			     (long)INTEGER(benchmarkDateDay)[0]);

  startDateYear = coerceVector(startDateYear,INTSXP);
  startDateMonth = coerceVector(startDateMonth,INTSXP);
  startDateDay = coerceVector(startDateDay,INTSXP);
  startDate = JpmcdsDate((long)INTEGER(startDateYear)[0], 
			 (long)INTEGER(startDateMonth)[0], 
			 (long)INTEGER(startDateDay)[0]);

  endDateYear = coerceVector(endDateYear,INTSXP);
  endDateMonth = coerceVector(endDateMonth,INTSXP);
  endDateDay = coerceVector(endDateDay,INTSXP);
  endDate = JpmcdsDate((long)INTEGER(endDateYear)[0],
		       (long)INTEGER(endDateMonth)[0],
		       (long)INTEGER(endDateDay)[0]);

  stepinDateYear = coerceVector(stepinDateYear,INTSXP);
  stepinDateMonth = coerceVector(stepinDateMonth,INTSXP);
  stepinDateDay = coerceVector(stepinDateDay,INTSXP);
  stepinDate = JpmcdsDate((long)INTEGER(stepinDateYear)[0],
		       (long)INTEGER(stepinDateMonth)[0],
		       (long)INTEGER(stepinDateDay)[0]);

  types = coerceVector(types, STRSXP);
  pt_types = (char *) CHAR(STRING_ELT(types,0));
  pt_holidays =  (char *) CHAR(STRING_ELT(holidays, 0));
  
  n = strlen(CHAR(STRING_ELT(types, 0))); // for zerocurve

  rates = coerceVector(rates,REALSXP);
  mmDCC = coerceVector(mmDCC,REALSXP);
  fixedSwapFreq = coerceVector(fixedSwapFreq,REALSXP);
  floatSwapFreq = coerceVector(floatSwapFreq,REALSXP);
  fixedSwapDCC = coerceVector(fixedSwapDCC,REALSXP);
  floatSwapDCC = coerceVector(floatSwapDCC,REALSXP);
  couponRate_for_upf = *REAL(couponRate);
  // printf("Coupon Rate = %f\n", (double)couponRate_for_upf);

  badDayConvZC = AS_CHARACTER(badDayConvZC);
  badDayConvZC_char = CHAR(asChar(STRING_ELT(badDayConvZC, 0)));

  holidays = coerceVector(holidays, STRSXP);

  // main.c dates
  TDateInterval ivl;
  long          dcc;
  double        freq;
  long mmDCC_zc_main;
  static char  *routine_zc_main = "BuildExampleZeroCurve";

  if (JpmcdsStringToDayCountConv("Act/360", &mmDCC_zc_main) != SUCCESS)
    goto done;
  
  if (JpmcdsStringToDayCountConv("30/360", &dcc) != SUCCESS)
    goto done;
  
  if (JpmcdsStringToDateInterval("6M", routine_zc_main, &ivl) != SUCCESS)
    goto done;
  
  if (JpmcdsDateIntervalToFreq(&ivl, &freq) != SUCCESS)
    goto done;
  
  
  char *expiries[14] = {"1M", "2M", "3M", "6M", "9M", "1Y", "2Y", "3Y", "4Y", "5Y", "6Y", "7Y", "8Y", "9Y"};
  TDate *dates_main = NULL;
  dates_main = NEW_ARRAY1(TDate, n);
  int i;
  for (i = 0; i < n; i++)
    {
      TDateInterval tmp;
      
      if (JpmcdsStringToDateInterval(expiries[i], routine_zc_main, &tmp) != SUCCESS)
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

  // This step is the BuildExampleZeroCurve function in main.c under \examples
  discCurve = JpmcdsBuildIRZeroCurve(
				     baseDate,
				     pt_types,
				     dates_main,
				     REAL(rates),
				     (long)n,
				     /* (long) mmDCC, */
				     /* (long) fixedSwapFreq, */
				     /* (long) floatSwapFreq, */
				     /* (long) fixedSwapDCC, */
				     /* (long) floatSwapDCC, */
				     (long) mmDCC_zc_main,
				     (long) freq,
				     (long) freq,
				     (long) dcc,
				     (long) dcc,
				     (char) *badDayConvZC_char,
				     pt_holidays);
    
  if (discCurve == NULL) printf("NULL...\n");

  TStubMethod stub;
  PROTECT(status = allocVector(REALSXP, 1));
  REAL(status)[0] = CalcUpfrontChargeTest(discCurve, 
					  (double) couponRate_for_upf,
					  today,
					  valueDate,
					  startDate,
					  benchmarkDate,
					  stepinDate,
					  endDate,
					  TRUE,
					  ivl,
					  stub, 
					  dcc,
					  3600,
					  0.4,
					  FALSE,
					  1e7);
  UNPROTECT(1);
  
  
 done:
  FREE(dates_main);
  return status;

}


