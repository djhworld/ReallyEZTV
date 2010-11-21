require 'ReallyEZTV'
require 'test/unit'

class TestReallyEZTV < Test::Unit::TestCase
  attr_accessor :testObj

  def setup
    @testObj = ReallyEZTV.new
  end

  def testConstructor
    assert_not_nil(testObj)
  end

  def testGetShowNoArguments
    puts "Testing getShow with nil argument"
    assert_raise(ArgumentError) { testObj.getShow(nil) }
    
    puts "Testing getShow with empty show name argument"
    assert_raise(ArgumentError) { testObj.getShow("") }
  end
end

