class Movie < ActiveRecord::Base
  @all_ratings = ['G','PG','PG-13','R']
  
  def all_ratings
    @all_ratings
  end

  def self.with_ratings(ratings_list)
    if ratings_list.nil?
      ratings_list = Movie.all_ratings
    end
    ratings_list.each do |r|
      Movie.where(:rating => r)
    end
  end
end