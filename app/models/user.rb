class User < ActiveRecord::Base
  validates :email, presence: true
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

end
