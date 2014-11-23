KremParser::Application.routes.draw do

  root "line_parser#index"
  match '/upload', to: "line_parser#upload", via: :all
end
