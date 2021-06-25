class Admin::GenresController < ApplicationController
  def index
    @genre = Genre.new
  end

  def edit
    @genre = Genre.find(params[:id])
  end
  
  def create
    Genre.create(genre_params)
  end
  
  def update
    Genre.find(params[:id]).update(genre_params)
  end
  
  private
  
  def genre_params
    params.require(:genre).permit(:name)
  end

end
