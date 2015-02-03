class User < ActiveRecord::Base
  # Include default devise modules.
  validates :email, presence: true
  has_many :user_books
  has_many :books, through: :user_books
  has_many :user_genre_badges
  has_many :genre_badges, through: :user_genre_badges

  def has_genre_badge?(genre_name)
    has_book = false
    self.books.each do |book|
      book.subjects.each do |subject|
        if subject.name == genre_name
          has_book = true
        end
      end
    end
    return has_book
  end

end
