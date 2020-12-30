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
end
