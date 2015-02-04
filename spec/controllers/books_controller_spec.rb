require 'rails_helper'

describe BooksController do
  let(:book) {Book.create(title: "The Great Gatsby", author: "Fitzgerald, F. Scott")}

  describe 'GET #index' do
    it 'is successful' do
      get :index
      expect(response.status).to eq 200
    end

    # it 'populates an array of books' do
    #   get :index
    #   expect(assigns(:books)).to match_array [book]
    # end
  end

  describe 'GET #show' do
    it 'is successful' do
      get :show, id: book.id
      expect(response.status).to eq 200
    end
  end

  describe 'GET #search' do
    it 'is successful' do
      get :search, title: 'The Great Gatsby'
      expect(response.status).to eq 200
    end

    it 'can search on exact title' do
      new_book = Book.create(title: "Feed", author: "Anderson, M. T.")
      get :search, title: "Feed"
      expect(assigns(:books)).to eq [new_book]
    end

    it 'can search on exact author' do
      book2 = Book.create(title: "Feed", author: "Anderson, M. T.")
      get :search, author: "Anderson, M. T."
      expect(assigns(:books)).to eq [book2]
    end

    it 'can search on title and author' do
      book3 = Book.create(title: "The title", author: "Author, the")
      get :search, title: "The title", author: "Author, the"
      expect(assigns(:books)).to eq [book3]
    end

    it 'can perform fuzzy search on title' do
      book4 = Book.create(title: "The Fault in Our Stars", author: "Green, John")
      get :search, title: "faul"
      expect(assigns(:books)).to eq [book4]
    end

    it 'can perform fuzzy search on author' do
      book5 = Book.create(title: "Everyday", author: "Levithan, David")
      get :search, author: "levit"
      expect(assigns(:books)).to eq [book5]
    end

    context 'subjects' do
      it 'can search on particular subjects' do
        book6 = Book.create(title: "Volcanoes", author: "Smith, Mary")
        subject = Subject.create(name: "volcanoes")
        BookSubject.create(book_id: book6.id, subject_id: subject.id)
        get :search, subject: "Volcanoes"
        expect(assigns(:books)).to eq [book6]
      end
    end

  end

  describe 'GET #subjects' do
    it 'can retrieve a list of a books subjects' do
      book = Book.create(title: "Blah")
      subject1 = Subject.create(name: "Dogs")
      subject2 = Subject.create(name: "Cats")
      BookSubject.create(book_id: book.id, subject_id: subject1.id)
      BookSubject.create(book_id: book.id, subject_id: subject2.id)
      get :subjects, id: book.id
      expect(assigns(:book_subjects)).to eq [subject1, subject2]
    end
  end

end
