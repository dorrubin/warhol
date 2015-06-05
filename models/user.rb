module Warhol
	
	class User

		attr_accessor(:id, :username, :email, :name, :phone, :password)

		def initialize(hash)
			@id = hash["id"]
			@username = hash["username"]
			@email = hash["email"]
			@name = hash["name"]
			@phone = hash["phone"]
			@password = hash["password"]
		end

		def save
			name = @name
      email = @email
      username = @username
      phone = @phone
      password = @password
			query = "INSERT INTO users (name, email, username, phone, password) VALUES ($1, $2, $3, $4, $5) RETURNING id"
      $db.exec_params(query, [name, email, username, phone, password])
		end

		def self.find(id)
			User.new($db.exec_params("SELECT * FROM users WHERE id=$1", [id]).first)
		end

	end #user-class

end #warhol-module
