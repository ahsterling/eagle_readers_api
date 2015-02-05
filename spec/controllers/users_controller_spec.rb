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

  describe 'GET #badges' do
    it 'assigns @badges to a particular users badges' do
      user = User.create(email: 'email@email.com')
      genre_badge = GenreBadge.create(genre_name: "Mystery")
      UserGenreBadge.create(user_id: user.id, genre_badge_id: genre_badge.id)
      get :badges, user_id: user.id
      expect(assigns(:badges)).to eq [genre_badge]
    end
  end

  describe 'POST #add_book' do


    it 'adds a book to a users shelf' do
      user = User.create(email: "email@email.com")
      genre = Genre.create(name: "Fiction")
      book = Book.create(title: "Blah", genre_id: genre.id)
      subject = Subject.create(name: "Fantasy")
      genre_badge = GenreBadge.create(genre_name: "Fantasy")

      post :add_book, book_id: book.id, user_id: user.id
      expect(user.books.count).to eq 1
    end

    context 'user earning badge' do
      it 'creates appropriate user_genre_badge when user adds book' do
        user = User.create(email: "email@email.com")
        genre = Genre.create(name: "Fiction")
        book = Book.create(title: "Blah", genre_id: genre.id)
        # subject = Subject.create(name: "Fantasy")
        genre_badge = GenreBadge.create(genre_name: "Fiction")
        genre_badge2 = GenreBadge.create(genre_name: "Graphic Novel")

        # book.subjects << subject

        post :add_book, book_id: book.id, user_id: user.id
        expect(User.find(user.id).genre_badges.count).to eq 1
      end

      it 'doesnt create another badge when user has already earned it' do
        user = User.create(email: "email@email.com")
        genre = Genre.create(name: "Fiction")
        book = Book.create(title: "Blah", genre_id: genre.id)
        book2 = Book.create(title: "Another book", genre_id: genre.id)
        subject = Subject.create(name: "Fantasy")
        genre_badge = GenreBadge.create(genre_name: "Fantasy")
        book.subjects << subject
        book2.subjects << subject
        UserGenreBadge.create(user_id: user.id, genre_badge_id: genre_badge.id)

        post :add_book, book_id: book2.id, user_id: user.id
        expect(User.find(user.id).genre_badges.count).to eq 1
      end
    end
  end
end
