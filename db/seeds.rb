# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

reader = MARC::Reader.new("erin_books_2.dat")
for record in reader
  book = Book.new(title: record['245']['a'])
  # adds subtitle if available
  if record['245']
    title = record['245']['a'].to_s + " " + record['245']['b'].to_s
    book.title = title
  end

  # isbn number
  if record['020']
    isbn = record['020']['a']
    book.isbn = isbn
    # book_info = HTTParty.get("https://www.googleapis.com/books/v1/volumes?q=isbn:#{book.isbn}").parsed_response
    # if book_info['items']
      # book_category = book_info['items'][0]['volumeInfo']['categories'][0]
    # else
      # book_category = "other"
    # end
    # subject = Subject.find_by(name: book_category)
    # if subject
    #   book.subject_id = subject.id
    # else
    #   subject = Subject.create(name: book_category)
    #   book.subject_id = subject.id
    # end
  end

  # author
  if record['100']
    book.author = record['100']['a']
  end

  # publication date
  if record['260']
    if record['260']['c']
      book.pub_date = record['260']['c']
    end
  end

  #pages
  if record['300']
    book.pages = record['300']['a'].to_i
  end

  # description
  if record['520']
    if record['520']['a']
      book.description = record['520']['a']
    end
  end

  # subject headings
  if record['650']
    if record['650']['a']
      book.add_subject(record['650']['a'])
    end

    if record['650']['v']
      book.add_subject(record['650']['v'])
    end

    if record['650']['x']
      # book.subjects_array.push(record['650']['x'])
      book.add_subject(record['650']['x'])
    end

    if record['650']['y']
      # book.subjects_array.push(record['650']['y'])
      book.add_subject(record['650']['y'])
    end

    if record['650']['z']
      book.add_subject(record['650']['z'])
    end
  end

  # geographical headings
  if record['651']
    if record['651']['a']
      book.add_subject(record['651']['a'])
    end
  end

  # genre/form headings
  if record['655']
    if record['655']['a']
      book.add_subject(record['655']['a'])
    end
  end

  # if it has a genre form header, prioritize that as subject
  # if record['655']
  #   subject = Subject.find_by(name: record['655']['a'])
  #   if subject
  #     book.subject_id = subject.id
  #   else
  #     subject = Subject.create(name: record['655']['a'])
  #     book.subject_id = subject.id
  #   end
  # # if it doesn't have a genre form header, use the subfield instead
  # else
  #   if record['650']
  #     subject = Subject.find_by(name: record['650']['v'])
  #     if subject
  #       book.subject_id = subject.id
  #     else
  #       subject = Subject.create(name: record['650']['v'])
  #       book.subject_id = subject.id
  #     end
  #   # if it doesn't have one of those, set the subject to unknown
  #   else
  #     subject = Subject.find_by(name: "unknown")
  #     book.subject_id = subject.id
  #   end
  # end


  # Number of pages

  book.save

end
