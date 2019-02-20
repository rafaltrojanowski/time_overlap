module TimeOverlap
  class Presenter

    def initialize(data, format = '%T%:z')
      @data   = data
      @format = format
    end

    def self.generate_output(*args)
      new(*args).generate_output
    end

    def show_it(s, e)
      print"|AM| "
      # puts (s.hour..e.hour).inspect

      (0..24).each do |hour|
        print ' |NOON| ' if hour == 12

        if s.hour < e.hour
          if (s.hour..e.hour).cover?(hour)
            if e.hour != hour
              print "[✓]"
            else
              print "[ ]"
            end
          else
            print "[ ]"
          end
        else
          if s.hour <= 12
            if (e.hour..s.hour).cover?(hour)
              if e.hour != hour
                print "[✓]"
              else
                print "[ ]"
              end
            else
              print "[ ]"
            end
          else
            if (e.hour..s.hour).cover?(hour)
              print "[ ]"
            else
              if e.hour != hour
                print "[✓]"
              else
                print "[ ]"
              end
            end
          end
        end

      end
      print " |PM|"
      puts ""
      separator
    end

    def generate_output
      puts "Original:"
      puts "#{formated_time(@data[:original][:start])} - #{formated_time(@data[:original][:end])}"

      separator

      puts "Full overlap:"
      puts "#{formated_time(@data[:full_overlap][:start])} - #{formated_time(@data[:full_overlap][:end])}"

      show_it(@data[:full_overlap][:start], @data[:full_overlap][:end])

      puts "Overlap 1:"
      puts "#{formated_time(@data[:overlap_1][:start])} - #{formated_time(@data[:overlap_1][:end])}"

      show_it(@data[:overlap_1][:start], @data[:overlap_1][:end])

      puts "Overlap 2:"
      puts "#{formated_time(@data[:overlap_2][:start])} - #{formated_time(@data[:overlap_2][:end])}"

      show_it(@data[:overlap_2][:start], @data[:overlap_2][:end])

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
