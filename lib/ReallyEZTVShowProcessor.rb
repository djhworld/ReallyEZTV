require 'ShowData.rb'
require 'lib/exception/InvalidShowMetadataError'

class ReallyEZTVShowProcessor
  SHOW_NAME = "Show Name"
  SEASON = "Season"
  EPISODE = "Episode"

  def getShow(rssData)
    raise ArgumentError if rssData.nil?
    showData = nil
    rssData.items.each { |rssItem|
      begin
        metadata = Hash[*rssItem.description.split(';').collect { |a| a.split(":").flatten.collect { |i| i.strip } }.flatten]     
      rescue ArgumentError
        raise InvalidShowMetadataError
      end

      puts "Item metadata processed successfully. Validating metadata"

      if(!validateMetaData(metadata))
        raise InvalidShowMetadataError
      end

      puts "Item metadata was valid. Ingesting new data"

      if(showData.nil?)
        showData = ShowData.new(metadata[SHOW_NAME])
      end
      showData.ingest(metadata[SEASON].to_i, metadata[EPISODE].to_i, rssItem.pubDate, rssItem.link)  
    }
    return showData 
  end

  def validateMetaData(metadata)

    if(metadata.nil?)
      return false
    end

    if(metadata.key?SHOW_NAME == false)
      return false
    elsif(metadata[SHOW_NAME].nil?)
      return false
    end

    if(metadata.key?SEASON == false)
      return false
    elsif(metadata[SEASON].nil?)
      return false
    end

    if(metadata.key?EPISODE == false)
      return false
    elsif(metadata[EPISODE].nil?)
      return false
    end

    return true
  end


end
