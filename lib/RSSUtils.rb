require 'date'
require 'rss'
require 'pstore'
require './lib/UtilityMethods'
module RSSUtils
  STORAGE = "storage/feeds.pstore"
  class RSSCache
    include UtilityMethods
    attr_accessor :expires
    attr_accessor :data

    def initialize(expires, data)
      @expires, @data = expires, data
    end

    def expired?
      now = DateTime.now
      log("Checking if feed has expired")
      log("Current = #{formalDateStr(now)}")
      log("Expires = #{formalDateStr(@expires)}")
      return now > @expires
    end
  end

  class RSSManager
    include UtilityMethods
    def initialize
      @db = PStore.new(STORAGE)
    end
    
    def hasFeed(url)
      result = nil
      @db.transaction(true) do
        result = @db.root?(url)
      end
      return result
    end

    def feedExpired?(url)
      result = false
      @db.transaction(true) do
        result = @db[url].expired?
      end
      log("Local feed is still valid") if result == false
      return result
    end

    def getItem(url)
      item = nil
      @db.transaction(true) do
        item = @db[url]
      end
      return item
    end


    def getFeed(url)
      if hasFeed(url)
        log("Found feed in storage")
        if feedExpired?(url)
          log("Feed has expired, refreshing feed")
          setRSSForFeed(url)
        end
      else
        log("Feed is new to the system")
        @db.transaction do
          @db[url] = RSSCache.new(nil, nil)
          @db.commit
        end
        setRSSForFeed(url)
      end
      return getItem(url).data
    end

    def setRSSForFeed(url)
      begin
        latestFeed = getRSS(url)
        @db.transaction do
          @db[url].expires = (DateTime.now + 30.0/24.0/60.0)
          @db[url].data = latestFeed
          @db.commit
        end
      rescue Exception => message
        log("An error occurred attempting to retrieve feed from #{url} #{message}")
      end
    end
    
    def getRSS(url)
      log("Downloading RSS feed located at: #{url}")
      content = "" 
      begin
        open(url) do |s| content = s.read end
      rescue OpenURI::HTTPError
        raise "Network error"
      rescue Exception
        raise "Error"
      end
      return RSS::Parser.parse(content, false)
    end
  end
end
