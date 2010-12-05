class ShowData
  attr_accessor :showName
  attr_reader :showData

  def initialize(showName)
    @showName = showName
    @showData = { showName => {:seasons => {} } }
  end

  def ingest(seasonNumber, episodeNumber, publishedDate, torrentLink)    
    if(@showData[@showName][:seasons].key?seasonNumber) == false
      @showData[@showName][:seasons][seasonNumber] = {}
    end
  
    if(@showData[@showName][:seasons][seasonNumber].key?:episodes) == false
      @showData[@showName][:seasons][seasonNumber][:episodes] = {}
    end

    if(@showData[@showName][:seasons][seasonNumber][:episodes].key?episodeNumber) == false
      episode = { :torrentLink => torrentLink, :publishedDate => publishedDate }
      @showData[@showName][:seasons][seasonNumber][:episodes][episodeNumber] = episode 
    end
  end

  def getSeasons
    return (@showData.nil?) ? nil :  @showData[@showName][:seasons]
  end

  def getSeason(seasonNumber)
    season = getSeasons()[seasonNumber][:episodes]
    return (season.nil?) ? nil : season
  end

  def getEpisode(seasonNumber, episodeNumber)
    season = getSeason(seasonNumber)
    if(season.nil?)
      return nil
    end
    episode = season[:episodes][episodeNumber]
    return (episode.nil?) ? nil : episode
  end

  def print
    puts "Show: #{self.showName}"
    puts "Seasons: #{self.getSeasons.keys.count}"
    puts
    self.getSeasons.keys.sort.each { |item| 
      puts "--> Season #{item}"
      puts "----> Episodes: #{getSeason(item).keys.count}" 
    }
  end

end
