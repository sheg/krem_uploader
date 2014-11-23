class LineParserController < ApplicationController
  include LineParserHelper

  def index
  end

  def upload
    uploaded_io = params[:krem_file]
    if uploaded_io
      unless uploaded_io.content_type == "text/plain"
        return redirect_to root_path flash['error'] = "Only .txt files are accepted - #{uploaded_io.content_type}"
      end

      upload_path = upload_text_file(uploaded_io)
      krem_name = upload_path.to_s.gsub(".txt", "_krem.txt")
      generate_krem_file(upload_path, krem_name)

      flash['success'] = "File uploaded successfully! - #{uploaded_io.original_filename}"
      redirect_to download_page_path(:path => URI.encode(krem_name))
    else
      redirect_to root_path flash['error'] = "No file selected - please choose a file to upload"
    end
  end

  def download_page
    @file_path = params[:path]
  end

  def download_krem
    path = URI.decode(params[:path])
    send_file File.open(path),
              filename: path.split('/')[-1],
              type: "text/plain"
  end
end