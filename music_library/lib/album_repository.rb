require_relative './album'

class AlbumRepository
    def all
        sql = 'SELECT id, title, release_year, artist_id FROM albums;'
        result_set = DatabaseConnection.exec_params(sql, [])

        albums = []

        result_set.each do |record|
            albums << create_album_object(record)
        end

        return albums
    end

  

    def find(id)
        sql = 'SELECT id, title, release_year, artist_id FROM albums WHERE id = $1;'
        params = [id]
        result = DatabaseConnection.exec_params(sql, params)
        record = result[0]

        return create_album_object(record)
    end
  
    def create(album) 
        sql = 'INSERT INTO albums (title, release_year, artist_id) VALUES($1, $2, $3);'
        params = [album.title, album.release_year, album.artist_id]
        DatabaseConnection.exec_params(sql, params) # result = not needed as no return.
        # In exercise vid, return nil
        # Passed RSpec without this.
    end
        
    def delete(id)
        sql = 'DELETE FROM albums WHERE id = $1;'
        params = [id]
        DatabaseConnection.exec_params(sql, params)
        # Returns nothing only deletes.
    end

    def update(album)
        sql = 'UPDATE albums SET title = $1, release_year = $2, artist_id = $3 WHERE id = $4;'
        params = [album.title, album.release_year, album.artist_id, album.id]
        DatabaseConnection.exec_params(sql, params)
        # Returns nothing, only updates.
    end

    private

    def create_album_object(record)
        album = Album.new
        album.id = record['id'].to_i
        album.title = record['title']
        album.release_year = record['release_year'].to_i
        album.artist_id = record['artist_id'].to_i
        return album
    end
end