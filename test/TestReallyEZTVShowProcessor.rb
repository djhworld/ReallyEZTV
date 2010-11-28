require 'lib/ReallyEZTVShowProcessor'
require 'lib/exception/InvalidShowMetadataError'
require 'ContentServer'
require 'RSSFeedCreator'
require 'test/unit'

class TestReallyEZTVShowProcessor < MiniTest::Unit::TestCase
  include ContentServer
  def setup
    @testObj = ReallyEZTVShowProcessor.new
    @rssFeed = RSSFeedCreator.new("Test EZTV Feed", "http://www.test.com", "A feed")
  end

  def tearDown
    @testObj = nil
    @rssFeed = nil
  end

  
  def testConstructor
    refute_nil(@testObj)
  end
  
  def testGetShowNoArguments
    puts "Testing getShow with nil argument"
    assert_raises(ArgumentError) { @testObj.getShow(nil) }
  end

  def testGetShowWorks
    @rssFeed.addItem("The Episode", "Show Name: TestShow; Season: 1; Episode: 4", Time.now, "Show")

    show = @testObj.getShow(@rssFeed.createFeed)
    refute_nil(show)
    assert_equal(1,show.getSeasons.count)
    assert_equal(1,show.getSeason(1).count)
    assert(show.getSeason(1).key?4)
    refute(show.getSeason(1).key?1)
  end

  def testGetShowFailsOnInvalidFeed
    puts "IN TEST GET SHOW INVALID METADATA FEED"
    @rssFeed.addItem("The Episode", "Show Nam", Time.now, "Show")

    assert_raises(InvalidShowMetadataError) {
      show = @testObj.getShow(@rssFeed.createFeed)
    }
  end

  def testGetShowFailsOnInvalidFeedInItems
    puts "IN TEST GET SHOW VALID METADATA"
    @rssFeed.addItem("The Episode", " ; ; ; ", Time.now, "Show")

    assert_raises(InvalidShowMetadataError) {
      show = @testObj.getShow(@rssFeed.createFeed)
    }

    @rssFeed = RSSFeedCreator.new("a","a","a")

    @rssFeed.addItem("The Episode", "Show Name: abc; Season: 1; Ep:1;", Time.now, "Show")
    assert_raises(InvalidShowMetadataError) {
      show = @testObj.getShow(@rssFeed.createFeed)
    }

  end


  def testValidateMetadata
    puts "Testing empty show name"
    metadata = { "Show Name" => nil, "Season" => "1", "Episode" => "1" }
    refute(@testObj.validateMetaData(metadata))
    
    puts "Testing invalid show name key"
    metadata = { "ShowName" => "1", "Season" => "1", "Episode" => "1" }
    refute(@testObj.validateMetaData(metadata))

    puts "Testing empty season"
    metadata = { "Show Name" => "1", "Season" => nil, "Episode" => "1" }
    refute(@testObj.validateMetaData(metadata))
   
    puts "Testing invalid season key"
    metadata = { "ShowName" => "1", "Ssn" => "1", "Episode" => "1" }
    refute(@testObj.validateMetaData(metadata))

    puts "Testing empty episode"
    metadata = { "Show Name" => "1", "Season" => "1", "Episode" => nil }
    refute(@testObj.validateMetaData(metadata))
    
    puts "Testing invalid episode key"
    metadata = { "Show Name" => "1", "Season" => "1", "Epi" => "1" }
    refute(@testObj.validateMetaData(metadata))

    puts "Testing valid metadata"
    metadata = { "Show Name" => "1", "Season" => "1", "Episode" => "1" }
    assert(@testObj.validateMetaData(metadata))
  end

end

