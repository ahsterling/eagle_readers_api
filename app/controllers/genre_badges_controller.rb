class GenreBadgesController < ApplicationController

  def index
    @genre_badges = GenreBadge.all
  end

end
