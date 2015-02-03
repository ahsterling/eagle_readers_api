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


    it 'adds a book to a users shelf' do
      user = User.create(email: "email@email.com")
      book = Book.create(title: "Blah")
      subject = Subject.create(name: "Fantasy")
      genre_badge = GenreBadge.create(genre_name: "Fantasy")

      post :add_book, book_id: book.id, user_id: user.id
      expect(user.books.count).to eq 1
    end

    context 'user earning badge' do
      it 'creates appropriate user_genre_badge when user adds book' do
        user = User.create(email: "email@email.com")
        book = Book.create(title: "Blah")
        subject = Subject.create(name: "Fantasy")
        genre_badge = GenreBadge.create(genre_name: "Fantasy")
        genre_badge2 = GenreBadge.create(genre_name: "Graphic Novel")

        book.subjects << subject

        post :add_book, book_id: book.id, user_id: user.id
        expect(User.find(user.id).genre_badges.count).to eq 1
      end
    end
  end
end
