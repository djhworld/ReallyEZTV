require 'lib/RSSDownloader'

class ReallyEZTV
  include RSSDownloader
  attr_reader :show_name, :show_url

  def initialize(show_name, show_url)
    @show_name = show_name
    @show_url = convertURL(show_url, '<|SHOW|>', show_name)
  end

  def getShow
    rssData = getRSS(@show_url)
    showData = {}
    rssData.items.each { |rssItem|
      metadata = Hash[*rssItem.description.split(';').collect { |a| a.split(":").flatten.collect { |i| i.strip } }.flatten]     
      actualShowName = metadata["Show Name"]
      seasonNumber = metadata["Season"]
      episodeNumber = metadata["Episode"]
      publishedDate = rssItem.pubDate
      torrentLink = rssItem.link

      showInformation = { :episode => episodeNumber, :datePublished => publishedDate, :link => torrentLink }

      if(showData.key?actualShowName) == false
        showData[actualShowName] = {}
      end
      
      if(showData[actualShowName].key?:seasons) == false
        showData[actualShowName][:seasons] = {}
      end

      if(showData[actualShowName].key?seasonNumber) == false
        showData[actualShowName][seasonNumber] = {}
      end

      if(showData[actualShowName][seasonNumber].key?episodeNumber) == false
        showData[actualShowName][seasonNumber][episodeNumber] = showInformation
      end
    }
    p showData[showData.keys.first].keys
    return showData 
  end

  private
  def convertURL(url, placeholder_to_replace, replace_text)
    #replace spaces with + symbols
    replace_text = replace_text.downcase.gsub(' ', '+')
    return url.gsub(placeholder_to_replace, replace_text)
  end
end


a = ReallyEZTV.new('30 Rock','http://www.ezrss.it/search/index.php?show_name=<|SHOW|>&show_name_exact=true&mode=rss')
a.getShow
