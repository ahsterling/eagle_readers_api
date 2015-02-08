class GenresController < ApplicationController

  def index
    @genres = Genre.all
    render json: @genres.as_json
  end
end
