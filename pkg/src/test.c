/* #include <R.h> */
/* #include <Rdefines.h> */
/* #include <time.h> */
/* #include "cgeneral.h" */
/* #include "convert.h" */
/* #include "dateconv.h" */
/* #include "macros.h" */
/* #include "cerror.h" */

/* /\* #include <Rcpp.h> *\/ */
/* /\* using namespace Rcpp; *\/ */
/* // [[Rcpp::export]] */

/* // TDate JpmcdsDate */
/* SEXP JpmcdsDate */
/* (long year,  /\* (I) Year *\/ */
/*  long month, /\* (I) Month *\/ */
/*  long day    /\* (I) Day *\/ */
/* ) */
/* { */
/*     static char routine[]="JpmcdsDate"; */

/*     TMonthDayYear mdy; */
/*     // TDate         date; /\* returned *\/ */
/*     SEXP         date; /\* returned *\/ */

/*     mdy.month = month; */

/*     mdy.day   = day; */
/*     mdy.year  = year; */

/*     // if (JpmcdsMDYToDate (&mdy, &date) != SUCCESS) */
/*     //   { */
/*     //     JpmcdsErrMsg ("%s: Failed.\n", routine); */
/*     //     date = FAILURE; */
/*     //   } */
/*     date = 333; */
/*     return date; */
    
/* } */
