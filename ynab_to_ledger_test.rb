require "minitest/autorun"
require "./ynab_to_ledger"

describe "ynab_to_ledger" do
  it "processes inflow" do
    csv = <<CSV
"Account","Flag","Date","Payee","Category Group/Category","Category Group","Category","Memo","Outflow","Inflow","Cleared"
"Checking","","12/30/2020","ACH Credit","Inflow: To be Budgeted","Inflow","To be Budgeted","",$0.00,$100.45,"Uncleared"
CSV

    output = process(csv)

    assert_equal(<<EXPECTED, output)
2020/12/30 ACH Credit
    Inflow: To be Budgeted  
    Checking  $100.45
EXPECTED
  end

  it "processes outflow" do
    csv = <<CSV
"Account","Flag","Date","Payee","Category Group/Category","Category Group","Category","Memo","Outflow","Inflow","Cleared"
"Credit Card","","12/28/2020","Some Restaurant","Just for Fun: Dining Out","Just for Fun","Dining Out","",$41.04,$0.00,"Cleared"
CSV

    output = process(csv)

    assert_equal(<<EXPECTED, output)
2020/12/28 Some Restaurant
    Just for Fun: Dining Out  $41.04
    Credit Card  
EXPECTED
  end

  it "processes transfers" do
    csv = <<CSV
"Account","Flag","Date","Payee","Category Group/Category","Category Group","Category","Memo","Outflow","Inflow","Cleared"
"Checking","","12/18/2020","Transfer : American Express","","","","",$194.17,$0.00,"Cleared"
"American Express","","12/18/2020","Transfer : Checking","","","","",$0.00,$194.17,"Cleared"
CSV

    output = process(csv)

    assert_equal(<<EXPECTED, output)
2020/12/18 Transfer : American Express
    American Express  $194.17
    Checking  
EXPECTED
  end

  it "blanks out zero amounts" do
    assert_equal("$1.45", blank_if_zero("$1.45"))
    assert_equal("", blank_if_zero("$0.00"))
    assert_equal("", blank_if_zero("€0.00"))
    assert_equal("", blank_if_zero("0.000"))
  end
end
