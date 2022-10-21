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

# Table name: users

# Model class
# (in lib/user.rb)
class User
end

# Repository class
# (in lib/user_repository.rb)
class UserRepository
end
```

## 4. Implement the Model class

Define the attributes of your Model class. You can usually map the table columns to the attributes of the class, including primary and foreign keys.

```ruby
# EXAMPLE
# Table name: users

# Model class
# (in lib/user.rb)

class User
  attr_accessor :id, :email, :username
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
# Table name: users

# Repository class
# (in lib/user_repository.rb)

class UserRepository

  # Selecting all records
  # No arguments
  def all
    # Executes the SQL query:
    #sql = 'SELECT id, name, cohort_name FROM users;'

    # Returns an array of user objects.
    
  end

  # Gets a single record by its ID
  # One argument: the id (number)
  def find(id)
    # Executes the SQL query:
    # SELECT id, email, username FROM users WHERE id = $1;

    # Returns a single user object.
  end

 # Inserts a new user
 # Requires an user_id
    def create(user) 
        # Executes the SQL query:
        # INSERT INTO users (email, username) VALUES($1, $2);

        # Does not need to return anything, only create.
    end

    # Deletes a user record
    # Given its id
    def delete(id)
        #Executes the SQL:
        # DELETE FROM users WHERE id = $1;

        # Returns nothing only deletes.
    end

    # Updates a user record
    # Takes a user object (with updated fields)
    def update(user)
        # Executes the SQL:
        # UPDATE users SET email = $1, username = $2 WHERE id = $3;
    
        # Returns nothing, only updates.
    end
  
end
```

## 6. Write Test Examples

Write Ruby code that defines the expected behaviour of the Repository class, following your design from the table written in step 5.

These examples will later be encoded as RSpec tests.

```ruby

# 1
# Get all users

repo = UserRepository.new
users = repo.all # returns all results
user = users.first 
(users.length) # => 2
(user.first.id) # => '1'
(user.first.email) # => 'example@email.com'
(user.first.username) # => 'test_user'



#2 
# find a specified user
repo = UserRepository.new
user = repo.find(1)
expect(user.id) # => '1'
expect(user.email) # => 'example@email.com'
expect(user.username) # => test_user

#3
# create a new user
repo = UserRepository.new
user = User.new
user.email = 'username95@test.com'
user.username = 'username95'
repo.create(user)
users = repo.all
result = users.last
expect(result.id) # => 3
expect(result.email) # => 'username95'
expect(result.username) # => 'username95'


#4
# can verify a new user
repo = UserRepository.new
user = User.new
user.email = 'username88@test.com'
user.username = 'username88'
repo.create(user)
users = repo.all
expect(users).to include(
            have_attributes(
                email: user.email,
                username: user.username
            )
        )

#5
# delete a specified user
repo = UserRepository.new
repo.delete(1)
users = repo.all
result = users.first
expect(users.length) # => 1
expect(result.id) # => '2'
expect(result.email) # => 'test@online.com'
expect(result.username) # => 'test_user'


#6
#Updates a record
repo = UserRepository.new
user = repo.find(2)
user.email = 'test@new-online.com'
user.username = 'new_test_user'
repo.update(user)
result = repo.find(2)
expect(result.id) # => '2'
expect(result.email) # => 'test@new-online.com'
expect(result.username) # => 'new_test_user'

# Add more examples for each method
```

Encode this example as a test.

## 7. Reload the SQL seeds before each test run

Running the SQL code present in the seed file will empty the table and re-insert the seed data.

This is so you get a fresh table contents every time you run the test suite.

```ruby
# EXAMPLE

# file: spec/user_repository_spec.rb

def reset_users_table
  seed_sql = File.read('spec/seeds_users.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'social_network_test' })
  connection.exec(seed_sql)
end

  before(:each) do 
    reset_users_table
  end

  # (your tests will go here).

```

## 8. Test-drive and implement the Repository class behaviour

_After each test you write, follow the test-driving process of red, green, refactor to implement the behaviour._

