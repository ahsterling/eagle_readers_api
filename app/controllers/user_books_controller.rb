class UserBooksController < ApplicationController

  def destroy
    user_book = UserBook.find_by(user_id: params[:user_id], book_id: params[:book_id])
    user_book.destroy
  end
end
