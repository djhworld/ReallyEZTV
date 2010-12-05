require 'sinatra'
require 'erb'
require 'ReallyEZTV'
require 'json'

get '/' do
  erb :index
end

get '/get/:show' do
  begin
    result = getShow(params[:show])
    result.getSeasons.to_json
  rescue Exception => message 
    {:error => message}.to_json
  end
end

get '/go' do
  result = getShow(params[:show])
  erb :shows, :locals => { :shows => result.getSeasons }
end

helpers do
  def getShow(show)
    a = ReallyEZTV.new
    result = a.processShow(show)
  end
end
