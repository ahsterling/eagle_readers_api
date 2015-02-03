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
    it 'assigns @books to that users books' do
      user = User.create(email: 'email@email.com')
      book = Book.create(title: "Book")
      UserBook.create(user_id: user.id, book_id: book.id)
      get :books, id: user.id
      expect(assigns(:books)).to eq [book]
    end
  end
end
