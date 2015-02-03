class User < ActiveRecord::Base
  validates :email, presence: true
  has_many :user_books
  has_many :books, through: :user_books

end
