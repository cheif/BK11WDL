class Games < ActiveRecord::Base
end

class Rounds < ActiveRecord::Base
end

class Throws < ActiveRecord::Base
end

post '/games/?' do
	begin
		game = JSON.parse(request.body.read)
		game_data = [:winner => game['winner'], :looser => game['looser'], :middle_winner => game['middle_winner'], :timestamp => Time.now.to_i]
	rescue
		halt 500, [:error => "I couldn't understand this request..."].to_json
	end

	# Validate winner
	begin
		winner = Users.find(game['winner'])
	rescue
		halt 500, [:error => "The winning user could not be found..."].to_json
	end

	# Validate looser
	begin
		looser = Users.find(game['looser'])
	rescue
		halt 500, [:error => "The loosing user could not be found..."].to_json
	end

	# Validate middler
	if game['middle_winner'] != game['winner'] && game['middle_winner'] != game['looser']
		halt 500, [:error => "The middle winner must be part of the game..."].to_json
	end

	Games.create(game_data) # Insert game
	game_id = Games.last.id # Get game_id

	begin
		game['rounds'].each{ |round|
			# Validate throwser
			if round['thrower'] != game['winner'] && round['thrower'] != game['looser']
				Games.find(game_id).destroy
				halt 500, [:error => "There is at least one thrower that is not part of the game..."].to_json
			end

			round_data = [:game_id => game_id, :thrower => round['thrower']]
			Rounds.create(round_data) # Insert round
			round_id = Rounds.last.id # Get round_id

			round['throws'].each{ |th|
				if validate_throw(th[0], th[1])
					Throws.create(:round_id => round_id, :value => th[0], :multiplier => th[1]) # Insert throw
				else
					Games.find(game_id).destroy
					Rounds.find_by_game_id(game_id).destroy
					halt 500, [:error => "The request contains a throw that is not possible to do, not even for Chuck Norris."].to_json
				end
			}
		}
		
		# Response
		Games.find(game_id).to_json
	rescue
		halt 500, [:error => "I couldn't understand this request..."].to_json
	end
end
