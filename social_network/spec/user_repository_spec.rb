require 'user_repository'

RSpec.describe UserRepository do

    def reset_users_table
        seed_sql = File.read('spec/seeds_users.sql')
        connection = PG.connect({ host: '127.0.0.1', dbname: 'social_network_test' })
        connection.exec(seed_sql)
    end
  
    before(:each) do 
      reset_users_table
    end
  
    it 'Returns all users' do
        repo = UserRepository.new
        users = repo.all
        user = users.first 
        expect(users.length).to eq 2
        expect(user.id).to eq 1
        expect(user.email).to eq 'example@email.com'
        expect(user.username).to eq 'test_user'
    end

    it "find a specified user" do
        repo = UserRepository.new
        user = repo.find(1)
        expect(user.id).to eq 1
        expect(user.email).to eq 'example@email.com'
        expect(user.username).to eq 'test_user'
    end 

    it "creates a new user" do
        repo = UserRepository.new
        user = User.new
        user.email = 'username95@test.com'
        user.username = 'username95'
        repo.create(user)
        users = repo.all
        result = users.last
        expect(result.id).to eq 3
        expect(result.email).to eq 'username95@test.com'
        expect(result.username).to eq 'username95'
    end 


    it "can verify a new user" do
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
    end

    it "delete a specified user" do
        repo = UserRepository.new
        repo.delete(1)
        users = repo.all
        result = users.first
        expect(users.length).to eq 1
        expect(result.id).to eq 2
        expect(result.email).to eq 'test@online.com'
        expect(result.username).to eq 'sample_account'
    end


    it 'updates a record' do
        repo = UserRepository.new
        user = repo.find(2)
        user.email = 'test@new-online.com'
        user.username = 'new_test_user'
        repo.update(user)
        result = repo.find(2)
        expect(result.id).to eq 2
        expect(result.email).to eq 'test@new-online.com'
        expect(result.username).to eq 'new_test_user'
    end


end