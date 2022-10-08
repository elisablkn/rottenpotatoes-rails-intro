class MoviesController < ApplicationController

    def show
      id = params[:id] # retrieve movie ID from URI route
      @movie = Movie.find(id) # look up movie by unique ID
      # will render app/views/movies/show.<extension> by default
    end
  
    def index
      @all_ratings = Movie.all_ratings
      
      if session[:ratings].nil?
        @ratings_to_show = Movie.all_ratings
        @sorting = nil
        @title_selected = ""
        @release_selected = ""
      else
        @ratings_to_show = params[:ratings] || Movie.all_ratings
      end
      
      session[:ratings] = @ratings_to_show
      @sorting = params[:sort]

      selected = "hilite p-3 mb-2 bg-warning text-dark"

      if !@sorting.nil?
        session[:sort] = @sorting
      else
        @sorting = session[:sort]
      end

      ratings_hash = Hash[@ratings_to_show.collect {|rating| [rating, "1"]}]

      if @sorting == 'title'
        @movies = Movie.order('title').where(rating: ratings_hash.keys)
        @title_selected = selected
      elsif @sorting == 'release_date'
        @movies = Movie.order("#{@sorting} ASC").with_ratings(rating: ratings_hash.keys)
        @release_selected = selected
      else
        @movies = Movie.with_ratings(rating: ratings_hash.keys)
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
  
    private
    # Making "internal" methods private is not required, but is a common practice.
    # This helps make clear which methods respond to requests, and which ones do not.
    def movie_params
      params.require(:movie).permit(:title, :rating, :description, :release_date)
    end
  end