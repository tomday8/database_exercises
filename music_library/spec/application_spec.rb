require 'application'

RSpec.describe Application do
    it 'initializes' do
        io = double :io
        app = Application.new('music_library_test', io, AlbumRepository.new, ArtistRepository.new)
        expect(io).to receive(:puts).with('Welcome to the music library manager!')
        expect(io).to receive(:puts).with('What would you like to do?
            1 - List all albums
            2 - List all artists')
        expect(io).to receive(:puts).with('Enter your choice:')
        expect(io).to receive(:gets).and_return("1\n")
        expect(io).to receive(:puts).with("")
        app.run
    end
end