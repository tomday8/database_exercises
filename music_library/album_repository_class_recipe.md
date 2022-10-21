# Artists Model and Repository Classes Design Recipe

_Copy this recipe template to design and implement Model and Repository classes for a database table._

## 1. Design and create the Table

If the table is already created in the database, you can skip this step.

Otherwise, [follow this recipe to design and create the SQL schema for your table](./single_table_design_recipe_template.md).

*In this template, we'll use an example table `students`*

```
# EXAMPLE

Table: students

Columns:
id | name | cohort_name
```

## 2. Create Test SQL seeds

Your tests will depend on data stored in PostgreSQL to run.

If seed data is provided (or you already created it), you can skip this step.

```sql
-- EXAMPLE
-- (file: spec/seeds_{table_name}.sql)

-- Write your SQL seed here. 

-- First, you'd need to truncate the table - this is so our table is emptied between each test run,
-- so we can start with a fresh state.
-- (RESTART IDENTITY resets the primary key)

TRUNCATE TABLE albums RESTART IDENTITY; -- replace with your own table name.

-- Below this line there should only be `INSERT` statements.
-- Replace these statements with your own seed data.

INSERT INTO albums (title, release_year, artist_id) VALUES ('Surfer Rosa', '1988', '1');
INSERT INTO albums (title, release_year, artist_id) VALUES ('Super Trooper', '1980', '2');
```

Run this SQL file on the database to truncate (empty) the table, and insert the seed data. Be mindful of the fact any existing records in the table will be deleted.

```bash
psql -h 127.0.0.1 music_library_test < spec/seeds_albums.sql
```

## 3. Define the class names

Usually, the Model class name will be the capitalised table name (single instead of plural). The same name is then suffixed by `Repository` for the Repository class name.

```ruby
# EXAMPLE
# Table name: albums

# Model class
# (in lib/album.rb)
class Album
end

# Repository class
# (in lib/album_repository.rb)
class AlbumRepository
end
```

## 4. Implement the Model class

Define the attributes of your Model class. You can usually map the table columns to the attributes of the class, including primary and foreign keys.

```ruby
# EXAMPLE
# Table name: students

# Model class
# (in lib/student.rb)

class Album

  # Replace the attributes by your own columns.
  attr_accessor :id, :title, :release_year, :artist_id
end

# The keyword attr_accessor is a special Ruby feature
# which allows us to set and get attributes on an object,
# here's an example:
#
# student = Student.new
# student.name = 'Jo'
# student.name
```

*You may choose to test-drive this class, but unless it contains any more logic than the example above, it is probably not needed.*

## 5. Define the Repository Class interface

Your Repository class will need to implement methods for each "read" or "write" operation you'd like to run against the database.

Using comments, define the method signatures (arguments and return value) and what they do - write up the SQL queries that will be used by each method.

```ruby
# EXAMPLE
# Table name: artists

# Repository class
# (in lib/artist_repository.rb)

class AlbumRepository
    def all
        sql = 'SELECT id, title, release_year, artist_id FROM albums;'
        result_set = DatabaseConnection.exec_params(sql, [])

        albums = []

        result_set.each do |record|
            album = Album.new
            album.id = record['id']
            album.title = record['title']
            artist.release_year = record['release_year']
            artist.artist_id = record['artist_id']

            albums << album
        end

        return albums
    end

#Select a single record
#Given the ID as an argument (int)
    def find(id)
        #EXECUTES the SQL query;
        # 'SELECT id, title, release_year, artist_id FROM albums WHERE id = $1;'
        sql = 'SELECT id, title, release_year, artist_id FROM albums WHERE id = $1;'

        params = [id]

        result = DatabaseConnection.exec_params(sql, params)
        
        #returns a single album
    end

    # Inserts a new album
    # Requires an artist_id
    def create(album) 
        # Executes the SQL query:
        # INSERT INTO albums (title, release_year, artist_id) VALUES($1, $2, $3);

        # Does not need to return anything, only create.
    end

    # Deletes an album record
    # Given its id
    def delete(id)
        #Executes the SQL:
        # DELETE FROM artists WHERE id = $1;

        # Returns nothing only deletes.
    end

    # Updates an album record
    # Takes an album object (with updated fields)
    def update(album)
        # Executes the SQL:
        # UPDATE albums SET title = $1, genre = $2 WHERE id = $3;
    
        # Returns nothing, only updates.
    end
end

## 6. Write Test Examples

Write Ruby code that defines the expected behaviour of the Repository class, following your design from the table written in step 5.

These examples will later be encoded as RSpec tests.

``ruby
# EXAMPLES

# 1
# Get all albums

repo = AlbumRepository.new

albums = repo.all # returns all results
albums.length # => 2
albums.first.id # => '1'
albums.first.release_year # => 'Pixies'
albums.first.artist_id



#2 
# find a specified album
repo = AlbumRepository.new
album = repo.find(2)
expect(albums.id) # => '2'
expect(albums.release_year) # => 'Pixies'
expect(albums.artist_id) # => 2

#3
# create a new album
repo = AlbumRepository.new
album = Album.new
album.name = 'Olympia'
album.release_year = 2022
album.artist_id = 3
repo.create(album)
albums = repo.all
result = albums.last
expect(result.name) # => 'Olympia'
expect(result.release_year) # => 2022
expect(result.artist_id) # => 3

#4 
# delete a specified album
repo = AlbumRepository.new
repo.delete(1)
albums = repo.all
result = albums.first
expect(albums.length) # => 1
expect(result.id) # => '2'
expect(result.title) # => 'Super Trooper'
expect(result.release_year) # => '1980'
expect(result.artist_id) # => '2'# => 3

#5
#Updates a record
repo = AlbumRepository.new
album = repo.find(2)
album.title = 'Voyage'
album.release_year = 2021
repo.update(album)
expect(album.id) # => '2'
expect(album.title) # => 'Voyage'
expect(album.release_year) # => '2021'
expect(album.artist_id) # => '2'

# Add more examples for each method
```

Encode this example as a test.

## 7. Reload the SQL seeds before each test run

Running the SQL code present in the seed file will empty the table and re-insert the seed data.

This is so you get a fresh table contents every time you run the test suite.

```ruby
# EXAMPLE

# file: spec/student_repository_spec.rb

def reset_albums_table
  seed_sql = File.read('spec/seeds_albums.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'music_library_test' })
  connection.exec(seed_sql)
end

# describe StudentRepository do
  before(:each) do 
    reset_albums_table
  end

  # (your tests will go here).
end
```

## 8. Test-drive and implement the Repository class behaviour

_After each test you write, follow the test-driving process of red, green, refactor to implement the behaviour._


