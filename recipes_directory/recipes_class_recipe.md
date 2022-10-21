# Recipes -  Model and Repository Classes Design Recipe

_Copy this recipe template to design and implement Model and Repository classes for a database table._

## 1. Design and create the Table

If the table is already created in the database, you can skip this step.

Otherwise, [follow this recipe to design and create the SQL schema for your table](./single_table_design_recipe_template.md).

*In this template, we'll use an example table `students`*

```
# EXAMPLE

Table: recipes

Columns:
id |recipe_name | cooking_time | rating
```

## 2. Create Test SQL seeds

Your tests will depend on data stored in PostgreSQL to run.

If seed data is provided (or you already created it), you can skip this step.

```sql
-- EXAMPLE
-- (file: spec/seeds_recipes.sql)

-- Write your SQL seed here. 

-- First, you'd need to truncate the table - this is so our table is emptied between each test run,
-- so we can start with a fresh state.
-- (RESTART IDENTITY resets the primary key)

TRUNCATE TABLE recipes RESTART IDENTITY; -- replace with your own table name.

-- Below this line there should only be `INSERT` statements.
-- Replace these statements with your own seed data.

INSERT INTO recipes (recipe_name, cooking_time, rating) VALUES ('Spaghetti Bolognese', 20, 4);
INSERT INTO recipes (recipe_name, cooking_time, rating) VALUES ('Chilli', 25, 5);
```

Run this SQL file on the database to truncate (empty) the table, and insert the seed data. Be mindful of the fact any existing records in the table will be deleted.

```bash
psql -h 127.0.0.1 recipes_directory_test < spec/seeds_recipes.sql
```

## 3. Define the class names

Usually, the Model class name will be the capitalised table name (single instead of plural). The same name is then suffixed by `Repository` for the Repository class name.

```ruby
# EXAMPLE
# Table name: recipes

# Model class
# (in lib/recipe.rb)
class Recipe
end

# Repository class
# (in lib/recipe_repository.rb)
class RecipeRepository
end
```

## 4. Implement the Model class

Define the attributes of your Model class. You can usually map the table columns to the attributes of the class, including primary and foreign keys.

```ruby
# EXAMPLE
# Table name: recipes

# Model class
# (in lib/recipe.rb)

class Recipe
  attr_accessor :id, :recipe_name, :cooking_time, :rating
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
# Table name: recipes

# Repository class
# (in lib/recipe_repository.rb)

class RecipeRepository

  # Selecting all records
  # No arguments
  def all
    # Executes the SQL query:
    # SELECT id, recipe_name, cooking_time, rating FROM recipes;

    # Returns an array of Student objects.
  end

  # Gets a single record by its ID
  # One argument: the id (number)
  def find(id)
    # Executes the SQL query:
    # SELECT id, recipe_name, cooking_time, rating FROM recipes WHERE id = $1;

    # Returns a single recipe object.
  end

end
```

## 6. Write Test Examples

Write Ruby code that defines the expected behaviour of the Repository class, following your design from the table written in step 5.

These examples will later be encoded as RSpec tests.

```ruby
# EXAMPLES

# 1
# Returns all recipes

repo = RecipeRepository.new
recipes = repo.all
expect(recipes.length) # =>  2


# 2 
# Correctly returns the first recipe
repo = RecipeRepository.new
recipes = repo.all
result = recipes.first
expect(result.id) # => 1
expect(result.recipe_name)# => 'Spaghetti Bolognese'
expect(result.cooking_time)# => 20
expect(result.rating)# => 4



# 3
# Returns the Spaghetti Bolognese recipe when specified

repo = RecipeRepository.new
result = repo.find(1)
expect(result.id) # => 1
expect(result.recipe_name)# => 'Spaghetti Bolognese'
expect(result.cooking_time)# => 20
expect(result.rating)# => 4

# 4
# Returns the Chilli recipe when specified

repo = RecipeRepository.new
result = repo.find(2)
expect(result.id) # => 2
expect(result.recipe_name)# => 'Chilli'
expect(result.cooking_time)# => 25
expect(result.rating)# => 5


# Add more examples for each method
```

Encode this example as a test.

## 7. Reload the SQL seeds before each test run

Running the SQL code present in the seed file will empty the table and re-insert the seed data.

This is so you get a fresh table contents every time you run the test suite.

```ruby
# EXAMPLE

# file: spec/recipe_repository_spec.rb

def reset_recipes_table
  seed_sql = File.read('spec/seeds_recipes.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'recipes_directory_test' })
  connection.exec(seed_sql)
end

before(:each) do 
    reset_recipes_table
end

  # (your tests will go here).

```

## 8. Test-drive and implement the Repository class behaviour

_After each test you write, follow the test-driving process of red, green, refactor to implement the behaviour._

