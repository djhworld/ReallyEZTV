require 'rubygems'
require 'sinatra'

class ContentServer < Sinatra::Base
  get '/' do
    settings.content
  end
end

#ContentServer.run! :content => "Hello world"
  
