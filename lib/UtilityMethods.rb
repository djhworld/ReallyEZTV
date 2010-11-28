module UtilityMethods
  def UtilityMethods.convert_url(url, replacements) 
    result = nil
    replacements.each do |replace_key, replace_val|
      result = url.gsub(replace_key, replace_val)
    end
    return result 
  end
end
