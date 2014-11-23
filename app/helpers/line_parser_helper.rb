module LineParserHelper

  def upload_krem_file(uploaded_io)
    if uploaded_io.content_type == "text/plain"
      upload_folder = Rails.root.join('uploads')
      unless File.directory?(upload_folder)
        FileUtils.mkdir(upload_folder)
      end
      full_path = Rails.root.join(upload_folder, uploaded_io.original_filename)
      File.open(full_path, 'wb') { |file| file.write(uploaded_io.read) }
      cookies[:json_file] = { :value => full_path, :expires => 30.minutes.from_now.utc }
    end
  end
end
