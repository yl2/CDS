#include <Rdefines.h>
#include <Rinternals.h>

#include "cdsone.h"
#include "cds.h"
#include "cerror.h"
#include "rtbrent.h"
#include "tcurve.h"

//EXPORT int JpmcdsCdsoneUpfrontCharge(cdsone.c)
SEXP JpmcdsCdsoneUpfrontChargeTest
(// TCurve Inputs    (?pointers)
 SEXP valueDateYear,  /* (I) Value date  for zero curve       */
 SEXP valueDateMonth,  /* (I) Value date  for zero curve       */
 SEXP valueDateDay,  /* (I) Value date  for zero curve       */
     SEXP types, //"MMMMMSSSSSSSSS"
     SEXP dates, /* (I) Array of swaps dates             */
     SEXP rates, //rates[14] = {1e-9, 1e-9, 1e-9, 1e-9, 1e-9, 1e-9, 1e-9, 1e-9, 1e-9, 1e-9, 1e-9, 1e-9, 1e-9, 1e-9};/* (I) Array of swap rates              */
     SEXP nInstr,          /* (I) Number of benchmark instruments  */
     SEXP mmDCC, //??????          /* (I) DCC of MM instruments            */
 SEXP  fixedSwapFreq,   /* (I) Fixed leg freqency               */
 SEXP       floatSwapFreq,   /* (I) Floating leg freqency            */
     SEXP fixedSwapDCC,    /* (I) DCC of fixed leg                 */
     SEXP floatSwapDCC,    /* (I) DCC of floating leg              */
     SEXP badDayConvZC, //'M'  badDayConv for zero curve
 SEXP holidays) //'None'
     ///////////////////////
 /* SEXP today, */
 /* SEXP valueDate, //value date for upfront */
 /*     SEXP benchmarkStartDate,  /\* start date of benchmark CDS for */
 /* 			       ** internal clean spread bootstrapping *\/ */
 /*     SEXP           stepinDate, */
 /*     SEXP           startDate, */
 /*     SEXP           endDate, */
 /*     SEXP couponRate, */
 /*     SEXP        payAccruedOnDefault, */
 /*     SEXP  *dateInterval, */
 /*     SEXP    *stubType, */
 /*       SEXP            accrueDCC, */
 /*     SEXP            badDayConv, // 'F'  badDayConv for upfront */
 /*       SEXP           *calendar, // 'None' */
 /*       SEXP          oneSpread, */
 /*       SEXP          recoveryRate, */
 /*     SEXP        payAccruedAtStart, //boolean */
 /*     double         *upfrontCharge) */
{
  static char routine[] = "JpmcdsCdsoneUpfrontCharge";
  //int         status    = FAILURE;

    TCurve           *flatSpreadCurve = NULL;
    
    // my vars
    int n;
    TDate baseDate;
    SEXP status;
    TCurve *discCurve;
char *pt_types;

    valueDateYear = coerceVector(valueDateYear,INTSXP);
    valueDateMonth = coerceVector(valueDateMonth,INTSXP);
    valueDateDay = coerceVector(valueDateDay,INTSXP);
    baseDate = JpmcdsDate(INTEGER(valueDateYear)[0], INTEGER(valueDateMonth)[0], INTEGER(valueDateDay)[0]);
    types = coerceVector(types, STRSXP);

*pt_types = CHAR(STRING_ELT(types,0));

    n = strlen(CHAR(STRING_ELT(types, 0))); // for zerocurve
    dates = coerceVector(dates,INTSXP);
    rates = coerceVector(rates,REALSXP);
    mmDCC = coerceVector(mmDCC,REALSXP);
    fixedSwapFreq = coerceVector(fixedSwapFreq,REALSXP);
    floatSwapFreq = coerceVector(floatSwapFreq,REALSXP);
    fixedSwapDCC = coerceVector(fixedSwapDCC,REALSXP);
    floatSwapDCC = coerceVector(floatSwapDCC,REALSXP);
    badDayConvZC = coerceVector(badDayConvZC,REALSXP);
    holidays = coerceVector(holidays, STRSXP);
    
discCurve = JpmcdsBuildIRZeroCurve(
baseDate,
  pt_types,
					      INTEGER(dates),
					      REAL(rates),
					      n,
					      (long) mmDCC,
					      (long) fixedSwapFreq,
					      (long) floatSwapFreq,
					      (long) fixedSwapDCC,
					      (long) floatSwapDCC,
					      (long) badDayConvZC,
					      AS_CHARACTER(STRING_ELT(holidays, 0))
					      );

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


  PROTECT(status = allocVector(INTSXP, 1));
  INTEGER(status)[0] = 1;
  UNPROTECT(1);
  
  return status;

}

