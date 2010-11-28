require 'sinatra'
module ContentServer 
  class ContentServerWrapper
    def initialize(content)
      @content = content
    end

    def startServer
      ContentServerRunner.run! :content => @content
    end
  end

  class ContentServerRunner < Sinatra::Base
    get '/' do
      settings.content
    end
  end
end

