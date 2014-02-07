#include "toy1.h"

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


int HeidiPlus
(double *a,
 int b	      
){
  double heidi;
  //  heidi = (*a_ptr)[0] + (*a_ptr)[1] + b;
  //  heidi = *(a[0]) + *(a[1]) + b;
  printf("heidiplus1 %f \n", (a[0] + a[1] + b));
  //  printf("heidiplus2 %f \n", *a[0]);
  heidi = a[0] + a[1] + b;

  return(heidi);
}
