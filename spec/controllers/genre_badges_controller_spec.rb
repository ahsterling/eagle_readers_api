require 'rails_helper'

describe GenreBadgesController do
  describe 'GET #index' do
    it 'is successful' do
      get :index
      expect(response.status).to eq 200
    end

    it 'assigns @genre_badges to an array of genre badges' do
      genre_badge = GenreBadge.create(genre_name: "Mystery")
      get :index
      expect(assigns(:genre_badges)).to match_array [genre_badge]
    end
  end
end
