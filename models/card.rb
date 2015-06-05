module Warhol	
	class Card
		
		attr_accessor(:id, :value, :author_id, :author, :tags, :created, :updated)

		def initialize (hash)
			@id = hash["id"]
			@value = hash["value"]
			@author_id = hash["author_id"]
			@author = hash["author"]
			@tags = "{#{hash['tags'].split(' ').join(',')}}"
			@created = hash["created_at"]
			@updated = hash["last_updated"]
		end
		
		def save
			value = @value
			author = @author_id
      tags = @tags
			query = "INSERT INTO cards (value, author_id, tags, created_at, last_updated) VALUES ($1, $2, $3, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP) RETURNING id"
      $db.exec_params(query, [value, author, tags])
		end

		def self.all 
			$db.exec("SELECT cards.*, users.username AS author FROM cards JOIN users ON users.id = cards.author_id;").map do |row|
				Card.new(row)
			end
		end


		def self.find_all_by_author(username)
			query = "SELECT cards.*, users.username AS author FROM cards JOIN users ON users.id = cards.author_id WHERE users.username=$1;"
			$db.exec_params(query, [username]).map do |row|
				Card.new(row)
			end
		end
		
		def self.find_by_id(id)
			query = "SELECT cards.*, users.username FROM cards JOIN users ON users.id = cards.author_id WHERE cards.id=$1;"
			$db.exec_params(query, [id]).map do |row|
				Card.new(row)
			end
		end
		
		def edit (params)
			value = params["value"]
			tags = params["tags"]
			id = params["id"]
			query = "UPDATE cards SET value = $1, tags = $2, last_updated = CURRENT_TIMESTAMP
        WHERE id = #{id}"
			$db.exec_params(query, [value, tags]).first
		end

		def remove_db
			query = "DELETE FROM cards WHERE id = $1"
			$db.exec_params(query, [id]).first
		end


		#This doesnt work -- to parse string tag
		def parse(string)
			no_l = string.delete"{{"
			no_r = no_l.delete"}}"
			no_r.split(",")
		end

	end #card-class
end #module
