require 'rails_helper'

describe UserBooksController do
  describe 'DELETE #destroy' do

    it 'removes a user_book' do
      user = User.create(email: 'uniqueemail@email.com', password: "blahblah", password_confirmation: "blahblah", uid: "email@email.com")
      auth_headers = user.create_new_auth_token
      request.headers.merge!(auth_headers)

      book = Book.create(title: "blah")
      user_book = UserBook.create(user_id: user.id, book_id: book.id)
      delete :destroy, { user_id: user.id, book_id: book.id }
      expect(user.books.count).to eq 0

    end

  end
end
