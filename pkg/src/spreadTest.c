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

// correspond to spreadTest.R


typedef struct
{
    TDate           today;
    TDate           valueDate;
    TDate           benchmarkStartDate; /* start date of benchmark CDS for
                                        ** internal clean spread bootstrapping */
    TDate           stepinDate;
    TDate           startDate;
    TDate           endDate;
    double          couponRate;
    TBoolean        payAccruedOnDefault;
    TDateInterval  *dateInterval;
    TStubMethod    *stubType;
    long            accrueDCC;
    long            badDayConv;
    char           *calendar;
    TCurve         *discCurve;
    double          upfrontCharge;
    double          recoveryRate;
    TBoolean        payAccruedAtStart;
} CDSONE_SPREAD_CONTEXT;


/* static function declarations */
static int cdsoneSpreadSolverFunction
(double               onespread,
 CDSONE_SPREAD_CONTEXT *context,
 double              *diff)
{
    double upfrontCharge;
    printf("solverFunction onespread %f\n", onespread);

    /* if (JpmcdsCdsoneUpfrontCharge(JpmcdsDate(2008, 2, 1), */
    /*                               JpmcdsDate(2008, 2, 1), */
    /*                               JpmcdsDate(2008, 2, 2), */
    /*                               JpmcdsDate(2008, 2, 9), */
    /*                               JpmcdsDate(2008, 2, 8), */
    /*                               JpmcdsDate(2008, 2, 12), */
    /*                               100 / 10000.0, */
    /*                               TRUE, */
    /*                               context->dateInterval, */
    /*                               context->stubType, */
    /*                               context->accrueDCC, */
    /*                               'F', */
    /*                               "None", */
    /*                               context->discCurve, */
    /*                               500/10000, */
    /*                               0.4, */
    /*                               FALSE, */
    /*                               &upfrontCharge) != SUCCESS) */

    /* printf("payAccOnDefault--%i\n", context->payAccruedOnDefault); */
    /* printf("ivl--%c\n", context->dateInterval->prd_typ); */
    /* printf("ivl--%i\n", context->dateInterval->prd); */
    /* printf("ivl--%i\n", context->dateInterval->flag); */
    /* printf("stubAtEnd--%i\n", context->stubType->stubAtEnd); */
    /* printf("stublongStub--%i\n", context->stubType->longStub); */
    /* printf("dcc--%i\n", context->accrueDCC); */
    /* printf("recovery rate--%f\n", context->recoveryRate); */
    /* printf("isPriceClean--%i\n", context->payAccruedAtStart); */


    /* int a; */
    /* a = JpmcdsCdsoneUpfrontCharge(context->today, */
    /*                            context->valueDate, */
    /*                            context->benchmarkStartDate, */
    /*                            context->stepinDate, */
    /*                            context->startDate, */
    /*                            context->endDate, */
    /*                            context->couponRate, */
    /*                            context->payAccruedOnDefault, */
    /*                            context->dateInterval, */
    /*                            context->stubType, */
    /*                            context->accrueDCC, */
    /* 				  context->badDayConv, */
    /*                            context->calendar, */
    /*                            context->discCurve, */
    /*                            onespread, */
    /*                            context->recoveryRate, */
    /*                            context->payAccruedAtStart, */
    /* 				  &upfrontCharge); */
    /* printf("what is a in solver function??????--%i\n", a); */
    /* printf("what is upfront then???%f\n", upfrontCharge); */
    /* *diff = upfrontCharge - context->upfrontCharge; */
    /* printf("solverFunction onespread %f", *diff); */


    if (JpmcdsCdsoneUpfrontCharge(context->today,
				  context->valueDate,
				  context->benchmarkStartDate,
				  context->stepinDate,
				  context->startDate,
				  context->endDate,
				  context->couponRate,
				  context->payAccruedOnDefault,
				  context->dateInterval,
				  context->stubType,
				  context->accrueDCC,
    				  context->badDayConv,
				  context->calendar,
				  context->discCurve,
				  onespread,
				  context->recoveryRate,
				  context->payAccruedAtStart,
				  &upfrontCharge) != SUCCESS)
      return FAILURE;
    printf("solverFunction upfront %f", upfrontCharge);
    *diff = upfrontCharge - context->upfrontCharge;
    printf("solverFunction diff %f", *diff);
    return SUCCESS;
}

/*
***************************************************************************
** Calculate conventional spread from upfront charge.
***************************************************************************
*/

SEXP calcCdsoneSpread
(// variables for the zero curve
 SEXP baseDate_input,  /* (I) Value date  for zero curve       */
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

 SEXP           todayDate_input, /*today: T (Where T = trade date)*/
 SEXP           valueDate_input, /* value date: T+3 Business Days*/
 SEXP           benchmarkStartDate_input,  /* start date of benchmark CDS for
				     ** internal clean spread bootstrapping;
				     ** accrual Begin Date  */
 SEXP           stepinDate_input,  /* T + 1*/
 SEXP           startDate_input,  /* Accrual Begin Date */
 SEXP           endDate_input,  /*  Maturity (Fixed) */
 SEXP          couponRate_input, 	/* Fixed Coupon Amt */
 SEXP        payAccruedOnDefault_input, /* TRUE in new contract */
 SEXP  dateInterval,		  /* Q - 3 months in new contract */
 SEXP    stubType, 		/* F/S */
 SEXP            accrueDCC_input,	/* ACT/360 */
 SEXP            badDayConv_input, 	/* (F) Following */ 
 SEXP           calendar_input,	/*  None (no holiday calendar) in new contract */
 SEXP          upfrontCharge_input,
 SEXP          recoveryRate_input,	/* might want to consider setting default 
				** to 40% for the new contracts */
 SEXP        payAccruedAtStart_input	/* (True/False), True: Clean Upfront supplied */
)
{
  static char routine[] = "JpmcdsCdsoneSpread";
    SEXP status;
    TDate baseDate, todayDate, benchmarkStartDate, startDate, endDate, stepinDate,valueDate;
    int n; 	/* for zero curve */
    TCurve *discCurve = NULL;
    //    char* pt_types;
    char* pt_holidays;
    char* pt_badDayConvZC;
    char* pt_calendar;
    TBoolean payAccruedOnDefault, payAccruedAtStart;
    TStubMethod *pt_stubType;
    TDateInterval *pt_dateInterval;
    double* pt_onespread;
    double couponRate, upfrontCharge, recoveryRate;
    long accrueDCC, badDayConv;

    pt_onespread =  malloc(sizeof(double));

    CDSONE_SPREAD_CONTEXT context;

    baseDate_input = coerceVector(baseDate_input,INTSXP);
    baseDate = JpmcdsDate((long)INTEGER(baseDate_input)[0], 
			  (long)INTEGER(baseDate_input)[1], 
			  (long)INTEGER(baseDate_input)[2]);

    printf("baseDate----%lu", baseDate);

    todayDate_input = coerceVector(todayDate_input,INTSXP);
    todayDate = JpmcdsDate((long)INTEGER(todayDate_input)[0], 
		       (long)INTEGER(todayDate_input)[1], 
		       (long)INTEGER(todayDate_input)[2]);

    valueDate_input = coerceVector(valueDate_input,INTSXP);
    valueDate = JpmcdsDate((long)INTEGER(valueDate_input)[0], 
			   (long)INTEGER(valueDate_input)[1], 
			   (long)INTEGER(valueDate_input)[2]);

    benchmarkStartDate_input = coerceVector(benchmarkStartDate_input,INTSXP);
    benchmarkStartDate = JpmcdsDate((long)INTEGER(benchmarkStartDate_input)[0], 
				    (long)INTEGER(benchmarkStartDate_input)[1], 
				    (long)INTEGER(benchmarkStartDate_input)[2]);

    stepinDate_input = coerceVector(stepinDate_input,INTSXP);
    stepinDate = JpmcdsDate((long)INTEGER(stepinDate_input)[0], 
		       (long)INTEGER(stepinDate_input)[1], 
		       (long)INTEGER(stepinDate_input)[2]);

    startDate_input = coerceVector(startDate_input,INTSXP);
    startDate = JpmcdsDate((long)INTEGER(startDate_input)[0], 
		       (long)INTEGER(startDate_input)[1], 
		       (long)INTEGER(startDate_input)[2]);

    endDate_input = coerceVector(endDate_input,INTSXP);
    endDate = JpmcdsDate((long)INTEGER(endDate_input)[0], 
		       (long)INTEGER(endDate_input)[1], 
		       (long)INTEGER(endDate_input)[2]);

    printf("todayDate----%lu\n", todayDate);
    printf("valueDate----%lu\n", valueDate);
    printf("bmDate----%lu\n", benchmarkStartDate);
    printf("stepinDate----%lu\n", stepinDate);
    printf("startDate----%lu\n", startDate);
    printf("endDate----%lu\n", endDate);

    /*  */
    /*  */
    char* pt_types;

    types = coerceVector(types, STRSXP);
    pt_types =  (char *) CHAR(STRING_ELT(types, 0));
    printf("types----%c\n", pt_types[0]);
    printf("types----%c\n", pt_types[1]);
    printf("types----%c\n", pt_types[10]);
    holidays = coerceVector(holidays, STRSXP);
    pt_holidays =  (char *) CHAR(STRING_ELT(holidays, 0));
    n = strlen(CHAR(STRING_ELT(types, 0))); // for zerocurve



    rates = coerceVector(rates,REALSXP);
    mmDCC = coerceVector(mmDCC,REALSXP);
    fixedSwapFreq = coerceVector(fixedSwapFreq,REALSXP);
    floatSwapFreq = coerceVector(floatSwapFreq,REALSXP);
    fixedSwapDCC = coerceVector(fixedSwapDCC,REALSXP);
    floatSwapDCC = coerceVector(floatSwapDCC,REALSXP);

    badDayConvZC = AS_CHARACTER(badDayConvZC);
    pt_badDayConvZC = CHAR(asChar(STRING_ELT(badDayConvZC, 0)));

    printf("badDayConv...|%c|\n", *pt_badDayConvZC);

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


    printf("build discCurve---laaaaaaaaaaaaaaa\n");

    /* printf("baseDate--%lu\n", baseDate); */
    /* printf("pt_types--%c\n", *pt_types); */
    /* printf("dates_main--%lu\n", *dates_main); */
    /* printf("rates--%f\n", rates); */
    /* printf("nnnnnnnn--%i\n", n); */
    /* printf("mmDCC--%i\n", mmDCC_zc_main); */
    /* printf("freq--%i\n", freq); */
    /* printf("dcc--%i\n", dcc); */
    /* printf("pt_badDayConv--%c\n", *pt_badDayConvZC); */
    /* printf("holidays--%c\n", *pt_holidays); */

    /* printf("curve---laaaaaaaaaaaaaaa\n"); */

  // This step is the BuildExampleZeroCurve function in main.c under \examples    
    discCurve = (TCurve*)malloc(sizeof(TCurve));
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
				       (char) *pt_badDayConvZC,
				       pt_holidays);

    printf("tcurve fnumitems %i\n", discCurve->fNumItems);
    printf("tcurve farray %f\n", *(discCurve->fArray));
    printf("tcurve fBaseDate %i\n", discCurve->fBaseDate);
    printf("tcurve fBasis %f\n", discCurve->fBasis);
    printf("tcurve fDayCountConv %lu\n", discCurve->fDayCountConv);

    printf("done building discCurve---\n");

    if (discCurve == NULL) printf("NULL...\n");

    couponRate = *REAL(couponRate_input);
    printf("coupon rate---%f\n", couponRate);
    payAccruedOnDefault = *LOGICAL(payAccruedOnDefault_input);
    printf("accruedOnDefault Logical---%i\n", payAccruedOnDefault);


    /*  */
    /*  */
    pt_dateInterval = (TDateInterval*)malloc(sizeof(TDateInterval));
    pt_dateInterval->prd_typ = *CHAR(STRING_ELT(coerceVector(dateInterval, STRSXP), 0));
    pt_dateInterval->prd = 6;
    pt_dateInterval->flag = 0;
    printf("dateInterval...|%c|\n", pt_dateInterval->prd_typ);

    /*  */
    /*  */
    TBoolean stubAtEnd = FALSE;
    TBoolean longStub = FALSE;
    pt_stubType = (TStubMethod*)malloc(sizeof(TStubMethod));
    pt_stubType->stubAtEnd = stubAtEnd;
    pt_stubType->longStub = longStub;

    printf("what is stubAtEnd----%i", stubAtEnd);
    /*  */
    /*  */


    //    pt_stubType = LOGICAL(stubType);
    //    printf("stubType Logical---%i\n", *pt_stubType);
    //printf("accrueDCC input---%f\n", *REAL(accrueDCC_input));
    accrueDCC = *INTEGER(accrueDCC_input);
    printf("accrueDCC ---%i\n", accrueDCC);
    badDayConv = *INTEGER(badDayConv_input);
    printf("badDayConv---%i\n", badDayConv);
    pt_calendar = (char *) CHAR(STRING_ELT(coerceVector(calendar_input, STRSXP), 0));
    upfrontCharge = *REAL(upfrontCharge_input);
    printf("upfront---%f\n", upfrontCharge);
    recoveryRate = *REAL(recoveryRate_input);
    printf("recovery---%f\n", recoveryRate);
    payAccruedAtStart = *LOGICAL(payAccruedAtStart_input);
    printf("payAccruedAtStart Logical---%i\n", payAccruedAtStart);
    //    pt_oneSpread = REAL(oneSpread);
    
    context.today               = todayDate;
    context.valueDate           = valueDate;
    context.benchmarkStartDate  = benchmarkStartDate;
    context.stepinDate          = stepinDate;
    context.startDate           = startDate;
    context.endDate             = endDate;
    context.couponRate          = couponRate;
    context.payAccruedOnDefault = payAccruedOnDefault;
    context.dateInterval        = pt_dateInterval;
    context.stubType            = pt_stubType;
    context.accrueDCC           = accrueDCC;
    context.badDayConv          = badDayConv;
    context.calendar            = pt_calendar;
    context.discCurve           = discCurve;
    context.upfrontCharge       = upfrontCharge;
    context.recoveryRate        = recoveryRate;
    context.payAccruedAtStart   = payAccruedAtStart;
     
    printf("context ok\n");
    printf("maybe onespread ip---%d", pt_onespread);
    printf("what are we putting into findbrent?---%f", *pt_onespread);
    //    *pt_onespread = 3;

    /* int a; */
    /* a = JpmcdsRootFindBrent ((TObjectFunc)cdsoneSpreadSolverFunction, */
    /* 			     &context, */
    /* 			     0.0,    /\* boundLo *\/ */
    /* 			     100.0,  /\* boundHi *\/ */
    /* 			     100,    /\* numIterations *\/ */
    /* 			     0.01,   /\* guess *\/ */
    /* 			     0.0001, /\* initialXStep *\/ */
    /* 			     0.0,    /\* initialFDeriv *\/ */
    /* 			     1e-8,   /\* xacc *\/ */
    /* 			     1e-8,   /\* facc *\/ */
    /* 			     pt_onespread); */
    /* printf("what is a??????%i\n", a); */
    if (JpmcdsRootFindBrent ((TObjectFunc)cdsoneSpreadSolverFunction,
			     &context,
			     0.0,    /* boundLo */
			     100.0,  /* boundHi */
			     100,    /* numIterations */
			     0.01,   /* guess */
			     0.0001, /* initialXStep */
			     0.0,    /* initialFDeriv */
			     1e-8,   /* xacc */
			     1e-8,   /* facc */
			     pt_onespread) != SUCCESS)
      goto done;      

 done:

    /* printf("rootFindBrent Done\n"); */
    PROTECT(status = allocVector(REALSXP, 1));
    REAL(status)[0] = (*pt_onespread) * 1e4;
    /* printf("assign value done---%f", *pt_onespread); */
    UNPROTECT(1);

    //    if (status != SUCCESS)
    //    JpmcdsErrMsgFailure (routine);
    return status;
}
