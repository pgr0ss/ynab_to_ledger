require 'csv'

def main
  entries = CSV.read(ARGV.first, headers: true, encoding: "BOM|UTF-8").map do |row|
    ledger_entry(row)
  end

  File.open("ynab_ledger.dat", "w") do |f|
    f.puts entries.compact.reverse.join("\n")
  end
end

def ledger_entry(row)
  inflow = blank_if_zero(row["Inflow"])
  outflow = blank_if_zero(row["Outflow"])

  return if inflow == "" && outflow == ""

  month, day, year = row["Date"].split("/")

  if row["Payee"].include?("Transfer :")
    return if outflow == ""
    source = row["Payee"].split(":").last.strip
  else
    source = row["Category Group/Category"]
  end

  <<END
#{year}/#{month}/#{day} #{row["Payee"]}#{row["Memo"]}
    #{source}             #{outflow}
    #{row["Account"]}     #{inflow}
END
end

def blank_if_zero(amount)
  amount == "$0.00" ? "" : amount
end

main if __FILE__ == $0
