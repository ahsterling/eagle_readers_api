require 'rails_helper'

describe BooksController do

  describe 'GET #index' do
    let(:book) {Book.create(title: "The Great Gatsby")}
    it 'is successful' do
      get :index
      expect(response.status).to eq 200
    end

    it 'populates an array of books' do
      get :index
      expect(assigns(:books)).to match_array [book]
    end
  end

end
