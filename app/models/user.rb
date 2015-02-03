class User < ActiveRecord::Base
  # Include default devise modules.
  validates :email, presence: true
  has_many :user_books
  has_many :books, through: :user_books
  has_many :user_genre_badges
  has_many :genre_badges, through: :user_genre_badges

end
