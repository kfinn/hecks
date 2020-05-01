Rails.application.routes.draw do
  root to: 'home#get'
  get 'home/get'
end
