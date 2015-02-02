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

    it 'can search on title' do
      new_book = Book.create(title: "Feed", author: "Anderson, M. T.")
      get :search, title: "Feed"
      expect(assigns(:books)).to eq [new_book]
    end

  end

end
