require 'lib/RSSDownloader'
require 'lib/UtilityMethods'
require 'lib/ReallyEZTVShowProcessor'
require 'lib/exception/InvalidShowMetadataError'

class ReallyEZTV
  include RSSDownloader
  SHOW_PLACEHOLDER = "<~SHOWNAME~>"
  URL = "http://www.ezrss.it/search/index.php?show_name=#{SHOW_PLACEHOLDER}&show_name_exact=true&date=&quality=&release_group=&mode=rss"

  def initialize
    @rssProcessor = ReallyEZTVShowProcessor.new
  end

  def processShow(showName)
    raise ArgumentError if showName.nil? || showName.empty? 
    begin
      url = UtilityMethods.convert_url(URL,{SHOW_PLACEHOLDER => showName.downcase.gsub(' ','+') })
      rssData = getRSS(url)
    rescue 
      puts "Error attempting to retrieve content"
      raise StandardError
    end

    begin
      showDetails = @rssProcessor.getShow(rssData)
    rescue InvalidShowMetadataError
      puts "The RSS feed returned invalid or corrupted data"
    rescue ArgumentError
      puts "The RSSfeed that was passed into the system was nil"
    end

    return showDetails
  end
end

a = ReallyEZTV.new
a.processShow("30 Rock")
