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
      @books = Book.where("title ILIKE ? AND author ILIKE ?", "%#{params['title']}%", "%#{params['author']}%")
    elsif params['title']
      @books = Book.where("title ILIKE ?", "%#{params['title']}%")
    elsif params['author']
      @books = Book.where("author ILIKE ?", "%#{params['author']}%")
    elsif params['subject']
      @books = Book.where("'#{params['subject']}' = ANY (subject_array)")

    end
    render json: @books.as_json
  end

end
