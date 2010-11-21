require 'ContentServer'

class ContentServerWrapper
  attr_reader :url, :content, :hostname, :port
  def initialize(content)
    @content = content
    @hostname = "localhost"
    @port = 4567
    @url = "http://#{self.hostname}:#{self.port}/"
  end

  def start
    ContentServer.run! :content => @content
  end
end
