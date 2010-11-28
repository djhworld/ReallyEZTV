require 'lib/UtilityMethods'
require 'test/unit'

class TestUtilityMethods < MiniTest::Unit::TestCase
  def testConvertUrl
    url = "http://www.google.co.uk/q=<SEARCH_TERM>&v=<SEARCH_PARAM>"
    expectedUrl = "http://www.google.co.uk/q=GOOG&v=1234"
    replacers = {'<SEARCH_TERM>' => 'GOOG',
                '<SEARCH_PARAM>' => "1234"}
    result = UtilityMethods.convert_url(url, replacers)
    puts result
    assert_equal(result,expectedUrl)
  end
end
