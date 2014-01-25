#include "toy1.h"
#include <Rdefines.h>
#include <Rinternals.h>

SEXP Tuotuo
(SEXP a, SEXP tuostr){
  SEXP tuotuo;
  int A, B, n;
  a = coerceVector(a,INTSXP);
  tuostr = coerceVector(tuostr, STRSXP);
  A = INTEGER(a)[0];
  B = INTEGER(a)[1];
  //  B = HeidiPlus(A, A);
  //  n = strlen(STRING(tuostr)[0]);
  //  PROTECT(tuotuo = allocVector(INTSXP, 2));
  PROTECT(tuotuo = allocVector(INTSXP, 2));
  //  PROTECT(tuotuo = strlen(CHAR(STRING_ELT(tuostr, 0))));
  //INTEGER(tuotuo)[0] = strlen(CHAR(STRING_ELT(tuostr, 0)));
  INTEGER(tuotuo)[0] = A;
  INTEGER(tuotuo)[1] = B;
  UNPROTECT(1);
  return tuotuo;
}
