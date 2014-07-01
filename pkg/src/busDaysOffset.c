#include <Rdefines.h>
#include <Rinternals.h>
#include "version.h"
#include "macros.h"
#include "convert.h"
#include "busday.h"
#include <ctype.h>
#include "bsearch.h"
#include "cerror.h"
#include "dateconv.h"
#include "dtlist.h"
#include "macros.h"
#include "cfileio.h"

#define NEW_ARRAY1(t,n)          (t *) JpmcdsMallocSafe(sizeof(t)*(n))

SEXP busDaysOffset
(SEXP fromDate_input,
 SEXP offset_input,
 SEXP holidays)
{
  TDate fromDate;
  char* pt_holidays;
  SEXP resultDate;
  TDate* toDate_TDate;
  TMonthDayYear* toDate_MDY;
  int offset;

  toDate_TDate = malloc(sizeof(long));
  toDate_MDY = malloc(sizeof(TMonthDayYear));

  fromDate_input = coerceVector(fromDate_input,INTSXP);
  fromDate = JpmcdsDate((long)INTEGER(fromDate_input)[0], 
			(long)INTEGER(fromDate_input)[1], 
			(long)INTEGER(fromDate_input)[2]);

  offset = *INTEGER(offset_input);

  
  holidays = coerceVector(holidays, STRSXP);
  pt_holidays =  (char *) CHAR(STRING_ELT(holidays, 0));

  if(JpmcdsDateFromBusDaysOffset(fromDate, (long)offset, pt_holidays, toDate_TDate)!= SUCCESS)
    goto done;

  if (JpmcdsDateToMDY(*toDate_TDate, toDate_MDY) != SUCCESS)
    goto done;

 done:

  PROTECT(resultDate = allocVector(INTSXP, 3));
  INTEGER(resultDate)[0] = toDate_MDY -> year; 
  INTEGER(resultDate)[1] = toDate_MDY -> month; 
  INTEGER(resultDate)[2] = toDate_MDY -> day; 
  UNPROTECT(1);

  return resultDate;
}
