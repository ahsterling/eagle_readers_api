require 'rails_helper'

describe User do
  describe '.validates' do
    it 'is invalid without an email address' do
      expect(User.new).to be_invalid
    end
  end

  describe 'associations' do
    let(:user) {User.create(email: 'a@b.com', password: "blahblah", password_confirmation: "blahblah", uid: "a@b.com")}
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
    let(:user) {User.create(email: 'a@b.com', password: "blahblah", password_confirmation: "blahblah", uid: "a@b.com")}
    let(:genre) { Genre.create(name: "Fiction") }
    let(:book) { Book.create(title: "Blah", genre_id: genre.id) }
    let(:subject) { Subject.create(name: "Mystery")}
    let(:genre_badge) { GenreBadge.create(genre_name: "Mystery") }
    let(:genre_badge2) { GenreBadge.create(genre_name: "History")}

    it 'returns true if a user has books of the correct genre' do
      book.subjects << subject
      # User adds book
      UserBook.create(user_id: user.id, book_id: book.id)
      expect(user.has_genre_badge?("Fiction")).to eq true
    end

    it 'returns false if a user does not have books of the correct genre' do
      expect(user.has_genre_badge?("History")).to eq false
    end
  end

  describe '#has_bulk_genre_badge?' do
    let(:user) {User.create(email: 'a@b.com', password: "blahblah", password_confirmation: "blahblah", uid: "a@b.com")}
    let(:genre) { Genre.create(name: "Fiction") }
    let(:book1) { Book.create(title: "Blah1", genre_id: genre.id) }
    let(:book2) { Book.create(title: "Blah2", genre_id: genre.id) }
    let(:book3) { Book.create(title: "Blah3", genre_id: genre.id) }
    let(:book4) { Book.create(title: "Blah4", genre_id: genre.id) }
    let(:book5) { Book.create(title: "Blah5", genre_id: genre.id) }

    let(:genre_badge) { GenreBadge.create(genre_name: "Fiction", bulk_badge: true) }

    it 'returns true if a user has 5 books of the same genre' do
      UserBook.create(user_id: user.id, book_id: book1.id)
      UserBook.create(user_id: user.id, book_id: book2.id)
      UserBook.create(user_id: user.id, book_id: book3.id)
      UserBook.create(user_id: user.id, book_id: book4.id)
      UserBook.create(user_id: user.id, book_id: book5.id)

      expect(user.has_bulk_genre_badge?("Fiction")).to eq true

    end

    it 'returns false if a user does not have 5 books of the same genre' do
      expect(user.has_bulk_genre_badge?("History")).to eq false
    end
  end
end
