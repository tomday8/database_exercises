require_relative './books'

class BooksRepository
    def all
        sql = 'SELECT id, title, author_name FROM books;'
        result_set = DatabaseConnection.exec_params(sql, [])

        books = []

        result_set.each do |data|
            book = Books.new
            book.id = data['id']
            book.title = data['title']
            book.author_name = data['author_name']

            books << book
        end

        return books
    end    
  
end