require 'rails_helper'

describe User do
  describe '.validates' do
    it 'is invalid without an email address' do
      expect(User.new).to be_invalid
    end
  end

  describe 'associations' do
    it 'a user can have many books' do
      user = User.create(email: 'a@b.com')
      book = Book.create(title: "Blah")
      UserBook.create(user_id: user.id, book_id: book.id)
      expect(user.books.count).to eq 1
    end
  end
end
