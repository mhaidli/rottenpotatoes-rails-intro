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

    @all_ratings = Movie.all_ratings
    
    if params[:ratings].nil? && session[:ratings].nil?
      @our_ratings = Hash[@all_ratings.map {|x| [x,x]}]
      
    elsif params[:ratings].nil?
      @our_ratings = session[:ratings]
      
    else
      @our_ratings = params[:ratings]
    end
    
    if params[:sort_by].nil?
      @our_sort_by = session[:sort_by]
    else
      @our_sort_by = params[:sort_by]
    end
    
    if session[:ratings] != @our_ratings
      session[:ratings] = @our_ratings
      redirect_to :ratings => @our_ratings and return
    end
    
    if session[:sort_by] != @our_sort_by
      session[:sort_by] = @our_sort_by
      redirect_to :sort_by => @our_sort_by and return
    end

    @movies = Movie.where(:rating => @our_ratings.keys).order(@our_sort_by)

    if @our_sort_by == 'title'
      @title_header = 'hilite'
    elsif @our_sort_by == 'release_date'
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


  