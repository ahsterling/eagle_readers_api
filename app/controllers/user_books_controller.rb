class UserBooksController < ApplicationController

  def destroy
    user_book = UserBook.find_by(id: params[:id])
    user_book.destroy
  end
end
