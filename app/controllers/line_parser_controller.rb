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
      upload_krem_file(uploaded_io)
      redirect_to root_path flash['success'] = "File uploaded successfully! - #{uploaded_io.original_filename}"
    else
      redirect_to root_path flash['error'] = "No file selected - please choose a file to upload"
    end
  end
end
