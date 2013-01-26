class MyController < ApplicationController

  def index
    @animes = Anime.find( :all )
  end

end
