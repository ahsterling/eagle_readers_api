require 'rails_helper'

describe User do
  describe '.validates' do
    it 'is invalid without an email address' do
      expect(User.new).to be_invalid
    end
  end

  describe 'associations' do
    let(:user) {User.create(email: 'a@b.com')}
    let(:book) {Book.create(title: "Blah")}
    let(:genre_badge) {GenreBadge.create(genre_name: "Fiction")}
    it 'a user can have many books' do
      UserBook.create(user_id: user.id, book_id: book.id)
      expect(user.books.count).to eq 1
    end

    it 'a user can have many genre_badges' do
      UserGenreBadge.create(user_id: user.id, genre_badge_id: genre_badge.id)
      expect(user.genre_badges.count).to eq 1
    end
  end
end
