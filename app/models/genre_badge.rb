class GenreBadge < ActiveRecord::Base
  has_many :user_genre_badges
  has_many :users, through: :user_genre_badges
end
