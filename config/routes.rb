Rails.application.routes.draw do
  resources :sleep_records, only: [:index] do
    post "clock_in", on: :collection
    post "clock_out", on: :collection
  end
end
