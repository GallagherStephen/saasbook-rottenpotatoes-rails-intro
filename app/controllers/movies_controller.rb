class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    
    
    @sort = params[:sort] || session[:sort]
    
    session[:ratings] = session[:ratings] || @all_ratings
    
    @all_ratings = Movie.all_ratings
    
    @ratings = params[:ratings] || session[:ratings]
    session[:sort] = @sort
    session[:ratings] = @ratings
    
    
    if @ratings == nil
      @ratings = Hash.new
      @all_ratings.each do |m|
        @ratings[m] = 0
      end
    end
    
    @ratings_to_show = @ratings

    if @ratings != nil && @sort != nil
      @movies = Movie.with_ratings(session[:ratings].keys).order(session[:sort])
    elsif   @ratings != nil
      @movies = Movie.with_ratings(@ratings.keys)
    else
     @movies = Movie.all
    end
    
    
    
    
   #params[:ratings]
   #params[:title]
   #params[:release_date]
    
    
  end
  
  def sort_column
    @movies = Movie.all_ratings
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

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end
