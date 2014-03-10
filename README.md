CDS
========================================================
Heidi Chen 
s.heidi.chen at gmail.com

David Kane
dave.kane at gmail.com

Yang Lu 
yang.lu2014 at gmail.com

CDS To-Do's
========================================================

Definitions
- Fixed payment from the protection buyer is the "premium leg"
- Payment of notional less recovery by the protection seller in the event of a default is the "contingent leg"
- Trade spread (deal spread) in bps is the conventional spread 
- price = 100 - pt. upfront
- principal = upfront * notional (typically 10mm)


Deal Section
- Business Day controls which country's holiday calendar will be used when adjusting cash flow dates for non-settlement days. It will default to the country of the underlying company.  default 5D, 


- Able to specify trade date, maturity, recovery rate, deal spread
- Typically interested in 5-year protection


Qns
- Figure out how different types of accruals work
- Figure out the default swap curve used in the ISDA model (USD first)
- Function to calculate default probability (Bloomberg mkt section). In bps p.a.?
- pt. upfront in percentage of notional amount
- spreadDV01: what would happen to the principal if spread increases by 1 bps
- test cases for Spread DV01 and IR DV01

Existing R function files
- calcUpfront.R: calculates cash settlement amount from conventional spread
- calcSpreadTest.R: calculates conventional spread from upfront



