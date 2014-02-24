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
double CalcUpfrontCharge(TCurve* curve, double couponRate)
{
    static char  *routine = "CalcUpfrontCharge";
    TDate         today;
    TDate         valueDate;
    TDate         startDate;
    TDate         benchmarkStart;
    TDate         stepinDate;
    TDate         endDate;
    TBoolean      payAccOnDefault = TRUE;
    TDateInterval ivl;
    TStubMethod   stub;
    long          dcc;
    double        parSpread = 3600;
    double        recoveryRate = 0.4;
    TBoolean      isPriceClean = FALSE;
    double        notional = 1e7;
    double        result = -1.0;

    if (curve == NULL)
    {
        JpmcdsErrMsg("CalcUpfrontCharge: NULL IR zero curve passed\n");
        goto done;
    }

    today          = JpmcdsDate(2008, 2, 1);
    valueDate      = JpmcdsDate(2008, 2, 1);
    benchmarkStart = JpmcdsDate(2008, 2, 2);
    startDate      = JpmcdsDate(2008, 2, 8);
    endDate        = JpmcdsDate(2008, 2, 12);
    stepinDate     = JpmcdsDate(2008, 2, 9);

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
SEXP JpmcdsCdsoneUpfrontChargeTest
(SEXP valueDateYear,  /* (I) Value date  for zero curve       */
 SEXP valueDateMonth,  /* (I) Value date  for zero curve       */
 SEXP valueDateDay,  /* (I) Value date  for zero curve       */
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
 SEXP couponRate) 

{
  static char routine[] = "JpmcdsCdsoneUpfrontCharge";
  //int         status    = FAILURE;
  
  TCurve           *flatSpreadCurve = NULL;
  
  // my vars
  int n;
  TDate baseDate;
  SEXP status;
  TCurve *discCurve = NULL;
  char* pt_types;
  char* pt_holidays;
  char *badDayConvZC_char;
  double couponRate_for_upf;

  valueDateYear = coerceVector(valueDateYear,INTSXP);
  valueDateMonth = coerceVector(valueDateMonth,INTSXP);
  valueDateDay = coerceVector(valueDateDay,INTSXP);
  baseDate = JpmcdsDate((long)INTEGER(valueDateYear)[0], (long)INTEGER(valueDateMonth)[0], (long)INTEGER(valueDateDay)[0]);

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
				     // (long) badDayConvZC,
				     (char) *badDayConvZC_char,
				     pt_holidays);
    
  if (discCurve == NULL) printf("NULL...\n");

  /* get discount factor */
  /* printf("\n"); */
  /* printf("Discount factor on 3rd Jan 08 = %f\n", JpmcdsZeroPrice(discCurve, JpmcdsDate(2008,1,3))); */
  /* printf("Discount factor on 3rd Jan 09 = %f\n", JpmcdsZeroPrice(discCurve, JpmcdsDate(2009,1,3))); */
  /* printf("Discount factor on 3rd Jan 17 = %f\n", JpmcdsZeroPrice(discCurve, JpmcdsDate(2017,1,3))); */
  
  /* /\* get upfront charge *\/ */
  /* printf("\n"); */
  /* printf("Upfront charge @ cpn = 0bps    =  %f\n", CalcUpfrontCharge(discCurve, 0)); */
  /* printf("Upfront charge @ cpn = 3600bps =  %f\n", CalcUpfrontCharge(discCurve, 3600)); */
  /* printf("Upfront charge @ cpn = 7200bps = %f\n", CalcUpfrontCharge(discCurve, 7200)); */
    
  /* PROTECT(status = allocVector(INTSXP, 1)); */
  /* INTEGER(status)[0] = 1; */
  /* UNPROTECT(1); */
  
  PROTECT(status = allocVector(REALSXP, 1));
  REAL(status)[0] = CalcUpfrontCharge(discCurve, (double) couponRate_for_upf);
  UNPROTECT(1);


 done:
  FREE(dates_main);
  return status;



}


  /* flatSpreadCurve = JpmcdsCleanSpreadCurve ( */
  /*     today, */
  /*     discCurve, */
  /*     benchmarkStartDate, */
    /*     stepinDate, */
    /*     valueDate, */
    /*     1, */
    /*     &endDate, */
    /*     &oneSpread, */
    /*     NULL, */
    /*     recoveryRate, */
    /*     payAccruedOnDefault, */
    /*     dateInterval, */
    /*     accrueDCC, */
    /*     stubType, */
    /*     badDayConv, */
    /*     calendar); */

    /* if (flatSpreadCurve == NULL) */
    /*     goto done; */
      
    /* if (JpmcdsCdsPrice(today, */
    /*                    valueDate, */
    /*                    stepinDate, */
    /*                    startDate,  /\* cds can start from past *\/ */
    /*                    endDate, */
    /*                    couponRate, */
    /*                    payAccruedOnDefault, */
    /*                    dateInterval, */
    /*                    stubType, */
    /*                    accrueDCC, */
    /*                    badDayConv, */
    /*                    calendar, */
    /*                    discCurve, */
    /*                    flatSpreadCurve, */
    /*                    recoveryRate, */
    /*                    payAccruedAtStart, */
    /*                    upfrontCharge) != SUCCESS) */
    /*     goto done; */

    // status = SUCCESS;

 /* done: */

 /*    JpmcdsFreeTCurve(flatSpreadCurve); */

 /*    if (status != SUCCESS) */
 /*        JpmcdsErrMsgFailure (routine); */


  /* printf("building zero curve...\n"); */
  /* printf("baseDate...%i\n", baseDate); */
  /* printf("ninstr...%lu\n", n); */
  /* printf("mmDCC...%d\n", mmDCC_zc_main); */
  /* printf("freq...%lu\n", freq); */
  /* printf("dcc...%lu\n", dcc); */
  /* printf("badDayConv...|%c|\n", *badDayConvZC_char);  */
