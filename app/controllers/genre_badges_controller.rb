class GenreBadgesController < ApplicationController

  def index
    @genre_badges = GenreBadge.all
    render json: @genre_badges.as_json
  end

end
