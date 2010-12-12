module TrieDataStructure
  class Node
    attr_accessor :content, :marker, :child, :word

    def initialize(c)
      @child = []
      @marker = false
      @content = c
      @word = nil
    end

    def subNode(c)
      if(!child.nil? && !child.empty?)
        for x in child
          if(x.content.eql?(c))
            return x
          end
        end
      end
      return nil
    end
  end

  class Trie
    attr_reader :root

    def initialize
      @root = TrieDataStructure::Node.new(" ")
      @lettersInsertedCount = 0
      @stringLengthCount = 0
      @wordCount = 0
      @wordList = []
    end

    def insert(string)
      str = string.dup.downcase
      current = @root

      if (str.length == 0)
        current.marker = true 
        current.word = string.intern
      end

      #str.gsub!(' ','')
      strArray = str.split('')
      strArray.each_index do |i|
        child = current.subNode(strArray.fetch(i))
        if(!child.nil?)
          current = child
        else
          @lettersInsertedCount += 1
          current.child << TrieDataStructure::Node.new(strArray.fetch(i))
          current = current.subNode(strArray.fetch(i))
        end
         if (i==str.length-1)
           current.marker = true
           current.word = string.intern
         end
      end
      @wordCount += 1
      @stringLengthCount += string.length 

    end
    
    def size
      perc = "%.2f" % ((@lettersInsertedCount.to_f/@stringLengthCount.to_f)*100.0)
      puts "Words inserted   : #{@wordCount}"
      puts "Letters inserted : #{@lettersInsertedCount}/#{@stringLengthCount} (#{perc} %)"
    end
    
    def subSection(str)
      current = @root
      while !current.nil? do
        #str.gsub!(' ','')
        strArray = str.split('')
        strArray.each_index do |i|
          if(current.subNode(strArray.fetch(i)).nil?)
            return nil;
          else
            current = current.subNode(strArray.fetch(i))
          end
        end
        return current
      end
    end


    def words(str)
      sub = self.subSection(str)
      result = nil
      
      if(!sub.nil?)
        @wordList << sub.word.to_s if(sub.marker)
        traverse(sub)
      end
      result = @wordList.dup
      @wordList = []
      return result
    end

    def traverse(trie)
      trie.child.each do |a|
        if(!a.marker)
          traverse(a)
        elsif(a.child.empty?)
          @wordList.push(a.word.to_s) 
        else
          @wordList.push(a.word.to_s) 
          traverse(a)
        end
      end 
    end
  end
end
