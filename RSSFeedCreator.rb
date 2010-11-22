require 'rss/maker'
class RSSFeedCreator
  attr_reader :rssObj, :feedName, :feedLink, :feedDesc
  attr_reader :rssItems

  def initialize(feedName, feedLink, feedDesc)
    @feedName, @feedLink, @feedDesc = feedName, feedLink, feedDesc
    @rssItems = []
  end
  
  def addItem(itemTitle, itemDescription, itemPublishedDate, itemLink)
    rssItem = { :title => itemTitle, :description => itemDescription, :publishedDate => itemPublishedDate, :link => itemLink }
    rssItems.push(rssItem)
  end

  def createFeed
    @rssObj = RSS::Maker.make("2.0") do |r|
      r.channel.title = @feedName
      r.channel.link = @feedLink
      r.channel.description = @feedDesc
      r.items.do_sort = true

      @rssItems.each do |item|

        i = r.items.new_item
        i.title = item[:title]
        i.description = item[:description]
        i.link = item[:link]
        i.date = item[:publishedDate]
      end
    end
    return @rssObj
  end

end
