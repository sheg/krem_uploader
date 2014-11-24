require "csv"
# require "pry"

module LineParserHelper

  def upload_text_file(uploaded_io)
    FileUtils.rm_rf Rails.root.join('uploads')

    if uploaded_io.content_type == "text/plain"
      upload_folder = Rails.root.join('uploads')
      unless File.directory?(upload_folder)
        FileUtils.mkdir(upload_folder)
      end
      full_path = Rails.root.join(upload_folder, uploaded_io.original_filename)
      File.open(full_path, 'wb') { |file| file.write(uploaded_io.read) }
      cookies[:json_file] = { :value => full_path, :expires => 30.minutes.from_now.utc }
      return full_path
    end
  end

  def generate_krem_file(input, output)

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
  end
end