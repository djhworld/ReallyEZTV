module UtilityMethods
  def UtilityMethods.convert_url(url, replacements) 
    result = nil
    replacements.each do |replace_key, replace_val|
      result = url.gsub(replace_key, replace_val)
    end
    return result 
  end

  def formalDateStr(date)
    return date.strftime("%d %m %Y %H:%M:%S")
  end

  def log(message)
    puts "#{self.class} => #{message}"
  end
end
