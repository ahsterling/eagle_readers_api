class UserGenreBadge < ActiveRecord::Base
  belongs_to :user
  belongs_to :genre_badge
end
