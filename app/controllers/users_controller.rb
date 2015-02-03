class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
    render json: @user.as_json
  end

  def books
    user = User.find(params[:id])
    @books = user.books
    render json: @books.as_json
  end

end
