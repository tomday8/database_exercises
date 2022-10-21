require 'application'

RSpec.describe Application do
    it 'initializes' do
        io = double(:io)
        app = Application.new('music_library_test', io, AlbumRepository.new, ArtistRepository.new)
        expect(io).to receive(:puts).with('Welcome to the music library manager!')
        expect(io).to receive(:puts).with('Test')
        expect(io).to receive(:gets).and_return("1\n")
        app.run
    end
end