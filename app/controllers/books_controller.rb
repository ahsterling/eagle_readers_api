class BooksController < ApplicationController
  def index
    @books = Book.all
    render json: @books.as_json
  end

  def show
    @book = Book.find(params[:id])
    render json: @book.as_json
  end

  def search
    if params['title'] && params['author']
      @book = Book.where("title ILIKE ? AND author ILIKE ?", "%#{params['title']}%", "%#{params['author']}%")
    elsif params['title']
      @book = Book.where("title ILIKE ?", "%#{params['title']}%")
    elsif params['author']
      @book = Book.where("author ILIKE ?", "%#{params['author']}%")
    end
    render json: @book.as_json
  end
end
