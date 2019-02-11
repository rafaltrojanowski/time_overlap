module TimeOverlap
  class Presenter

    def initialize(data)
      @data = data
    end

    def self.print(*args)
      new(*args).print
      @data
    end

    def print
      puts "Original"
      puts "#{@data[:original][:start]} - #{@data[:original][:end]}"
      separator

      puts "Full overlap"
      puts "#{@data[:full_overlap][:start]} - #{@data[:full_overlap][:end]}"
      separator

      puts "Overlap 1"
      puts "#{@data[:overlap_1][:start]} - #{@data[:overlap_2][:end]}"
      separator

      puts "Overlap 2"
      puts "#{@data[:overlap_1][:start]} - #{@data[:overlap_2][:end]}"
    end

    def separator
      puts "_" * 40
    end
  end
end
