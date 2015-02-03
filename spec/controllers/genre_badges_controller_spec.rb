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

    it 'retruns json of the data' do
      genre_badge = GenreBadge.create(genre_name: "Mystery")
      get :index
      body = JSON.parse(response.body)
      genre_badges = body.map { |b| b['genre_name'] }
      expect(genre_badges).to match_array(["Mystery"])
    end
  end

  describe 'GET #show' do
    it 'is successful' do
      genre_badge = GenreBadge.create(genre_name: "Mystery")
      get :show, id: genre_badge.id
      expect(response.status).to eq 200
    end
  end
end
