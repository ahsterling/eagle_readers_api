class UsersController < ApplicationController

  before_action :authenticate_user!, except: [:usernames]

  def show
    @user = User.find(params[:id])
    render json: @user.as_json
  end

  def books
    user = User.find(params[:user_id])
    @books = user.books
    render json: @books.as_json
  end

  def badges
    user = User.find(params[:user_id])
    @badges = user.genre_badges
    render json: @badges.as_json
  end

  def add_book
    UserBook.create(user_id: params[:user_id], book_id: params[:book_id])
    user = User.find(params[:user_id])
    GenreBadge.all.each do |badge|

      unless user.already_has_badge(badge.id)
      # check for bulk badges
        if badge.bulk_badge == true
          if user.has_bulk_genre_badge?(badge.genre_name)
            UserGenreBadge.create(user_id: user.id, genre_badge_id: badge.id)
          end
        # check for explorer badges
        elsif badge.explorer_badge == true
          if user.has_genre_explorer_badge?
            UserGenreBadge.create(user_id: user.id, genre_badge_id: badge.id)
          end
        # check for standard genre badges
        elsif user.has_genre_badge?(badge.genre_name)
          UserGenreBadge.create(user_id: user.id, genre_badge_id: badge.id)
        end
      end
    end

    @book = Book.find(params[:book_id])
    render json: @book.as_json
  end

  def usernames
    render json: USERNAMES.as_json
  end

end
