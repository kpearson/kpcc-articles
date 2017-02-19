Rails.application.routes.draw do
  root "search#new", to: "/"
  get  "/search", to: "search#index"
end
