require_relative './user'

class UserRepository

   
    def all
      sql = 'SELECT id, email, username FROM users;'
      result = DatabaseConnection.exec_params(sql, [])
      # Returns an array of user objects.
      users = []

      repo = UserRepository.new

      result.each do |record|
      user = User.new
      user.id = record['id'].to_i # => '1'
      user.email = record['email'] # => 'example@email.com'
      user.username = record['username']
      users << user
      end

      return users
    end

    def find(id)
      
      sql =  'SELECT id, email, username FROM users WHERE id = $1;'
      params = [id]
      result = DatabaseConnection.exec_params(sql, params)
      record = result[0]

      user = User.new
      user.id = record['id'].to_i
      user.email = record['email'] # => 'example@email.com'
      user.username = record['username'] 
      
      return user
    end
  

    def create(user) 
        sql = 'INSERT INTO users (email, username) VALUES($1, $2);'
        params = [user.email, user.username]
        DatabaseConnection.exec_params(sql, params)
    end
  
     
    def delete(id)
        sql = 'DELETE FROM users WHERE id = $1;'
        params = [id]
        DatabaseConnection.exec_params(sql, params)
    end
  
    def update(user)
        sql = 'UPDATE users SET email = $1, username = $2 WHERE id = $3;'
        params = [user.email, user.username, user.id]
        DatabaseConnection.exec_params(sql, params)   
    end
    
  end