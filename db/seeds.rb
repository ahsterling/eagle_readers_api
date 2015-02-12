# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

genres = ["music", 'eagles read', "fantasy", "science fiction", "historical fiction", "mystery", "horror", "adventure", "fiction", "animals", "poetry", "graphic novel", "biography", "history", "mythology/folktales", "sports", "science", "non-fiction/other"]

genres.each do |genre|
  Genre.create(name: genre)
  GenreBadge.create(genre_name: genre)
end

reader = MARC::Reader.new("erin_books_2.dat")

for record in reader
  book = Book.new(title: record['245']['a'].titleize)
  # adds subtitle if available
  if record['245']
    title = record['245']['a'].to_s + " " + record['245']['b'].to_s
    book.title = title.titleize
  end

  if /\s\//.match(book.title)
    book.title = /\s\//.match(book.title).pre_match
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

  if record['130']
    if record['130']['f']
      date_match = /\d+/.match(record['130']['f']).to_s
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
  if book.subject_array.count == 0
    book.genre_id = Genre.find_by(name: "non-fiction/other").id
  else
    if book.subject_array.grep(/fantasy/i).count > 0 || book.subject_array.grep(/fantastical/i).count > 0
      book.genre_id = Genre.find_by(name: "fantasy").id
    elsif book.subject_array.grep(/science fic/).count > 0
      book.genre_id = Genre.find_by(name: "science fiction")
    elsif book.subject_array.grep(/historical f/i).count > 0
      book.genre_id = Genre.find_by(name: "historical fiction").id
    elsif book.subject_array.grep(/mystery/i).count > 0 || book.subject_array.grep(/suspense/i).count > 0
      book.genre_id = Genre.find_by(name: "mystery").id
    elsif book.subject_array.grep(/horror/i).count > 0 || book.subject_array.grep(/occult/i).count > 0 || book.subject_array.grep(/paranormal/i).count > 0
      book.genre_id = Genre.find_by(name: "horror").id
    elsif book.subject_array.grep(/adventure/i).count > 0
      book.genre_id = Genre.find_by(name: "adventure").id
    elsif book.subject_array.grep(/animal/i).count > 0
      book.genre_id = Genre.find_by(name: "animals").id
    elsif book.subject_array.grep(/poetry/i).count > 0
      book.genre_id = Genre.find_by(name: "poetry").id
    elsif book.subject_array.grep(/comic/i).count > 0 || book.subject_array.grep(/graphic n/i).count > 0
      book.genre_id = Genre.find_by(name: "graphic novel").id
    elsif book.subject_array.grep(/music/i).count > 0
      book.genre_id = Genre.find_by(name: "music").id
    elsif book.subject_array.grep(/biography/i).count > 0
      book.genre_id = Genre.find_by(name: "biography").id
    elsif book.subject_array.grep(/history/i).count > 0
      book.genre_id = Genre.find_by(name: "history").id
    elsif book.subject_array.grep(/mythology/i).count > 0 || book.subject_array.grep(/folktale/i).count > 0
      book.genre_id = Genre.find_by(name: "mythology/folktales").id
    elsif book.subject_array.grep(/sports/i).count > 0
      book.genre_id = Genre.find_by(name: "sports").id
    elsif book.subject_array.grep(/biology/i).count > 0 || book.subject_array.grep(/chemistry/i).count > 0 || book.subject_array.grep(/physics/i).count > 0 || book.subject_array.grep(/engineering/).count > 0 || book.subject_array.grep(/geology/).count > 0
      book.genre_id = Genre.find_by(name: "science").id
    elsif book.subject_array.grep(/fiction/i).count > 0 || book.subject_array.grep(/literature/i).count > 0
      book.genre_id = Genre.find_by(name: "fiction").id
    else
      book.genre_id = Genre.find_by(name: "non-fiction/other").id
    end
  end

  book.save

end

eagles_reads = [{title: 'Adventures of superhero girl', author: 'hicks'},
                {title: 'Africa is my home', author: 'Ediger'},
                {title: 'Amulet: The stonekeeper', author: 'kibuishi'},
                {title: 'Beautiful music for ugly children', author: "Cronn-Mills"},
                {title: 'boxers and saints', author: 'Yang'},
                {title: 'counting by 7', author: 'sloan'},
                {title: 'courage has no color', author: 'stone'},
                {title: 'divergent', author: "roth"},
                {title: "ender's game", author: 'card'},
                {title: 'fairy tale comics', author: 'duffy'},
                {title: 'far far away', author: 'mcneal'},
                {title: 'fourth down and inches', author: 'killough'},
                {title: 'freakboy', author: 'clark'},
                {title: 'a girl called problem', author:'quirk'},
                {title: 'the girl who fell to earth', author: 'al-maria'},
                {title: "go: a kid's guide to graphic design", author: 'kidd'},
                {title: 'how i became a ghost', author: 'tingle'},
                {title: 'i am malala', author: 'malala'},
                {title: 'i am number four', author: 'lore'},
                {title: 'if i ever get out of here', author: 'gansworth'},
                {title: 'imprisoned: the betrayal of', author: 'sandler'},
                {title: 'kampung boy', author: 'lat'},
                {title: 'listening for luca', author: 'lafleur'},
                {title: 'the living', author: 'pena'},
                {title: 'luna', author: 'peters'},
                {title: 'mister max: finder of lost things', author: 'voigt'},
                {title: 'the menagerie', author: 'sutherland'},
                {title: 'the nazi hunters', author: 'bascomb'},
                {title: 'nelson mandela', author: 'nelson, kadir'},
                {title: 'one came home', author: 'timberlake'},
                {title: 'open mic', author: 'perkins'},
                {title: 'paper towns', author: 'green'},
                {title: 'port chicago 50', author: "sheinken"},
                {title: 'the president has been shot', author: 'swanson'},
                {title: "the ranger's apprentice", author: 'flanagan'},
                {title: 'the reason i jump', author: 'higashida'},
                {title: 'the rithmatist', author: 'sanderson'},
                {title: 'rose under fire', author: 'wein'},
                {title: 'the selection', author: 'cass'},
                {title: 'this is the rope', author: 'woodson'},
                {title: 'this is what happy looks like', author: 'smith'},
                {title: 'to die for', author: 'schraff'},
                {title: 'two boys kissing', author: 'levithan'},
                {title: 'the vine basket', author: 'valley'},
                {title: 'when I was the greatest', author: 'reynolds'},
                {title: 'where the streets had a name', author: 'abdel'},
                {title: 'will & whit', author: 'gulledge'},
                {title: 'yaqui delgado wants to', author: 'medina'},
                {title: 'yes, we are latinos', author: 'ada'},
                {title: 'zombie baseball beatdown', author: 'paolo'}]

eagles_reads.each do |book|
  results = Book.where("title ILIKE ? AND author ILIKE ?", "%#{book[:title]}%", "%#{book[:author]}%")
  results.each do |result|
    result.genre_id = Genre.find_by("name ILIKE ?", "eagles read").id
    result.save
  end
end
