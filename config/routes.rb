Rails.application.routes.draw do
 # Health Check
 # ---
  get "/ping", to: "ping#show"

 # API V1
 # ---
  draw :api_v1
end
