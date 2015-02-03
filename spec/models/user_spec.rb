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

  describe '#has_genre_badge?(genre_name)' do
    let(:user) { User.create(email: "a@b.com") }
    let(:book) { Book.create(title: "Blah") }
    let(:subject) { Subject.create(name: "Mystery")}
    let(:genre_badge) { GenreBadge.create(genre_name: "Mystery") }
    let(:genre_badge2) { GenreBadge.create(genre_name: "History")}

    it 'returns true if a user has books of the correct genre' do
      book.subjects << subject
      # User adds book
      UserBook.create(user_id: user.id, book_id: book.id)
      expect(user.has_genre_badge?("Mystery")).to eq true
    end

    it 'returns false if a user does not have books of the correct genre' do
      expect(user.has_genre_badge?("History")).to eq false
    end
  end
end
