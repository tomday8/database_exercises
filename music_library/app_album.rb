require_relative 'lib/database_connection'
require_relative 'lib/album_repository'

DatabaseConnection.connect('music_library')


album_repository = AlbumRepository.new

# album_repository.all.each do |album|   
#     p album
# end

album = album_repository.find(8)
puts album.title
puts album.release_year
