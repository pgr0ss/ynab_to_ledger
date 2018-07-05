# ynab_to_ledger

Convert a YNAB ([You Need a Budget](https://www.youneedabudget.com)) export to a [Ledger](http://ledger-cli.org) journal.

## Usage

First, export your data from YNAB:

* Go to My Budget -> Export budget data
* Download and unzip the archive

Next, run `ynab_to_ledger.rb` to convert the export to a Ledger file:

`ruby ynab_to_ledger.rb My\ Budget\ as\ of\ 2016-10-02\ 1007\ PM\ -\ Register.csv`

This will write out a `ynab_ledger.dat` journal.

## Reporting

Now that you've got a Ledger journal, you can use the Ledger command line to run reports. For example:

View a monthly register:

`ledger register -f ynab_ledger.dat --monthly`

You can filter the register down to just the category you care about:

`ledger register -f ynab_ledger.dat --monthly Dining Out`

And you can even see a running average of the amount:

`ledger register -f ynab_ledger.dat --monthly --average Dining Out`

Balances for a single month summed by category:

`ledger balance -f ynab_ledger.dat --begin 2016-09-01 --end 2016-10-01 --depth 1`

You can see more reports at http://ledger-cli.org/3.0/doc/ledger3.html#Building-Reports

## hledger

[hledger](http://hledger.org/) (a port of Ledger) provides some reporting that Ledger does not. For example, you can view a monthly register rolled up by category:

`hledger register -f ynab_ledger.dat --monthly --depth 1`

Multicolumn balance report by month with averaging:

`hledger balance -f ynab_ledger.dat --average --monthly --begin 2017-01-01 --end 2017-12-31`
