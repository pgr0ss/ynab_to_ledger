require "csv"

def main
  csv = File.read(ARGV.first, encoding: "bom|utf-8")
  output = process(csv)

  File.open("ynab_ledger.dat", "w") { |f| f.write(output) }
end

def process(csv)
  entries = CSV.parse(csv, headers: true).map do |row|
    ledger_entry(row)
  end

  entries.compact.reverse.join("\n")
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

  return if source == ""

  <<END
#{year}/#{month}/#{day} #{row["Payee"]}#{row["Memo"]}
    #{source}  #{outflow}
    #{row["Account"]}  #{inflow}
END
end

def blank_if_zero(amount)
  amount =~ /\A(\$|€)?0(\.0+)?\z/ ? "" : amount
end

main if __FILE__ == $0
