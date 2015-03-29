Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: '/auth'

  mount_devise_token_auth_for 'Admin', at: 'admin_auth'
  as :admin do
    # Define routes for Admin within this block.
  end

  get "/books", to: "books#index", as: :books
  get "/books/search", to: "books#search"

  get "/books/:id", to: "books#show", as: :book
  get "/books/:id/subjects", to: "books#subjects"

  get "/subjects", to: "subjects#index", as: :subjects

  get '/users/usernames', to: "users#usernames"

  get "/users/:id", to: "users#show", as: :user
  get "/users/:user_id/books", to: "users#books"
  get "/users/:user_id/books/genres", to: 'users#genres'

  get "/users/:user_id/badges", to: "users#badges"

  post "/users/:user_id/books/new", to: "users#add_book"

  delete "/user_books", to: "user_books#destroy"

  get "/genres", to: "genres#index", as: "genres"

  get "/genre_badges", to: "genre_badges#index", as: :genre_badges
  get "/genre_badges/:id", to: "genre_badges#show", as: :genre_badge

  root to: "books#home"

end
