class ApplicationController < ActionController::API
  include ActionController::Helpers
  include ActionController::Cookies
  include DeviseTokenAuth::Concerns::SetUserByToken
  include ActionController::RequestForgeryProtection
  # protect_from_forgery with: :exception

end
