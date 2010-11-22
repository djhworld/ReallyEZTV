module UtilityMethods
  public
  def convertURL(url, placeholder_to_replace, replace_text)
    #replace spaces with + symbols
    replace_text = replace_text.downcase.gsub(' ', '+')
    return url.gsub(placeholder_to_replace, replace_text)
  end

  module_function :convertURL
end
