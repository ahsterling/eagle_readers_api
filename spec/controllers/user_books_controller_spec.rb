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
      UserGenreBadge.create(genre_badge_id: genre_badge.id, user_id: user.id)
      expect(user.genre_badges.count).to eq 1
      delete :destroy, {user_id: user.id, book_id: book.id}
      expect(user.genre_badges.count).to eq 0

    end

  end
end
