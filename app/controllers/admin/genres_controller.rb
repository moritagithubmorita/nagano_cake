class Admin::GenresController < ApplicationController
  skip_before_action :authenticate_customer!
  before_action :authenticate_admin!

  def index
    @generated_genre = Genre.new
    @genre = Genre.new
  end

  def edit
    @generated_genre = Genre.new
    @genre = Genre.find(params[:id])
  end

  def create
    @generated_genre = Genre.new(genre_params)
    if @generated_genre.save
      redirect_to admin_genres_path
    else
      @genre = Genre.new
      render :index
    end
  end

  def update
    @generated_genre = Genre.find(params[:id])
    if @generated_genre.update(genre_params)
      redirect_to admin_genres_path
    else
      @genre = Genre.find(params[:id])
      render :edit
    end
  end

  private

  def genre_params
    params.require(:genre).permit(:name)
  end

end
