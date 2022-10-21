require_relative 'lib/database_connection'
require_relative 'lib/recipe_repository'

DatabaseConnection.connect('recipes_directory')

recipe_repository = RecipeRepository.new

recipe_repository.all.each do |recipe|   
    p recipe
end

# album = album_repository.find(8)
# puts album.title
# puts album.release_year
