CDS
========================================================
Heidi Chen 
s.heidi.chen at gmail.com

David Kane
dave.kane at gmail.com

Yang Lu 
yang.lu2014 at gmail.com

Kanishka Malik
kanishkamalik at gmail.com

CDS To-Do's
--------------------------------------------------------
- Vignette

Existing R function files
- CDS.R constructs a primitive CDS class object.
- upfront.R calculates cash settlement amount from conventional spread
- spread.R calculates conventional spread from upfront
- spreadDV01.R calculates spread DV 01
- IRDV01.R calculates IR DV 01
- update.R allows users to update a CDS class object with a new spread, upfront payment, or a points upfront.
- getRates.R obtains rates to build an interest rate curve for CDS calculation
- recRisk01 calculates the RecRisk 01
- defaultProb.R approximates the default probability at time t
- defaultExpo.R calculates the default exposure of a CDS contract
- getDates.R get a set of dates relevant for CDS calculation
- price.R calculates the price of a CDS contract
- CS10.R calculates the change in value of a CDS contract when its spread increases by 10%.