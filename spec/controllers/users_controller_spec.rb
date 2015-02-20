require 'rails_helper'


describe UsersController do
  include Devise::TestHelpers
  describe 'GET #show' do
    it 'assigns @user to a particular user' do
      user = User.create(email: 'email1@email.com', password: "blahblah", password_confirmation: "blahblah", uid: "email1@email.com")
      auth_headers = user.create_new_auth_token
      request.headers.merge!(auth_headers)
      get :show, {id: user.id}, auth_headers
      expect(assigns(:user)).to eq user
    end
  end

  describe 'GET #books' do
    it 'assigns @books to a particular users books' do
      user = User.create(email: 'email2@email.com', password: "blahblah", password_confirmation: "blahblah", uid: "email2@email.com")
      auth_headers = user.create_new_auth_token
      request.headers.merge!(auth_headers)

      book = Book.create(title: "Book")
      UserBook.create(user_id: user.id, book_id: book.id)
      get :books, {user_id: user.id}, auth_headers
      expect(assigns(:books)).to eq [book]
    end
  end

  describe 'GET #badges' do
    it 'assigns @badges to a particular users badges' do
      user = User.create(email: 'email3@email.com', password: "blahblah", password_confirmation: "blahblah", uid: "email3@email.com")
      genre_badge = GenreBadge.create(genre_name: "Mystery")
      UserGenreBadge.create(user_id: user.id, genre_badge_id: genre_badge.id)
      auth_headers = user.create_new_auth_token
      request.headers.merge!(auth_headers)
      get :badges, {user_id: user.id}, auth_headers
      expect(assigns(:badges)).to eq [genre_badge]
    end
  end

  describe 'GET #genres' do
    it 'assigns genres to a particular users books genres' do
      user = User.create(email: 'email4@email.com', password: "blahblah", password_confirmation: "blahblah", uid: "email4@email.com")
      genre = Genre.create(name: "Fiction")
      book = Book.create(title: "Blah", genre_id: genre.id)
      UserBook.create(user_id: user.id, book_id: book.id)


      auth_headers = user.create_new_auth_token
      request.headers.merge!(auth_headers)

      get :genres, {user_id: user.id}, auth_headers
      expect(assigns(:genres)).to eq [genre]
    end
  end

  describe 'POST #add_book' do


    it 'adds a book to a users shelf' do
      user = User.create(email: 'email5@email.com', password: "blahblah", password_confirmation: "blahblah", uid: "email5@email.com")
      genre = Genre.create(name: "Fiction")
      book = Book.create(title: "Blah", genre_id: genre.id)
      subject = Subject.create(name: "Fantasy")
      genre_badge = GenreBadge.create(genre_name: "Fantasy")
      auth_headers = user.create_new_auth_token
      request.headers.merge!(auth_headers)

      post :add_book, {book_id: book.id, user_id: user.id}, auth_headers
      expect(user.books.count).to eq 1
    end

    context 'user earning badge' do
      it 'creates appropriate user_genre_badge when user adds book' do
        user = User.create(email: 'email6@email.com', password: "blahblah", password_confirmation: "blahblah", uid: "email6@email.com")
        genre = Genre.create(name: "Fiction")
        book = Book.create(title: "Blah", genre_id: genre.id)
        # subject = Subject.create(name: "Fantasy")
        genre_badge = GenreBadge.create(genre_name: "Fiction")
        genre_badge = GenreBadge.create(genre_name: "Fiction", bulk_badge: true)
        genre_badge2 = GenreBadge.create(genre_name: "Graphic Novel")
        auth_headers = user.create_new_auth_token
        request.headers.merge!(auth_headers)

        # book.subjects << subject

        post :add_book, {book_id: book.id, user_id: user.id}, auth_headers
        expect(User.find(user.id).genre_badges.count).to eq 1
      end

      it 'does not create another badge when user has already earned it' do
        user = User.create(email: 'email7@email.com', password: "blahblah", password_confirmation: "blahblah", uid: "email7@email.com")
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

      it 'creates genre champion bacge when user adds book and has 5 of same genre' do
        user = User.create(email: 'email8@email.com', password: "blahblah", password_confirmation: "blahblah", uid: "email8@email.com")
        genre = Genre.create(name: "Fiction")

        book = Book.create(title: "Blah", genre_id: genre.id)
        book2 = Book.create(title: "Blah2", genre_id: genre.id)
        book3 = Book.create(title: "Blah3", genre_id: genre.id)
        book4 = Book.create(title: "Blah4", genre_id: genre.id)
        book5 = Book.create(title: "Blah5", genre_id: genre.id)

        UserBook.create(user_id: user.id, book_id: book.id)
        UserBook.create(user_id: user.id, book_id: book2.id)
        UserBook.create(user_id: user.id, book_id: book3.id)
        UserBook.create(user_id: user.id, book_id: book4.id)


        # subject = Subject.create(name: "Fantasy")
        genre_badge = GenreBadge.create(genre_name: "Fiction", bulk_badge: true, title: 'genre champion')
        auth_headers = user.create_new_auth_token
        request.headers.merge!(auth_headers)

        # book.subjects << subject

        post :add_book, {book_id: book5.id, user_id: user.id}, auth_headers
        expect(User.find(user.id).genre_badges[0].title).to eq 'genre champion'

      end

      it 'creates genre explorer badge when user adds book and has 5 books of dif genres' do
        user = User.create(email: 'email9@email.com', password: "blahblah", password_confirmation: "blahblah", uid: "email9@email.com")

        genre = Genre.create(name: "Fiction")
        genre2 = Genre.create(name: "History")
        genre3 = Genre.create(name: "Sci fi")
        genre4 = Genre.create(name: "Biography")
        genre5 = Genre.create(name: "nonfiction")

        book = Book.create(title: "Blah", genre_id: genre.id)
        book2 = Book.create(title: "Blah2", genre_id: genre2.id)
        book3 = Book.create(title: "Blah3", genre_id: genre3.id)
        book4 = Book.create(title: "Blah4", genre_id: genre4.id)
        book5 = Book.create(title: "Blah5", genre_id: genre5.id)

        UserBook.create(user_id: user.id, book_id: book.id)
        UserBook.create(user_id: user.id, book_id: book2.id)
        UserBook.create(user_id: user.id, book_id: book3.id)
        UserBook.create(user_id: user.id, book_id: book4.id)

        genre_badge = GenreBadge.create(explorer_badge: true, title: 'genre explorer')

        auth_headers = user.create_new_auth_token
        request.headers.merge!(auth_headers)

        post :add_book, {book_id: book5.id, user_id: user.id}, auth_headers

        expect(User.find(user.id).genre_badges[0].title).to eq 'genre explorer'

      end
    end
  end
end
