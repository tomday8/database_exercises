require "post"

class PostRepository

    def all
      sql = 'SELECT id, title, content, views, user_id FROM posts;'
      result = DatabaseConnection.exec_params(sql, [])

      posts = []

      result.each do |record|
        posts << create_post_object(record)
      end
      
      return posts
  
    end
  
    def find(id)
        sql = 'SELECT id, title, content, views, user_id FROM posts WHERE id = $1;'
        params = [id]
        result = DatabaseConnection.exec_params(sql, params)
   
        record = result[0]
       
        return create_post_object(record)
    end

    def create(post) 
          sql = 'INSERT INTO posts (title, content, views, user_id) VALUES($1, $2, $3, $4);'
          params = [post.title, post.content, post.views, post.user_id]
          DatabaseConnection.exec_params(sql, params)
    end
  
    
    def delete(id)
        sql = 'DELETE FROM posts WHERE id = $1;'
        params = [id]
        DatabaseConnection.exec_params(sql, params)
    end
  
    def update(post)
        sql = 'UPDATE posts SET title = $1, content = $2, views = $3, user_id = $4 WHERE id = $5;'
        params = [post.title, post.content, post.views, post.user_id, post.id]
        DatabaseConnection.exec_params(sql, params)
    end

    private

    def create_post_object(record)
        post = Post.new
        post.id = record['id'].to_i
        post.title = record['title']
        post.content = record['content']
        post.views = record['views'].to_i
        post.user_id = record['user_id'].to_i
        return post
    end
  end