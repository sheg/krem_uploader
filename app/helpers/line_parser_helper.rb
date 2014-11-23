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

    file = File.open(input, "r")
    file.each_line do |line|

      if line.match(/^01/) && !first_found
        File.open(output, 'a+') { |f| f.write line.gsub(',,', ',') }
        first_found = true
      end

      if line.match(/^02/) && !second_found
        File.open(output, 'a+') { |f| f.write line.gsub(',,', ',') }
        second_found = true
      end

      if line.match(/^03/) || line.match(/^88,400/) || line.match(/^88,100/)
        File.open(output, 'a+') { |f| f.write line.gsub(',,', ',') }
      end

      if line.match(/^49/)
        line_array = line.split(',')
        blanked_line_array = line_array.each_with_index.map do |value, index|
          if index == 1
            value.gsub(/\d/, '0')
          else
            value
          end
        end
        value = blanked_line_array.join(',')
        File.open(output, 'a+') { |f| f.write value }
      end
    end
  end
end
