require 'album_repository'

RSpec.describe AlbumRepository do

    def reset_albums_table
        seed_sql = File.read('spec/seeds_albums.sql')
        connection = PG.connect({ host: '127.0.0.1', dbname: 'music_library_test' })
        connection.exec(seed_sql)
    end
  
    before(:each) do 
      reset_albums_table
    end

    it "returns a list of all albums" do
        repo = AlbumRepository.new
        albums = repo.all 
        expect(albums.length).to eq 2 
        expect(albums.first.id).to eq 1 
        expect(albums.first.title).to eq 'Surfer Rosa'
        expect(albums.first.release_year).to eq 1988 
        expect(albums.first.artist_id).to eq 1
    end

    it "returns a specific entry" do
        repo = AlbumRepository.new
        albums = repo.all
        result = albums[1]
        expect(result.id).to eq 2
        expect(result.title).to eq 'Super Trooper'
        expect(result.release_year).to eq 1980
        expect(result.artist_id).to eq 2
    end

    it "finds a specific entry" do
        repo = AlbumRepository.new
        album = repo.find(2)    
        expect(album.id).to eq 2
        expect(album.title).to eq 'Super Trooper'
        expect(album.release_year).to eq 1980
        expect(album.artist_id).to eq 2
    end

    it 'creates a new album' do
        repo = AlbumRepository.new
        album = Album.new
        album.title = 'Olympia'
        album.release_year = 2022
        album.artist_id = 3
        repo.create(album)
        albums = repo.all
        result = albums.last
        expect(result.title).to eq 'Olympia'
        expect(result.release_year).to eq 2022
        expect(result.artist_id).to eq 3
    end

    it 'creates a new album' do
        repo = AlbumRepository.new
        album = Album.new
        album.title = 'Trompe le Monde'
        album.release_year = 1991
        album.artist_id = 1
        repo.create(album)
        all_albums = repo.all
        expect(all_albums).to include(
            have_attributes(
                title: album.title,
                release_year: album.release_year
            )
        )
    end
    
    it 'deletes a specified album' do
        repo = AlbumRepository.new
        repo.delete(1)
        albums = repo.all
        result = albums.first
        expect(albums.length).to eq 1
        expect(result.id).to eq 2
        expect(result.title).to eq 'Super Trooper'
        expect(result.release_year).to eq 1980
        expect(result.artist_id).to eq 2
    end

    it 'updates a record' do
        repo = AlbumRepository.new
        album = repo.find(2)
        album.title = 'Voyage'
        album.release_year = 2021
        repo.update(album)
        result = repo.find(2)
        expect(result.id).to eq 2
        expect(result.title).to eq 'Voyage'
        expect(result.release_year).to eq 2021
        expect(result.artist_id).to eq 2
    end
end