require 'lib/RSSUtils'
require 'lib/UtilityMethods'
require 'lib/ReallyEZTVShowProcessor'
require 'lib/exception/InvalidShowMetadataError'

class ReallyEZTV
  include RSSUtils
  SHOW_PLACEHOLDER = "<~SHOWNAME~>"
  URL = "http://www.ezrss.it/search/index.php?show_name=#{SHOW_PLACEHOLDER}&show_name_exact=true&date=&quality=&release_group=&mode=rss"

  def initialize
    @rssManager = RSSUtils::RSSManager.new
    @rssProcessor = ReallyEZTVShowProcessor.new
  end

  def processShow(showName)
    raise ArgumentError if showName.nil? || showName.empty? 
    begin
      url = UtilityMethods.convert_url(URL,{SHOW_PLACEHOLDER => showName.downcase.gsub(' ','+') })
      rssData = @rssManager.getFeed(url)
    rescue Exception => message
      raise message
    end


    begin
      showDetails = @rssProcessor.getShow(rssData)
    rescue InvalidShowMetadataError
      raise InvalidShowMetadataError,"The RSS feed returned invalid or corrupted data"
    rescue ArgumentError
      raise ArgumentError, "The RSSfeed that was passed into the system was nil"
    end

    return showDetails
  end
end
