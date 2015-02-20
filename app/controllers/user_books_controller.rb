class UserBooksController < ApplicationController

  def destroy
    user_book = UserBook.find_by(user_id: params[:user_id].to_i, book_id: params[:book_id].to_i)
    user_book.destroy
  end
end
