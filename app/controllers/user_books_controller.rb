class UserBooksController < ApplicationController

  def destroy
    user_book = UserBook.find_by(user_id: params[:user_id].to_i, book_id: params[:book_id].to_i)
    user_book.destroy
    user = User.find(params[:user_id])
    book = Book.find(params[:book_id])
    response = {user_book: user_book, badges_removed: []}

    unless user.has_genre_badge?(book.genre.name)
      genre_badge = GenreBadge.find_by(genre_name: book.genre.name)

      user_genre_badge = UserGenreBadge.find_by(user_id: user.id, genre_badge_id: genre_badge.id)
      if user_genre_badge
        response[:badges_removed] << user_genre_badge
        user_genre_badge.destroy
      end
    end

    unless user.has_bulk_genre_badge?(book.genre.name)
      genre_badge = GenreBadge.find_by(genre_name: book.genre.name, bulk_badge: true)
      puts "user id: #{user.id}"
      puts "genre_badge id: #{genre_badge.id}"
      user_genre_badge = UserGenreBadge.find_by(user_id: user.id, genre_badge_id: genre_badge.id)
      if user_genre_badge
        response[:badges_removed] << user_genre_badge
        user_genre_badge.destroy
      end
    end

    unless user.has_genre_explorer_badge?
      explorer_badge = GenreBadge.find_by(explorer_badge: true)
      user_genre_badge = UserGenreBadge.find_by(user_id: user.id, genre_badge_id: explorer_badge.id)
      if user_genre_badge
        response[:badges_removed] << user_genre_badge
        user_genre_badge.destroy
      end
    end

    render json: response.as_json

  end
end
