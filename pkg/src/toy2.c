#include "toy1.h"
#include <Rdefines.h>
#include <Rinternals.h>

#include <stdarg.h>
#include <stdio.h>

#include "version.h"
#include "macros.h"
#include "cerror.h"
#include "tcurve.h"
#include "cdsone.h"
#include "convert.h"
#include "zerocurve.h"
#include "cds.h"
#include "cxzerocurve.h"
#include "dateconv.h"
#include "date_sup.h"
#include "busday.h"
#include "ldate.h"

#include "cmemory.h"



SEXP Tuotuo
(SEXP a, SEXP tuostr){
  SEXP tuotuo;
  //  int A, B, n;
  double *A, B, n;

  //a = coerceVector(a,INTSXP);
  a = coerceVector(a,REALSXP);
  tuostr = coerceVector(tuostr, STRSXP);
  //A = INTEGER(a)[0];
  A = REAL(a); // INTEGER(vector) returns pointer type
  // B = INTEGER(a)[1];
  printf("got a-------");
  B = HeidiPlus(A, 1);
  printf("got b-------");
  //  n = strlen(CHAR(STRING_ELT(tuostr, 0)));
  //  PROTECT(tuotuo = allocVector(INTSXP, 2));
  /* char         *types = "MMMMMSSSSSSSSS"; */
  /* n = strlen(types); */
  /*   TDate *dates_main = NULL; */
  /*   dates_main = NEW_ARRAY1(TDate, n); */


  //  PROTECT(tuotuo = allocVector(INTSXP, 2));
  PROTECT(tuotuo = allocVector(REALSXP, 2));
  //  PROTECT(tuotuo = strlen(CHAR(STRING_ELT(tuostr, 0))));
  //INTEGER(tuotuo)[0] = strlen(CHAR(STRING_ELT(tuostr, 0)));
  //  INTEGER(tuotuo)[0] = A[0];
  //  INTEGER(tuotuo)[1] = B;
  REAL(tuotuo)[0] = B;
  REAL(tuotuo)[1] = B;
  UNPROTECT(1);
  return tuotuo;
}

