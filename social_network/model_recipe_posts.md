# SOCIAL NETWORK Model and Repository Classes Design Recipe


## 1. Design and create the Table

If the table is already created in the database, you can skip this step.
x
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
-- (file: spec/seeds_users.sql)

-- Write your SQL seed here. 

-- First, you'd need to truncate the table - this is so our table is emptied between each test run,
-- so we can start with a fresh state.
-- (RESTART IDENTITY resets the primary key)

TRUNCATE TABLE users RESTART IDENTITY; -- replace with your own table name.

-- Below this line there should only be `INSERT` statements.
-- Replace these statements with your own seed data.

INSERT INTO users (email, username) VALUES ('example@email.com', 'test_user');
INSERT INTO users (email, username) VALUES ('test@online.com', 'sample_account');

(file: spec/seeds_posts.sql)

TRUNCATE TABLE posts RESTART IDENTITY;

INSERT INTO posts (title, content, views, user_id) VALUES ('title1', ' some content for you', 244, 1);
INSERT INTO posts (title, content, views, user_id) VALUES ('title2', 'April 2022 content', 364, 2);

Run this SQL file on the database to truncate (empty) the table, and insert the seed data. Be mindful of the fact any existing records in the table will be deleted.

```bash
psql -h 127.0.0.1 social_network_test < spec/seeds_posts.sql
psql -h 127.0.0.1 social_network_test < spec/seeds_users.sql
```

## 3. Define the class names

Usually, the Model class name will be the capitalised table name (single instead of plural). The same name is then suffixed by `Repository` for the Repository class name.

```ruby
table: posts

# Model class
# (in lib/post.rb)

class Post
end

# Repository class
# (in lib/post_repository.rb)
class PostRepository
end
```

## 4. Implement the Model class

Define the attributes of your Model class. You can usually map the table columns to the attributes of the class, including primary and foreign keys.

```ruby
# EXAMPLE
# Table name: Posts

# Model class
# (in lib/post.rb)

class Post

  # Replace the attributes by your own columns.
  attr_accessor :id, :title, :content, :views, :user_id
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
# Table name: students

# Repository class
# (in lib/post_repository.rb)

class PostRepository

  # Selecting all records
  # No arguments
  def all
    # Executes the SQL query:
    # SELECT id, title, content, views, user_id FROM posts;

    # Returns an array of Post objects.
  end

  # Gets a single record by its ID
  # One argument: the id (number)
  def find(id)
    # Executes the SQL query:
    # SELECT id, title, content, views, user_id FROM posts WHERE id = $1;

    # Returns a single Student object.
  end

  # Add more methods below for each operation you'd like to implement.
# Inserts a new post
 # Requires an user_id
    def create(user) 
        # Executes the SQL query:
        # INSERT INTO posts (title, content, views, user_id) VALUES($1, $2);

        # Does not need to return anything, only create.
    end

    # Deletes a post record
    # Given its id
    def delete(id)
        #Executes the SQL:
        # DELETE FROM posts WHERE id = $1;

        # Returns nothing only deletes.
    end

    # Updates a post record
    # Takes a post object (with updated fields)
    def update(post)
        # Executes the SQL:
        # UPDATE posts SET title = $1, content = $2, views = $3, user_id = $4 WHERE id = $5;
    
        # Returns nothing, only updates.
    end
end
```

## 6. Write Test Examples

Write Ruby code that defines the expected behaviour of the Repository class, following your design from the table written in step 5.

These examples will later be encoded as RSpec tests.

```ruby
# EXAMPLES


# 1
# Get all posts

repo = PostRepository.new
posts = repo.all # returns all results
post = posts.first 
expect(posts.length) # => 2
expect(post.id) # => 1
expect(post.title) # => 'title1'
expect(post.content) # => ' some content for you'
expect(post.views) # => 244
expect(post.user_id) # => 1


#2 
# find a specified post
repo = PostRepository.new
post = repo.find(1)
expect(post.id) # => '1'
expect(post.title) #=>'title1'
expect(post.content) # 'some content for you'
expect(post.views) #=> 244
expect(post.user_id) # => 1

#3
# create a new post
repo = PostRepository.new
post = Post.new
post.title = 'New Title'
post.content = 'Content for my post'
post.views = 1
post.user_id = 1
repo.create(post)
posts = repo.all
result = posts.last
expect(result.id) # => 3
expect(result.title) # => 'New Title'
expect(result.content) # => 'Content for my post'
expect(result.views) # => 1
expect(result.user_id) # => 1


#4
# can verify a new post
repo = PostRepository.new
post = Post.new
post.title= 'title!'
post.content = 'content for my post'
repo.create(post)
posts = repo.all
expect(posts).to include(
            have_attributes(
                title: post.title,
                content: post.content
            )
        )

#5
# delete a specified post
repo = PostRepository.new
repo.delete(1)
posts = repo.all
result = posts.first
expect(posts.length) # => 1
expect(result.id) # => '2'
expect(result.title) # => 'title2'
expect(result.content) # => 'April 2022 content'


#6
#Updates a record
repo = PostRepository.new
post = repo.find(2)
post.title = 'Read this!'
post.content = 'New content coming'
repo.update(post)
result = repo.find(2)
expect(result.id) # => 2
expect(result.title) # => 'Read this!'
expect(result.content) # => 'New content coming'
expect(result.views) #=> 364
expect(result.user_id)#=> 2
# Add more examples for each method
```

Encode this example as a test.

## 7. Reload the SQL seeds before each test run

Running the SQL code present in the seed file will empty the table and re-insert the seed data.

This is so you get a fresh table contents every time you run the test suite.

```ruby
# EXAMPLE

# file: spec/post_repository_spec.rb

def reset_posts_table
  seed_sql = File.read('spec/seeds_posts.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'posts' })
  connection.exec(seed_sql)
end


before(:each) do 
    reset_posts_table
end

  # (your tests will go here).
end
```

## 8. Test-drive and implement the Repository class behaviour

_After each test you write, follow the test-driving process of red, green, refactor to implement the behaviour._

