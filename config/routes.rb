Rails.application.routes.draw do
  resources :sleep_records, only: [:index] do
    post "clock_in", on: :collection
    post "clock_out", on: :collection
    get "feed", on: :collection
  end

  post "/follow", to: "follows#follow"
  post "/unfollow", to: "follows#unfollow"
end
