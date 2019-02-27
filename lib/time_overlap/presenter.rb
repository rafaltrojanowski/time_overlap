module TimeOverlap
  class Presenter

    AM = "AM ".freeze
    PM = " PM".freeze
    NOON = " 12:00 "
    SIX_AM = " 6:00 "
    SIX_PM = " 6:00 "

    AVAILABLE_SLOT = "[✓]"
    EMPTY_SLOT = "[ ]"

    def initialize(data, format = '%T%:z')
      @data   = data
      @format = format
    end

    def self.generate_output(*args)
      new(*args).generate_output
    end

    def generate_output
      puts "Original:"
      puts "#{formated_time(@data[:original][:start])} - #{formated_time(@data[:original][:end])}"
      separator
      puts "Full overlap:"
      puts "#{formated_time(@data[:full_overlap][:start])} - #{formated_time(@data[:full_overlap][:end])}"
      timeline(@data[:full_overlap][:start], @data[:full_overlap][:end])
      puts "Overlap 1:"
      puts "#{formated_time(@data[:overlap_1][:start])} - #{formated_time(@data[:overlap_1][:end])}"
      timeline(@data[:overlap_1][:start], @data[:overlap_1][:end])
      puts "Overlap 2:"
      puts "#{formated_time(@data[:overlap_2][:start])} - #{formated_time(@data[:overlap_2][:end])}"
      timeline(@data[:overlap_2][:start], @data[:overlap_2][:end])
      @data
    end

    private

    def separator
      puts "_" * 40
    end

    def formated_time(time)
      time.strftime("%T %:z")
    end

    def timeline(start_time, end_time)
      print AM


      (0..23).each do |hour|
        print NOON if hour == 12
        print SIX_AM if hour == 6
        print SIX_PM if hour == 18

        if start_time.hour < end_time.hour
          if (start_time.hour..end_time.hour).cover?(hour)
            if end_time.hour != hour
              print AVAILABLE_SLOT
            else
              print EMPTY_SLOT
            end
          else
            print EMPTY_SLOT
          end
        else
          if start_time.hour <= 12
            if (end_time.hour..start_time.hour).cover?(hour)
              if end_time.hour != hour
                print AVAILABLE_SLOT
              else
                print EMPTY_SLOT
              end
            else
              print EMPTY_SLOT
            end
          else
            if (end_time.hour..start_time.hour).cover?(hour)
              if (start_time.hour == hour)
                print AVAILABLE_SLOT
              else
                print EMPTY_SLOT
              end
            else
              if end_time.hour != hour
                print AVAILABLE_SLOT
              else
                print EMPTY_SLOT
              end
            end
          end
        end
      end
      print PM
      puts ""
      separator
    end
  end
end
