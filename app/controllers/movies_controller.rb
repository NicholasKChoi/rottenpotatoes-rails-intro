class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end
  
  def clear
    session.clear
    redirect_to movies_path()
  end

  def index
    print "params are #{params} \n"
    @all_ratings = Movie.all_ratings
    if not params[:ratings] or (not params[:order] and session[:order])
      flash.keep
      if not session[:ratings] and not params[:ratings]
        params[:ratings] = {"G"=>"1", "PG" => 1, "PG-13" => 1, "R"=> 1}
      elsif not params[:ratings]
        params[:ratings] = session[:ratings]
      end
      if session[:order] and not params[:order]
        params[:order] = session[:order]
      end
      redirect_to movies_path(params)
    end
    ratings = params[:ratings].keys
    order = params[:order]

    if order
      if order == "release_date"
        @movies = Movie.reorder(:release_date).where(rating: ratings)
        
      elsif order == "title"
        @movies = Movie.reorder(:title).where(rating: ratings)
      end
    else
      @movies = Movie.where(rating: ratings)
    end
    session[:ratings] = params[:ratings] || session[:ratings]
    session[:order] = params[:order] || session[:order]
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
