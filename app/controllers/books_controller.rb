class BooksController < ApplicationController
  def index
    @books = Book.all

    render json: @books.as_json
  end

  def show
    book = Book.find(params[:id])
    render json: {
      id: book.id,
      title: book.title,
      author: book.author,
      description: book.description,
      pub_date: book.pub_date,
      pages: book.pages,
      isbn: book.isbn,
      subject_array: book.subjects.map {|sub| sub.name},
      loc_number: book.loc_number,
      genre: book.genre.name
    }.as_json
  end

  def subjects
    book = Book.find(params[:id])
    @book_subjects = book.subjects
    render json: @book_subjects.as_json
  end

  def search
    if params['title'] && params['author']
      @books = Book.where("title ILIKE ? AND author ILIKE ?", "%#{params['title']}%", "%#{params['author']}%")
    elsif params['title']
      @books = Book.where("title ILIKE ?", "%#{params['title']}%")
    elsif params['author']
      @books = Book.where("author ILIKE ?", "%#{params['author']}%")
    elsif params['genre']
      # @books = Book.where("'#{params['subject']}' = ANY (subject_array)")
      @books = Genre.find_by("name ILIKE ?", "#{params['genre']}").books
    end
    render json: @books.as_json
  end

end
