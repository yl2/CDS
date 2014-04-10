CDS
========================================================
Heidi Chen 
s.heidi.chen at gmail.com

David Kane
dave.kane at gmail.com

Yang Lu 
yang.lu2014 at gmail.com

CDS To-Do's
--------------------------------------------------------


To-Do's
- Make a function to calculate default probability in decimal (defaultProb)
- Make functions to calculate RecRisk01
- Test cases for getRates.R

Existing R function files
- calcUpfront.R calculates cash settlement amount from conventional spread
- calcSpread.R calculates conventional spread from upfront
- CDS.R constructs a primitive CDS class object. More to implement once spreadDV01 and IR DV01 functions become available.
- calcSpreadDV01.R calculates spread DV 01
- calcIRDV01.R calculates IR DV 01
- getRates.R obtains rates to build an interest rate curve for CDS calculation

Notes
- Fixed payment from the protection buyer is the "premium leg"
- Payment of notional less recovery by the protection seller in the event of a default is the "contingent leg"
- Upfront paymant is often quoted in percent of notional.
- In general, the market still quotes CDS on investment grade names in terms of their running spread, while high yield name are quoted on an upfront basis.
- Typically interested in 5-year protection
- DCC: day count convention. ACT/FixedNumber where ACT is the actual
number of days between two events and the fixed denominator is 360 or
365. ACT/365 is often referred to as ACT/365 Fixed or ACT/365F. More details at http://developers.opengamma.com/quantitative-research/Interest-Rate-Instruments-and-Market-Conventions.pdf
- The cash settlement value (or dirty price from bond lexicon) of a CDS
is the discounted value of expected future cash flows, and ignores the
accrued premium. What is normally quoted is the upfront fee or cash
amount (the clean price), which is simply the dirty price with any
accrued interest added. For a newly issued legacy CDS, there is no
accrued interest (recall, interest accrues from T+1), so dirty and
clean price are the same. (OpenGamma)


Deal Section (From Bloomberg manual)
- Trade spread: the spread that the deal was initially struck at.
- Business Day: It controls which country's holiday calendar will be used when adjusting cash flow dates for non-settlement days. It will default to the country of the underlying company. For standard deals, a 5D, non holiday calendar is used.
- Business Day Adjustment: It controls how the cashflow dates are adjusted when they fall on non-settlement days.
- Notional: the principal amount on which the payments are based.
- Freq: the frequency at which the Deal Spread payments are made. Normally Q basis in CDS contracts.
- Pay AI: It determines whether accrued interest is paid on a default. If a company defaults between payment dates, there is a certain amount of accrued payment that is owed to the protection seller. "True" means that this accrued will need to be paid by the protection buyer, "False" otherwise.
- Currency: It specifies the currency for the Market Value, Accrued and DV01. It will default to the currency of the underlying company.
- Day Cnt: The day count method to calculate coupon periods/payments as well as accrued interest.
- Date Gen: The method to generate the coupon dates. I: IMM dates; F: forward from the effective date; B: backward from the maturity date; M: monthly IMM dates.
- Backstop date: 60 day look back from which protection is "effective"


Market Section (From Bloomberg manual)
- Curve Date: It determines which date is used for the values of the benchmark curve. It will default to the current date.
- Recovery rate: Expressed in a decimal.
- Term: Maturity date.
- Pts Upf: Upfront payment with each spread.
- Spread: In bps. It is the Par CDS spread for each maturity.
- Prob: It is the default probability of the underlying reference for each maturity. In other words, it is the cumulative probability that a company will default by a given time. 

Calculator Section (From Bloomberg manual)
- Valuation Date: The date used for all accrued interest and present value calculations. It can be thought of as the settle date for the transaction.
- Cash Settled On: The date on which the cash value of the underlying asset is delivered to satisfy the contract, usually T+3.
- Cash Calculated On: The date on which the cash value of the underlying asset is calculated to satisfy the contract, usually T+3. This differs from the above in that settle date uses a 5D calendar generally, but the actual calculations follow holiday schedules.
- Price: Clean dollar price of the contract. Price = (1 - Principal/Notional)*100. Or Price = 1 0 Pts Upf.
- Principal: Market Value of the deal minus any accrued interest.
- Accrued: Interest accrued to the protection seller. 
- MTM: Principal + Accrued
- Cash Amount: MTM value future valued 3 business days to the Cash Settled on Date.
- Spread DV01: Dollar value change in Market Value if the CDS Spread goes up by 1 bp at every point on the Spread Curve.
- IR DV01: Dollar value change in Market Value if the benchmark interest rate goes up by 1 bp every point on the curve.
- Rec Risk (1%): Dollar value change in Market Value if the recovery rate in the spreads section were shift by 1%.
- Default Exposure: (1-Recovery Rate)*Notional - Principal


