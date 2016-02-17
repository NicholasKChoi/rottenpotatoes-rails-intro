class Movie < ActiveRecord::Base
    def Movie.all_ratings
        return ['G','PG','PG-13','R']
    end
end
