class Users < ActiveRecord::Base
end

get '/users/:user_id' do  
	begin
		user = Users.find(params[:user_id], :select => "first_name, last_name, username, nick, id")
		user.to_json
	rescue
		halt 404, [:error => "User not found."].to_json
	end
end  

get '/users/?' do  
	users = Users.all(:select => "first_name, last_name, username, nick, id")
	users.to_json
end 
