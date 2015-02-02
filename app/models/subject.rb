class Subject < ActiveRecord::Base
  has_many :book_subjects
  has_many :books, through: :book_subjects
end
