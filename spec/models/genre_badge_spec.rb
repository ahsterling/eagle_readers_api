require 'rails_helper'

describe GenreBadge do

  describe 'associations' do
    it 'can have many users through user_genre_badges' do
      badge = GenreBadge.create(genre_name: "Fiction", description: "blah")
      user = User.create(email: 'email11@email.com', password: "blahblah", password_confirmation: "blahblah", uid: "email11@email.com")
      UserGenreBadge.create(user_id: user.id, genre_badge_id: badge.id)
      expect(user.genre_badges.count).to eq 1
    end
  end

end
