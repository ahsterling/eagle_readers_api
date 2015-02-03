class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
    render json: @user.as_json
  end

  def books
    user = User.find(params[:user_id])
    @books = user.books
    render json: @books.as_json
  end

  def add_book
    UserBook.create(user_id: params[:user_id], book_id: params[:book_id])
    @book = Book.find(params[:book_id])
    render json: @book.as_json
  end

end
