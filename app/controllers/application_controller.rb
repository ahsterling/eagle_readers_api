class ApplicationController < ActionController::API
  include ActionController::Helpers
  include ActionController::Cookies
  protect_from_forgery with: :null_session
end
