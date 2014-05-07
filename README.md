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

SNAC
- Standard CDS contract specification [http://www.cdsmodel.com/assets/cds-model/docs/Standard%20CDS%20Contract%20Specification.pdf](http://www.cdsmodel.com/assets/cds-model/docs/Standard%20CDS%20Contract%20Specification.pdf)
- Contracts are always traded with a maturity date falling on one of the four roll dates, March/July/Sept/Dec 20. The maturity date is rounded up to the next roll date. 
- If the maturity date falls on a non-business day, then it's moved to the following business day.
- Coupons are paid on a quarterly basis.
- The size of the coupon payment is calculated on ACT/360. 
- Full first coupon is paid on the next available roll date.
- The protection seller pays the protection buyer accrued interest prportional to the time between the last roll date and trade date.
- Backstop date is the date from which protection is provided. Backstop date = current date - 60 calendar days
- For an all-running contract, the spread quoted is the par spread and it is precisely the coupon that is agreed for the premium leg in return for credit event protection.
- PV01 is the PV of a stream of 1 bp payments at each CDS coupon date.
- MTM = (current par spread - original par spread) * current PV01.
- Upfront payment = (par spread - coupon rate) * PV01
- Quoted spread for low spread (IG) names, and points upfront for high spread (HY) names


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
- "One further point to note, is that the ISDA model is quite general
about the contact spec- ification. It can be used to price CDSs with
any maturity date (it knows nothing about IMM dates), start date and
payment interval. So the contract specifics are inputs to the model -
for standard contracts, this would be a maturity date on the relevant
IMM date, a start date of the IMM date immediately before the trade
date, and quarterly premium payments." (OpenGamma)
- Standard maturity date are unadjusted – always Mar/Jun/Sep/Dec 20th. ISDAhttp://www.cdsmodel.com/assets/cds-model/docs/Standard%20CDS%20Examples.pdf
  - Example: As of Feb09, the 1y standard CDS contract would protect the buyer through Sat 20Mar10. 
- Coupon payment dates are like standard maturity dates, but business day adjusted following (ISDA)


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
- Rec Risk (1%): Dollar value change in Market Value if the recovery rate in the spreads section were increased by 1%.
- Default Exposure: (1-Recovery Rate)*Notional - Principal


