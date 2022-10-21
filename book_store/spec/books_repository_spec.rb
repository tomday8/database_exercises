require 'books_repository'

RSpec.describe BooksRepository do

    def reset_books_table
        seed_sql = File.read('spec/seeds_books.sql')
        connection = PG.connect({ host: '127.0.0.1', dbname: 'book_store_test' })
        connection.exec(seed_sql)
    end
      

    before(:each) do 
      reset_books_table
    end

    it "gets all books" do
        repo = BooksRepository.new
        books = repo.all
        expect(books.length).to eq 2
    end

    it "returns the details of the first book" do 
        repo = BooksRepository.new
        books = repo.all  
        expect(books.first.id).to eq '1' 
        expect(books.first.title).to eq 'Nineteen Eighty-Four'
        expect(books.first.author_name).to eq 'George Orwell'
    end

    it "returns the details of a specific book" do
        repo = BooksRepository.new
        books = repo.all
        book = books[1]
        expect(book.id).to eq '2'
        expect(book.title).to eq 'Mrs Dalloway'
        expect(book.author_name).to eq 'Virginia Woolf'
    end
end