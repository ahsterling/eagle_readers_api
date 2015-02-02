require 'rails_helper'

describe Subject do
  it 'has many books' do
    book = Book.create(title: "Blah")
    book2 = Book.create(title: "Another One")
    subject = Subject.create(name: "Fiction")

    book_subject = BookSubject.create(book_id: book.id, subject_id: subject.id)
    book_subject2 = BookSubject.create(book_id: book2.id, subject_id: subject.id)
    expect(subject.books.count).to eq 2
  end
end
