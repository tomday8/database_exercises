require 'recipe_repository'

RSpec.describe RecipeRepository do
    def reset_recipes_table
        seed_sql = File.read('spec/seeds_recipes.sql')
        connection = PG.connect({ host: '127.0.0.1', dbname: 'recipes_directory_test' })
        connection.exec(seed_sql)
    end
      
    before(:each) do 
          reset_recipes_table
    end

    it 'returns all recipes' do
        repo = RecipeRepository.new
        recipes = repo.all
        expect(recipes.length).to eq 2 
    end

    it 'correctly returns the first recipe' do
        repo = RecipeRepository.new
        recipes = repo.all
        result = recipes.first
        expect(result.id).to eq '1' 
        expect(result.recipe_name).to eq 'Spaghetti Bolognese'
        expect(result.cooking_time).to eq '20'
        expect(result.rating).to eq '4'
    end

    it 'returns the Spaghetti Bolognese recipe when specified' do
        repo = RecipeRepository.new
        result = repo.find(1)
        expect(result.id).to eq '1'
        expect(result.recipe_name).to eq 'Spaghetti Bolognese'
        expect(result.cooking_time).to eq '20'
        expect(result.rating).to eq '4'
    end

    it 'returns the Chilli recipe when specified' do
        repo = RecipeRepository.new
        result = repo.find(2)
        expect(result.id).to eq '2'
        expect(result.recipe_name).to eq 'Chilli'
        expect(result.cooking_time).to eq '25'
        expect(result.rating).to eq '5'
    end


end