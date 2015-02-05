# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

genres = ["fantasy", "science fiction", "historical fiction", "mystery", "horror", "adventure", "fiction", "animals", "poetry", "graphic novel", "biography", "history", "mythology", "sports", "non-fiction/other"]

genres.each do |genre|
  Genre.create(name: genre)
  GenreBadge.create(genre_name: genre)
end

User.create(email: 'a@a.com')

reader = MARC::Reader.new("erin_books_2.dat")

for record in reader
  book = Book.new(title: record['245']['a'])
  # adds subtitle if available
  if record['245']
    title = record['245']['a'].to_s + " " + record['245']['b'].to_s
    book.title = title
  end

  #loc number
  if record['010']
    loc_number = record['010']['a']
    book.loc_number = loc_number
  end

  # isbn number
  if record['020']
    isbn = record['020']['a']
    book.isbn = isbn
  end

  # author
  if record['100']
    book.author = record['100']['a']
  end

  # publication date
  if record['260']
    if record['260']['c']
      # puts record['260']['c']
      date_match = /\d+/.match(record['260']['c']).to_s
      date = Date.new(date_match.to_i)
      book.pub_date = date
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
    # topical term
    if record['650']['a']
      book.add_subject(record['650']['a'])
    end

    # form subdivision
    if record['650']['v']
      book.add_subject(record['650']['v'])
    end

    # General Subdivision
    if record['650']['x']
      book.add_subject(record['650']['x'])

    end

    # Chronological Subdivision
    # if record['650']['y']
    #   book.add_subject(record['650']['y'])
    #
    # end

    # Geographic subdivision
    # if record['650']['z']
    #   book.add_subject(record['650']['z'])
    #
    # end
  end

  # geographical headings
  # if record['651']
  #   if record['651']['a']
  #     book.add_subject(record['651']['a'])
  #
  #   end
  # end

  # genre/form headings
  if record['655']
    if record['655']['a']
      book.add_subject(record['655']['a'])

    end
  end

  book.save

  # ["fantasy", "science fiction", "historical fiction", "mystery", "horror", "adventure", "paranormal", "fiction", "political fiction", "animals", "poetry", "graphic novel", "biography", "non-fiction"]
  # if book.subject_array.count == 0
  #   book.genre_id = Genre.find_by(name: 'non-fiction/other')
  # else
  book.subject_array.each do |sub_name|
    if /fantasy/i.match(sub_name) || /fantastical/i.match(sub_name)
      book.genre_id = Genre.find_by(name: "fantasy").id
    elsif /science fic/i.match(sub_name)
      book.genre_id = Genre.find_by(name: "science fiction").id
    elsif /historical f/i.match(sub_name)
      book.genre_id = Genre.find_by(name: "historical fiction").id
    elsif /mystery/i.match(sub_name) || /suspense/i.match(sub_name)
      book.genre_id = Genre.find_by(name: "mystery").id
    elsif /horror/i.match(sub_name) || /occult/i.match(sub_name) || /paranormal/i.match(sub_name)
      book.genre_id = Genre.find_by(name: "horror").id
    elsif /adventure/i.match(sub_name)
      book.genre_id = Genre.find_by(name: "adventure").id
    elsif /animal/i.match(sub_name)
      book.genre_id = Genre.find_by(name: "animals").id
    elsif /poetry/i.match(sub_name)
      book.genre_id = Genre.find_by(name: "poetry").id
    elsif /comic/i.match(sub_name) || /graphic n/i.match(sub_name)
      book.genre_id = Genre.find_by(name: "graphic novel").id
    elsif /biography/i.match(sub_name)
      book.genre_id = Genre.find_by(name: "biography").id
    elsif /history/i.match(sub_name)
      book.genre_id = Genre.find_by(name: "history").id
    elsif /mythology/i.match(sub_name)
      book.genre_id = Genre.find_by(name: "mythology").id
    elsif /sports/i.match(sub_name)
      book.genre_id = Genre.find_by(name: "sports").id
    elsif /fiction/i.match(sub_name) || /literature/i.match(sub_name)
      book.genre_id = Genre.find_by(name: "fiction").id
    else
      book.genre_id = Genre.find_by(name: "non-fiction/other").id
    end
    # end
  end











  # Number of pages

  book.save




end
