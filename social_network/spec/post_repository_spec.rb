require 'post_repository' 

RSpec.describe PostRepository do
    def reset_posts_table
        seed_sql = File.read('spec/seeds_posts.sql')
        connection = PG.connect({ host: '127.0.0.1', dbname: 'social_network_test' })
        connection.exec(seed_sql)
    end
  
    before(:each) do 
      reset_posts_table
    end

    it 'gets all posts' do
        repo = PostRepository.new
        posts = repo.all # returns all results
        post = posts.first 
        expect(posts.length).to eq 2
        expect(post.id).to eq 1
        expect(post.title).to eq 'title1'
        expect(post.content).to eq ' some content for you'
        expect(post.views).to eq 244
        expect(post.user_id).to eq 1
    end


    it "find a specified post" do 
        repo = PostRepository.new
        post = repo.find(1)
        expect(post.id).to eq 1
        expect(post.title).to eq 'title1'
        expect(post.content).to eq ' some content for you'
        expect(post.views).to eq 244
        expect(post.user_id).to eq 1
    end


    it 'creates a new post' do
        repo = PostRepository.new
        post = Post.new
        post.title = 'New Title'
        post.content = 'Content for my post'
        post.views = 1
        post.user_id = 1
        repo.create(post)
        posts = repo.all
        result = posts.last
        expect(result.id).to eq 3
        expect(result.title).to eq 'New Title'
        expect(result.content).to eq 'Content for my post'
        expect(result.views).to eq 1
        expect(result.user_id).to eq 1
    end


    it 'can verify a new post' do
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
    end

    it 'delete a specified post' do
        repo = PostRepository.new
        repo.delete(1)
        posts = repo.all
        result = posts.first
        expect(posts.length).to eq  1
        expect(result.id).to eq  2
        expect(result.title).to eq 'title2'
        expect(result.content).to eq  'April 2022 content'
    end


    it 'updates a record' do
        repo = PostRepository.new
        post = repo.find(2)
        post.title = 'Read this!'
        post.content = 'New content coming'
        repo.update(post)
        result = repo.find(2)
        expect(result.id).to eq 2
        expect(result.title).to eq 'Read this!'
        expect(result.content).to eq 'New content coming'
        expect(result.views).to eq 364
        expect(result.user_id).to eq 2
    end
end