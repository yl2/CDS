/*
 * ISDA CDS Standard Model
 *
 * Copyright (C) 2009 International Swaps and Derivatives Association, Inc.
 * Developed and supported in collaboration with Markit
 * 
 * This program is free software: you can redistribute it and/or modify it
 * under the terms of the ISDA CDS Standard Model Public License.
 */

#include "cdsone.h"
#include "cds.h"
#include "cerror.h"
#include "rtbrent.h"
#include "tcurve.h"


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
(double               bbgSpread,
 CDSONE_SPREAD_CONTEXT *context,
 double              *diff);


/*
***************************************************************************
** Computes the upfront charge for a flat spread par curve.
***************************************************************************
*/
EXPORT int JpmcdsCdsoneUpfrontCharge
(TDate           today,
 TDate           valueDate,
 TDate           benchmarkStartDate,  /* start date of benchmark CDS for
                                      ** internal clean spread bootstrapping */
 TDate           stepinDate, 
 TDate           startDate,
 TDate           endDate,
 double          couponRate,
 TBoolean        payAccruedOnDefault,
 TDateInterval  *dateInterval,
 TStubMethod    *stubType,
 long            accrueDCC,
 long            badDayConv,
 char           *calendar,
 TCurve         *discCurve,
 double          oneSpread,
 double          recoveryRate,
 TBoolean        payAccruedAtStart,
 double         *upfrontCharge)
{
    static char routine[] = "JpmcdsCdsoneUpfrontCharge";
    int         status    = FAILURE;

    TCurve           *flatSpreadCurve = NULL;
    
    printf("flat currrrrrrrrrrrrrrve---------------------\n");
    printf("today--%lu\n", today);
    printf("valueDate--%lu\n", valueDate);
    printf("bmStart--%lu\n", benchmarkStartDate);
    printf("stepin--%lu\n", stepinDate);
    printf("endDate--%lu\n", endDate);
    printf("onespread--%f\n", oneSpread);
    printf("recovery--%f\n", recoveryRate);
    printf("payAOD--%i\n", payAccruedOnDefault);
    printf("dateInterval--%c\n", dateInterval->prd_typ);
    printf("ivl--%i\n", dateInterval->prd);
    printf("ivl--%i\n", dateInterval->flag);
    printf("stubAtEnd--%i\n", stubType->stubAtEnd);
    printf("stublongStub--%i\n", stubType->longStub);
    printf("dcc--%i\n", accrueDCC);
    printf("badDayConv--%i\n", badDayConv);
    printf("calendar--%c\n", *calendar);
    printf("tcurve fnumitems %i\n", discCurve->fNumItems);
    printf("tcurve farray %f\n", *(discCurve->fArray));
    printf("tcurve fBaseDate %i\n", discCurve->fBaseDate);
    printf("tcurve fBasis %f\n", discCurve->fBasis);
    printf("tcurve fDayCountConv %lu\n", discCurve->fDayCountConv);
    printf("flat currrrrrrrrrrrrrrve----------------\n");



    flatSpreadCurve = JpmcdsCleanSpreadCurve (
        today,
        discCurve,
        benchmarkStartDate,
        stepinDate,
        valueDate,
        1,
        &endDate,
        &oneSpread,
        NULL,
        recoveryRate,
        payAccruedOnDefault,
        dateInterval,
        accrueDCC,
        stubType,
        badDayConv,
        calendar);

    if (flatSpreadCurve == NULL){
      printf("cdsupfrontcharge flatspread null-------------\n");
      goto done;
    }
      
    if (JpmcdsCdsPrice(today,
                       valueDate,
                       stepinDate,
                       startDate,  /* cds can start from past */
                       endDate,
                       couponRate,
                       payAccruedOnDefault,
                       dateInterval,
                       stubType,
                       accrueDCC,
                       badDayConv,
                       calendar,
                       discCurve,
                       flatSpreadCurve,
                       recoveryRate,
                       payAccruedAtStart,
                       upfrontCharge) != SUCCESS){

      printf("cdsupfrontcharge fail cds price");
      goto done;
    }
    printf("cdsupfrontcharge cds price upfront %f~-~-~-~-~-\n", upfrontCharge);
    status = SUCCESS;

 done:

    JpmcdsFreeTCurve(flatSpreadCurve);

    if (status != SUCCESS)
        JpmcdsErrMsgFailure (routine);

    printf("success?????? cdsupfront %i\n", status);
    return status;
}


/*
***************************************************************************
** Computes the flat spread required to match the upfront charge.
***************************************************************************
*/
EXPORT int JpmcdsCdsoneSpread
(TDate           today,
 TDate           valueDate,
 TDate           benchmarkStartDate,  /* start date of benchmark CDS for
                                      ** internal clean spread bootstrapping */
 TDate           stepinDate,
 TDate           startDate,
 TDate           endDate,
 double          couponRate,
 TBoolean        payAccruedOnDefault,
 TDateInterval  *dateInterval,
 TStubMethod    *stubType,
 long            accrueDCC,
 long            badDayConv,
 char           *calendar,
 TCurve         *discCurve,
 double          upfrontCharge,
 double          recoveryRate,
 TBoolean        payAccruedAtStart,
 double         *onespread)
{
    static char routine[] = "JpmcdsCdsoneSpread";
    int         status    = FAILURE;

    CDSONE_SPREAD_CONTEXT context;

    context.today               = today;
    context.valueDate           = valueDate;
    context.benchmarkStartDate  = benchmarkStartDate;
    context.stepinDate          = stepinDate;
    context.startDate           = startDate;
    context.endDate             = endDate;
    context.couponRate          = couponRate;
    context.payAccruedOnDefault = payAccruedOnDefault;
    context.dateInterval        = dateInterval;
    context.stubType            = stubType;
    context.accrueDCC           = accrueDCC;
    context.badDayConv          = badDayConv;
    context.calendar            = calendar;
    context.discCurve           = discCurve;
    context.upfrontCharge       = upfrontCharge;
    context.recoveryRate        = recoveryRate;
    context.payAccruedAtStart   = payAccruedAtStart;
     
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
                          onespread) != SUCCESS)
        goto done;

    status = SUCCESS;

 done:

    if (status != SUCCESS)
        JpmcdsErrMsgFailure (routine);
    return status;
}


/* static function declarations */
static int cdsoneSpreadSolverFunction
(double               onespread,
 CDSONE_SPREAD_CONTEXT *context,
 double              *diff)
{
    double upfrontCharge;

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

    *diff = upfrontCharge - context->upfrontCharge;
    return SUCCESS;
}
