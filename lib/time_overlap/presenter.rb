module TimeOverlap
  class Presenter

    def initialize(data, format = '%T%:z')
      @data   = data
      @format = format
    end

    def self.print(*args)
      new(*args).print
    end

    def print
      puts "Original"
      puts "#{formated_time(@data[:original][:start])} - #{formated_time(@data[:original][:end])}"
      separator

      puts "Full overlap"
      puts "#{formated_time(@data[:full_overlap][:start])} - #{formated_time(@data[:full_overlap][:end])}"
      separator

      puts "Overlap 1"
      puts "#{formated_time(@data[:overlap_1][:start])} - #{formated_time(@data[:overlap_2][:end])}"
      separator

      puts "Overlap 2"
      puts "#{formated_time(@data[:overlap_1][:start])} - #{formated_time(@data[:overlap_2][:end])}"

      @data
    end

    private

    def separator
      puts "_" * 40
    end

    def formated_time(time)
      time#.strftime("%T %:z")
    end
  end
end
