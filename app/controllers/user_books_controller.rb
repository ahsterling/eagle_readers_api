class UserBooksController < ApplicationController

  def destroy
    user_book = UserBook.find_by(user_id: params[:user_id].to_i, book_id: params[:book_id].to_i)
    user_book.destroy
    user = User.find(params[:user_id])
    book = Book.find(params[:book_id])
    unless user.has_genre_badge?(book.genre.name)
      genre_badge = GenreBadge.find_by(genre_name: book.genre.name)
      puts genre_badge.id
      UserGenreBadge.find_by(user_id: user.id, genre_badge_id: genre_badge.id).destroy
    end
  end
end
