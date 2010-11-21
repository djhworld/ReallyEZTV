require 'rss'
module RSSDownloader
  def getRSS(url)
    puts "Getting RSS feed located at: #{url}"
    content = "" 
    open(url) do |s| content = s.read end
    rss = RSS::Parser.parse(content, false)
    return rss
  end
end
