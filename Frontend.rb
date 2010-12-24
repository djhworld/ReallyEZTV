require 'sinatra'
require 'erb'
require_relative 'ReallyEZTV.rb'
require 'json'
require './lib/UtilityMethods'
require './lib/Trie'

class ReallyEZTVFrontEnd < Sinatra::Base
  include UtilityMethods
  set :public, File.dirname(__FILE__) + '/public'
  set :trie, TrieDataStructure::Trie.new
  set :showList, [] 

  # Put the show names into a trie
  configure do
    File.open('storage/shows.txt','r') do |file| 
      while line = file.gets
        settings.trie.insert(line.chomp.strip)
        settings.showList.push(line.strip.chomp.downcase)
      end
    end
  end

  # This is the first page the user is presented
  get '/' do
    erb :index
  end

  # This is a private API that returns auto suggestions for an inputted string. 
  # The results are placed into JSON to accomodate a frontend plugin
  get '/auto' do
    results = { :query => params[:query], :suggestions => settings.trie.words(params[:query].downcase).slice(0..9) }.to_json
  end

  # API to get show data
  get '/get/:show' do
    begin
      show = params[:show]
      if(showExists?show)
        log("API requested show: #{show}") 
        result = getShow(show)
        result.getSeasons.to_json
      else
        raise "No show data found for show"
      end
    rescue Exception => message 
      {:error => message}.to_json
    end
  end

  # Checks whether a given show name is valid
  get '/exists/:show' do
    show = params[:show].strip
    if(showExists?show)
      log("Show #{show} exists in the system, moving on")
      redirect '/getShow/' + URI::escape(show)
    else
      erb "<br/><span class='error'>The show you have requested does not exist or is not supported.</span>"
    end
  end

  # Returns a page of formatted data 
  get '/getShow/:show' do
    show = params[:show].strip
    log("Requested show: #{show}") 
    begin
      result = getShow(show)
      erb :shows, :locals => { :shows => result.getSeasons }
    rescue Exception => message
      erb "<br/><span class='error'>The show you have requested is valid but the data returned has been corrupted or is in a format this system cannot understand </span>"
    end
  end

  helpers do
    def showExists?(show)
      log("Checking if show #{show} exists")
      return settings.showList.include?(show.downcase)
    end
      
    def getShow(show)
      a = ReallyEZTV.new
      result = a.processShow(show)
    end
  end
end

ReallyEZTVFrontEnd.run!
