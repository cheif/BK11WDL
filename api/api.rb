require 'rubygems'  
require 'sinatra'  
require 'json'  
require 'active_record'

ActiveRecord::Base.establish_connection(  
	:adapter => "mysql2",
	:host => "localhost",
	:database => "bk11wdl"
)
ActiveRecord::Base.include_root_in_json = false

set :json_content_type, :js

require "./helpers"
require "./users"
require "./games"


