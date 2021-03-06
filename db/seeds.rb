# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

genres = [
  {name: "Music", title: "Play It Again, Reader!", description: "Read a book about music", image: "app/assets/images/badge_icons/music.png", bulk_image: "app/assets/images/badge_icons/music_bulk.png"},
  {name: 'Eagles Read', title: "Eagles Reads Rock", description: 'Read an Eagles Read book', image: "app/assets/images/badge_icons/eagle.png", bulk_image: "app/assets/images/badge_icons/eagle_bulk.png"},
  {name: "Fantasy", title: "Unbelievable!", description: 'Read a fantasy book', image: "app/assets/images/badge_icons/fantasy.png", bulk_image: "app/assets/images/badge_icons/fantasy_bulk.png"},
  {name: "Science Fiction", title: "To Infinity and Beyond!", description: "Read a science fiction book", image: "app/assets/images/badge_icons/scifi.png", bulk_image: "app/assets/images/badge_icons/scifi_bulk.png"},
  {name: "Historical Fiction", title: "Can You Imagine It?", description: "Read a historical fiction", image: "app/assets/images/badge_icons/hist_fic.png", bulk_image: "app/assets/images/badge_icons/hist_fic_bulk.png"},
  {name: "Mystery", title: "Whodunnit?", description: "Read a mystery", image: "app/assets/images/badge_icons/mystery.png", bulk_image: "app/assets/images/badge_icons/mystery_bulk.png"},
  {name: "Horror", title: "Eeeek!", description: "Read a horror book", image: "app/assets/images/badge_icons/horror.png", bulk_image: "app/assets/images/badge_icons/horror_bulk.png"},
  {name: "Adventure", title: "Here We Go!", description: "Read an adventure book", image: "app/assets/images/badge_icons/adventure.png", bulk_image: "app/assets/images/badge_icons/adventure_bulk.png"},
  {name: "Fiction", title: "Tell Me A Story", description: "Read a fiction book", image: "app/assets/images/badge_icons/fiction.png", bulk_image: "app/assets/images/badge_icons/fiction_bulk.png"},
  {name: "Animals", title: "Animal Ranger", description: "Read a book about animals", image: "app/assets/images/badge_icons/animal.png", bulk_image: "app/assets/images/badge_icons/animal_bulk.png"},
  {name: "Poetry", title: "Poetry Slam", description: "Read a poetry book", image: "app/assets/images/badge_icons/poetry.png", bulk_image: "app/assets/images/badge_icons/poetry_bulk.png"},
  {name: "Graphic Novel", title: "Comic Extravaganza", description: "Read a graphic novel", image: "app/assets/images/badge_icons/comics.png", bulk_image: "app/assets/images/badge_icons/comics_bulk.png"},
  {name: "Biography", title: "#truestory", description: "Read a biography", image: "app/assets/images/badge_icons/biography.png", bulk_image: "app/assets/images/badge_icons/biography_bulk.png"},
  {name: "History", title: "Tell Me About It", description: "Read a book about history", image: "app/assets/images/badge_icons/history.png", bulk_image: "app/assets/images/badge_icons/history_bulk.png"},
  {name: "Mythology and Folktales", title: "Mythbusters", description: "Read a book about mythology or folktales", image: "app/assets/images/badge_icons/mythology.png", bulk_image: "app/assets/images/badge_icons/mythology_bulk.png"},
  {name: "Sports", title: "Go Team!", description: "Read a book about sports", image: "app/assets/images/badge_icons/sports.png", bulk_image: "app/assets/images/badge_icons/sports_bulk.png"},
  {name: "Science", title: "Mad Scientist", description: "Read a book about science", image: "app/assets/images/badge_icons/science.png", bulk_image: "app/assets/images/badge_icons/science_bulk.png"},
  {name: "Nonfiction and Other", title: "I didn't know that . .  ", description: "Read a non-fiction book", image: "app/assets/images/badge_icons/nonfiction.png", bulk_image: "app/assets/images/badge_icons/nonfiction_bulk.png"}
]

genres.each do |genre|
  Genre.create(name: genre[:name])
  genre_badge = GenreBadge.create(genre_name: genre[:name], title: genre[:title], description: genre[:description])
  image_src = File.join(Rails.root, genre[:image])
  src_file = File.new(image_src)
  genre_badge.image = src_file
  genre_badge.save
  bulk_genre_badge = GenreBadge.create(genre_name: genre[:name], title: "Genre Champion: #{genre[:name]}", bulk_badge: true, description: "Read 5 #{genre[:name]} books")
  image_src = File.join(Rails.root, genre[:bulk_image])
  src_file = File.new(image_src)
  bulk_genre_badge.image = src_file
  bulk_genre_badge.save
end

explorer_badge = GenreBadge.create(title: "Genre Explorer", explorer_badge: true, description: "Read 5 books from different genres")
src_file = File.new('app/assets/images/badge_icons/genre_explorer.png')
explorer_badge.image = src_file
explorer_badge.save


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
    book.genre_id = Genre.find_by(name: "Nonfiction and Other").id
  else
    if book.subject_array.grep(/fantasy/i).count > 0 || book.subject_array.grep(/fantastical/i).count > 0
      book.genre_id = Genre.find_by(name: "Fantasy").id
    elsif book.subject_array.grep(/science fic/i).count > 0
      book.genre_id = Genre.find_by(name: "Science Fiction").id
    elsif book.subject_array.grep(/historical f/i).count > 0
      book.genre_id = Genre.find_by(name: "Historical Fiction").id
    elsif book.subject_array.grep(/mystery/i).count > 0 || book.subject_array.grep(/suspense/i).count > 0
      book.genre_id = Genre.find_by(name: "Mystery").id
    elsif book.subject_array.grep(/horror/i).count > 0 || book.subject_array.grep(/occult/i).count > 0 || book.subject_array.grep(/paranormal/i).count > 0
      book.genre_id = Genre.find_by(name: "Horror").id
    elsif book.subject_array.grep(/adventure/i).count > 0
      book.genre_id = Genre.find_by(name: "Adventure").id
    elsif book.subject_array.grep(/animal/i).count > 0
      book.genre_id = Genre.find_by(name: "Animals").id
    elsif book.subject_array.grep(/poetry/i).count > 0
      book.genre_id = Genre.find_by(name: "Poetry").id
    elsif book.subject_array.grep(/comic/i).count > 0 || book.subject_array.grep(/graphic n/i).count > 0
      book.genre_id = Genre.find_by(name: "Graphic Novel").id
    elsif book.subject_array.grep(/music/i).count > 0
      book.genre_id = Genre.find_by(name: "Music").id
    elsif book.subject_array.grep(/biography/i).count > 0
      book.genre_id = Genre.find_by(name: "Biography").id
    elsif book.subject_array.grep(/history/i).count > 0
      book.genre_id = Genre.find_by(name: "History").id
    elsif book.subject_array.grep(/mythology/i).count > 0 || book.subject_array.grep(/folktale/i).count > 0
      book.genre_id = Genre.find_by(name: "Mythology and Folktales").id
    elsif book.subject_array.grep(/sports/i).count > 0
      book.genre_id = Genre.find_by(name: "Sports").id
    elsif book.subject_array.grep(/biology/i).count > 0 || book.subject_array.grep(/chemistry/i).count > 0 || book.subject_array.grep(/physics/i).count > 0 || book.subject_array.grep(/engineering/).count > 0 || book.subject_array.grep(/geology/).count > 0
      book.genre_id = Genre.find_by(name: "Science").id
    elsif book.subject_array.grep(/fiction/i).count > 0 || book.subject_array.grep(/literature/i).count > 0
      book.genre_id = Genre.find_by(name: "Fiction").id
    else
      book.genre_id = Genre.find_by(name: "Nonfiction and Other").id
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
