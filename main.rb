require 'pry'
require 'sinatra'
require 'sinatra/reloader' if development?
require 'active_support/all'
require 'pg'

# creates hash of values for genre picker
before do
  sql = "select distinct genre from videos"
  @nav_rows = run_sql(sql)
end

#------ GET ALL DOGS OF A PARTICULAR BREED
get '/videos/:genre' do
  sql = "select * from videos where genre = '#{params['genre']}'"
  @rows = run_sql(sql)
  erb :videos
end


# EDIT FUNCTIONS

get '/videos/:video_id/edit' do
  sql = "select * from videos where id = #{params['video_id']}"
  rows = run_sql(sql)
  @row = rows.first
  erb :new
end

post '/videos/:video_id' do
  sql = "update videos set title = '#{params['title']}', description = '#{params['description']}', url = '#{params['url']}' where id = #{params['video_id']}"
  run_sql(sql)
  redirect to('/videos')
end

# DELETE VIDEO

post '/videos/:video_id/delete' do
  sql = "delete from videos where id = #{params['video_id']} "
  run_sql(sql)
  redirect to('/videos')
end

# INSERT FORM DATA INTO DATABASE
post '/create' do

  @title = params[:title]
  @description = params[:description]
  @url = params[:url]
  @genre = params[:genre]

  sql = "insert into videos (title, description, url, genre) values ('#{@title}', '#{@description}', '#{@url}', '#{@genre}')"
  run_sql(sql)

  redirect to('/videos')

end

# BASIC PAGE GETS
get '/' do
  erb :home
end

# send video data to populate videos page
get '/videos' do
  sql = "select * from videos"
  @rows = run_sql(sql)
  erb :videos
end

get '/new' do
  erb :new
end

# generic run sql code command

def run_sql(sql)
  conn = PG.connect(:dbname =>'memetube', :host => 'localhost')
  result = conn.exec(sql)
  conn.close

  result
end