class User < ActiveRecord::Base
  # Include default devise modules.
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable

  include DeviseTokenAuth::Concerns::User
  validates :uid, uniqueness: true
  has_many :user_books
  has_many :books, through: :user_books
  has_many :user_genre_badges
  has_many :genre_badges, through: :user_genre_badges

  def has_genre_badge?(genre_name)
    has_badge = false

    self.books.includes(:subjects).each do |book|
      book.subjects.each do |subject|
        if subject.name == genre_name
          has_badge = true
        end
      end
    end

    return has_badge
  end

  def already_has_badge(genre_name)
    if self.genre_badges.where(genre_name: genre_name).length != 0
      return true
    else
      return false
    end
  end

end
