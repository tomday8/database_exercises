require_relative 'lib/database_connection'
require_relative 'lib/books_repository'

DatabaseConnection.connect('book_store')

books_repository = BooksRepository.new

books_repository.all.each do |book|   
    p book
end