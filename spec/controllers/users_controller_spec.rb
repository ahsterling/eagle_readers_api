require 'rails_helper'

describe UsersController do
  describe 'GET #show' do
    it 'assigns @user to a particular user' do
      user = User.create(email: 'email@email.com')
      get :show, id: user.id
      expect(assigns(:user)).to eq user
    end
  end

  describe 'GET #books' do
    it 'assigns @books to a particular users books' do
      user = User.create(email: 'email@email.com')
      book = Book.create(title: "Book")
      UserBook.create(user_id: user.id, book_id: book.id)
      get :books, user_id: user.id
      expect(assigns(:books)).to eq [book]
    end
  end

  describe 'POST #add_book' do

    let (:user) {User.create(email: "email@email.com")}
    let (:book) {Book.create(title: "Blah")}

    it 'adds a book to a users shelf' do
      post :add_book, book_id: book.id, user_id: user.id
      expect(user.books.count).to eq 1
    end
  end
end
