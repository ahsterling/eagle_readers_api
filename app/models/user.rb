class User < ActiveRecord::Base
  # Include default devise modules.
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable

  include DeviseTokenAuth::Concerns::User
  validates :email, uniqueness: true
  has_many :user_books
  has_many :books, through: :user_books
  has_many :user_genre_badges
  has_many :genre_badges, through: :user_genre_badges

  def has_genre_badge?(genre_name)
    has_badge = false

    self.books.each do |book|
      if book.genre.name == genre_name
        has_badge = true
      end
    end

    return has_badge

  end

  def has_bulk_genre_badge?(genre_name)
    has_badge = false
    count = 0

    self.books.each do |book|
      if book.genre.name == genre_name
        count += 1
      end
    end

    if count >= 5
      has_badge = true
    end

    return has_badge
  end

  def has_genre_explorer_badge?
    has_badge = false
    genres = []
    self.books.each do |book|
      unless genres.include?(book.genre.name)
        genres << book.genre.name
      end
    end

    if genres.count >= 5
      has_badge = true
    end
  end

  def already_has_badge(badge_id)
    if self.genre_badges.where(id: badge_id).length != 0
      return true
    else
      return false
    end
  end

end
