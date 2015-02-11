USERNAMES = [];
CSV.foreach('eckstein_usernames.csv') do |row|
  username = row[1]

  if /@/.match(username)
    username = /@/.match(username).pre_match
  end
  USERNAMES << username
end
