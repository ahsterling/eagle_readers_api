require 'rails_helper'

RSpec.describe Book, :type => :model do

  describe '.validations' do
    it 'is invalid without a title' do
      expect(Book.new(title: nil)).to be_invalid
    end
  end

  describe 'has_many subjects' do

    it 'allows you to call book.subjects' do
      book = Book.create(title: "blah")
      subject = Subject.create(name: "Fiction")
      subject2 = Subject.create(name: "Horror")
      BookSubject.create(book_id: book.id, subject_id: subject.id)
      BookSubject.create(book_id: book.id, subject_id: subject2.id)
      expect(book.subjects.count).to eq 2

    end
  end

  describe 'has many users' do
    it 'allows you to call book.users' do
      book = Book.create(title: "Blah")
      user = User.create(email: 'email10@email.com', password: "blahblah", password_confirmation: "blahblah", uid: "email10@email.com")
      user2 = User.create(email: 'b@c.com', password: "blahblah", password_confirmation: "blahblah", uid: "b@c.com")
      UserBook.create(book_id: book.id, user_id: user.id)
      UserBook.create(book_id: book.id, user_id: user2.id)
      expect(book.users.count).to eq 2
    end
  end

end
