require_relative 'lib/database_connection'
require_relative 'lib/artist_repository'

DatabaseConnection.connect('music_library')

# result = DatabaseConnection.exec_params('SELECT * FROM artists;', [])

# result.each do |record|
#     p record
# end

artist_repository = ArtistRepository.new

# p artist_repository.all << This printed results in array.

artist_repository.all.each do |artist|   # << This breaks each result out of array
    p artist
end