require 'rss'
module RSSDownloader
  def getRSS(url)
    puts "Getting RSS feed located at: #{url}"
    content = "" 
    begin
      open(url) do |s| content = s.read end
    rescue OpenURI::HTTPError
      raise $!
    end
    rss = RSS::Parser.parse(content, false)
    return rss
  end
end
