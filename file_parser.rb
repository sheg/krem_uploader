require "csv"
require "pry"

input = ARGV[0]
output = ARGV[1]

first_found = false
second_found = false
File.open(output, "w") {}
CSV.foreach(input) do |row|

  if (row[0] == "01") && !first_found
    File.open(output, 'a+') { |f| f.puts row.join(',') }
    first_found = true
  end

  if (row[0] == "02") && !second_found
    File.open(output, 'a+') { |f| f.puts row.join(',') }
    second_found = true
  end

  if (row[0] == "03")
    File.open(output, 'a+') { |f| f.puts [row[0], row[1], row[2], row[-1]].join(',') }
  end
  
  if (row[0] == "88")
    get_100_index_value = row.index("100")
    value_100 = row[get_100_index_value + 1] if !get_100_index_value.nil? && get_100_index_value > 0
    get_400_index_value = row.index("400")
    value_400 = row[get_400_index_value + 1] if !get_400_index_value.nil? && get_400_index_value > 0
    unless value_100.nil?
      File.open(output, 'a+') { |f| f.puts [row[0], 100, value_100, "0000000,S,000000000000000,000000000000000,000000000000000/"].join(',') }
    end
    unless value_400.nil?
      File.open(output, 'a+') { |f| f.puts [row[0], 400, value_400, "0000001/"].join(',') }
    end
  end
  
  if (row[0] == "49")
    File.open(output, 'a+') { |f| f.puts [row[0], "000000000000000,000061/"].join(",") }
  end
end
