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

  def genres
    user = User.find(params[:user_id])
    @genres = []
    user.books.each do |book|
      unless @genres.include?(book.genre)
        @genres << book.genre
      end
    end
    render json: @genres.as_json
  end

  def add_book
    UserBook.create( user_id: params[:user_id], book_id: params[:book_id] )
    user = User.find(params[:user_id])
    badges_earned = get_badges(user.id)
    book = Book.find(params[:book_id])

    response = { book: book, badges: [] }

    badges_earned.each do |badge|
      response[:badges] << badge
    end
    render json: response.as_json
  end

  def usernames
    render json: USERNAMES.as_json
  end

  private

  def get_badges(user_id)
    user = User.find(user_id)
    badges_earned = []

    GenreBadge.all.each do |badge|

      unless user.already_has_badge(badge.id)
        if badge.bulk_badge == true && user.has_bulk_genre_badge?(badge.genre_name)
          new_badge = UserGenreBadge.create(user_id: user.id, genre_badge_id: badge.id)
        elsif badge.explorer_badge == true && user.has_genre_explorer_badge?
          new_badge = UserGenreBadge.create(user_id: user.id, genre_badge_id: badge.id)
        elsif user.has_genre_badge?(badge.genre_name)
          new_badge = UserGenreBadge.create(user_id: user.id, genre_badge_id: badge.id)
        end
        new_badge ? badges_earned << new_badge.genre_badge : nil
      end

    end

    return badges_earned
  end

end
