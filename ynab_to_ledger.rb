require "csv"

def main
  entries = CSV.read(ARGV.first, headers: true, encoding: "BOM|UTF-8").map do |row|
    ledger_entry(row)
  end

  File.open("ynab_ledger.dat", "w") do |f|
    f.puts entries.compact.reverse.join("\n")
  end
end

def ledger_entry(row)
  [row["Inflow"], row["Outflow"]].each do |amount|
    begin
      Float(amount)
    rescue
      STDERR.puts "Invalid inflow or outflow: #{amount}, expected to be in format 0.00"
    end
  end

  inflow = blank_if_zero(row["Inflow"])
  outflow = blank_if_zero(row["Outflow"])

  return if inflow == "" && outflow == ""

  month, day, year = row["Date"].split("/")

  begin
    Date.new(Integer(year, 10), Integer(month, 10), Integer(day, 10))
  rescue
    STDERR.puts "Invalid date: #{row["Date"]}, expected mm/dd/yyyy"
  end

  if row["Payee"].include?("Transfer :")
    return if outflow == ""
    source = row["Payee"].split(":").last.strip
  else
    source = row["Category Group/Category"]
  end

  return if source == ""

  <<END
#{year}/#{month}/#{day} #{row["Payee"]}#{row["Memo"]}
    #{source}             #{outflow}
    #{row["Account"]}     #{inflow}
END
end

def blank_if_zero(amount)
  amount =~ /\A\$?0(\.0+)?\z/ ? "" : amount
end

main if __FILE__ == $0
