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

	# ------------------------

	class Card
		
		attr_accessor(:id, :value, :author_id, :author, :tags, :created, :updated)

		def initialize (hash)
			@value = hash["value"]
			@author_id = hash["author_id"]
			@author = hash["author"]
			@tags = "{#{hash['tags'].split(' ').join(',')}}"
			@created = Time.new
			@updated = Time.new
		end
		
		def save
			value = @value
			author = @author_id
      tags = @tags
			query = "INSERT INTO cards (value, author_id, tags, created_at, last_updated) VALUES ($1, $2, $3, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)"
      $db.exec_params(query, [value, author, tags])
		end

		def self.all 
			$db.exec("SELECT cards.*, users.username AS author FROM cards JOIN users ON users.id = cards.author_id;").map do |row|
				Card.new(row)
			end
		end

		def parse(string)
			no_l = string.delete"{{"
			no_r = no_l.delete"}}"
			no_r.split(",")
		end


		def self.find_all_by_author(username)
			query = "SELECT cards.*, users.username FROM cards JOIN users ON users.id = cards.author_id WHERE users.username=$1;"
			$db.exec_params(query, [username]).map do |row|
				Card.new(row)
			end
		end
	
		def self.find_card_by_id(username)
			query = "SELECT cards.*, users.username FROM cards JOIN users ON users.id = cards.author_id WHERE users.username=$1;"
			$db.exec_params(query, [username]).map do |row|
				Card.new(row)
			end
		end

	end #card-class


end #warhol-module
