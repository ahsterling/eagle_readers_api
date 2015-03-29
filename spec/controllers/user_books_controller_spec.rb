require 'rails_helper'

describe UserBooksController do
  describe 'DELETE #destroy' do

    it 'removes a user_book' do
      user = User.create(email: 'uniqueemail@email.com', password: "blahblah", password_confirmation: "blahblah", uid: "email@email.com")
      auth_headers = user.create_new_auth_token
      request.headers.merge!(auth_headers)
      genre = Genre.create(name: "Fiction")
      book = Book.create(title: "blah", genre_id: genre.id)
      user_book = UserBook.create(user_id: user.id, book_id: book.id)
      genre_badge = GenreBadge.create(genre_name: "Fiction")
      genre_badge_bulk = GenreBadge.create(genre_name: "Fiction", bulk_badge: true)
      explorer_badge = GenreBadge.create(explorer_badge: true)

      UserGenreBadge.create(genre_badge_id: genre_badge.id, user_id: user.id)

      delete :destroy, { user_id: user.id, book_id: book.id }
      expect(user.books.count).to eq 0

    end

    it 'removes the appropriate genre badges when user only has one book of that genre' do
      user = User.create(email: 'uniqueemail2@email.com', password: "blahblah", password_confirmation: "blahblah", uid: "uniqueemail2@email.com")
      auth_headers = user.create_new_auth_token
      request.headers.merge!(auth_headers)
      genre = Genre.create(name: "Fiction")
      book = Book.create(title: "blah", genre_id: genre.id)
      user_book = UserBook.create(user_id: user.id, book_id: book.id)
      genre_badge = GenreBadge.create(genre_name: "Fiction")
      genre_badge_bulk = GenreBadge.create(genre_name: "Fiction", bulk_badge: true)
      explorer_badge = GenreBadge.create(explorer_badge: true)



      UserGenreBadge.create(genre_badge_id: genre_badge.id, user_id: user.id)
      expect(user.genre_badges.count).to eq 1
      delete :destroy, {user_id: user.id, book_id: book.id}
      expect(user.genre_badges.count).to eq 0

    end

    it 'removes the right genre champion badge when user removes one and has fewer than 5' do
      user = User.create(email: 'uniqueemail3@email.com', password: "blahblah", password_confirmation: "blahblah", uid: "uniqueemail3@email.com")
      auth_headers = user.create_new_auth_token
      request.headers.merge!(auth_headers)

      genre = Genre.create(name: "Fiction")

      book = Book.create(title: "blah", genre_id: genre.id)
      book2 = Book.create(title: "blah2", genre_id: genre.id)
      book3 = Book.create(title: "blah3", genre_id: genre.id)
      book4 = Book.create(title: "blah4", genre_id: genre.id)
      book5 = Book.create(title: "blah5", genre_id: genre.id)

      user_book = UserBook.create(user_id: user.id, book_id: book.id)
      user_book2 = UserBook.create(user_id: user.id, book_id: book2.id)
      user_book3 = UserBook.create(user_id: user.id, book_id: book3.id)
      user_book4 = UserBook.create(user_id: user.id, book_id: book4.id)
      user_book5 = UserBook.create(user_id: user.id, book_id: book5.id)

      genre_badge = GenreBadge.create(genre_name: "Fiction", bulk_badge: true)
      UserGenreBadge.create(genre_badge_id: genre_badge.id, user_id: user.id)
      explorer_badge = GenreBadge.create(explorer_badge: true)


      expect(user.genre_badges.count).to eq 1
      delete :destroy, {user_id: user.id, book_id: book5.id}
      expect(user.genre_badges.count).to eq 0
    end

    it 'removes the genre explorer badge when book is removed and criteria are not met' do
      user = User.create(email: 'uniqueemail3@email.com', password: "blahblah", password_confirmation: "blahblah", uid: "uniqueemail3@email.com")
      auth_headers = user.create_new_auth_token
      request.headers.merge!(auth_headers)

      genre = Genre.create(name: "Fiction")
      genre2 = Genre.create(name: "Science Fiction")
      genre3 = Genre.create(name: "History")
      genre4 = Genre.create(name: "Biography")
      genre5 = Genre.create(name: "Mystery")

      book = Book.create(title: "blah", genre_id: genre.id)
      book2 = Book.create(title: "blah2", genre_id: genre2.id)
      book3 = Book.create(title: "blah3", genre_id: genre3.id)
      book4 = Book.create(title: "blah4", genre_id: genre4.id)
      book5 = Book.create(title: "blah5", genre_id: genre5.id)

      user_book = UserBook.create(user_id: user.id, book_id: book.id)
      user_book2 = UserBook.create(user_id: user.id, book_id: book2.id)
      user_book3 = UserBook.create(user_id: user.id, book_id: book3.id)
      user_book4 = UserBook.create(user_id: user.id, book_id: book4.id)
      user_book5 = UserBook.create(user_id: user.id, book_id: book5.id)

      genre_badge = GenreBadge.create(genre_name: "Mystery")
      genre_badge_bulk = GenreBadge.create(genre_name: "Fiction", bulk_badge: true)
      explorer_badge = GenreBadge.create(explorer_badge: true)

      UserGenreBadge.create(genre_badge_id: explorer_badge.id, user_id: user.id)
      expect(user.genre_badges.count).to eq 1
      puts "broken test"
      delete :destroy, {user_id: user.id, book_id: book.id}
      expect(user.genre_badges.count).to eq 0

    end

  end
end
