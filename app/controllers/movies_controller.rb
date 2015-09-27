class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
    
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = ['G','PG','PG-13','R']
    
    #if ( [params[:ratings]] != nil )
    #Code inspired by: http://railscasts.com/episodes/228-sortable-table-columns?view=asciicast
  
      #@movies = Movie.find(:rating => params[:rating])
      #@movies = Movie.find(:all, conditions: ["rating IN (?)", params[:ratings]])
      #@movies = Movie.where("rating IN (?)", params[:ratings])
    #end
    @movies = Movie.order(params[:x])
    #@movies = Movie.all.find_by_rating(params[:ratings])
    #@movies = Movie
    #@movies = Movie.order(params[:sort_by]).find_by_rating(params[:ratings])
    #@movies = Movie.find("rating IN (?)", params[:ratings])

    if params[:sort_by] == 'title'
      @title_header = 'hilite'
    elsif params[:sort_by] == 'release_date'
      @release_header ='hilite'
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end


  