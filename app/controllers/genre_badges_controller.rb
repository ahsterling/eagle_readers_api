class GenreBadgesController < ApplicationController

  def index
    @genre_badges = GenreBadge.all
    render json: @genre_badges.as_json
  end

  def show
    @genre_badge = GenreBadge.find(params[:id])
    render json: @genre_badge.as_json
  end

end
