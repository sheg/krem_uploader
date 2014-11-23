KremParser::Application.routes.draw do

  root "line_parser#index"
  match '/upload', to: "line_parser#upload", via: :all
  match '/download_krem', to: "line_parser#download_krem", via: :all
  match '/download_page', to: "line_parser#download_page", via: :get


end
