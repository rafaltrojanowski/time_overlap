require 'colorize'

module TimeOverlap
  class Presenter

    AM = "AM ".freeze
    PM = " PM".freeze
    NOON = " 12:00 "
    SIX_AM = " 6:00 "
    SIX_PM = " 6:00 "

    BASE          = 'Base'
    EARLY_BIRD    = 'Early Bird'
    NIGHT_OWL     = 'Night Owl'
    FULL_OVERLAP  = 'Full Overlap'

    WIDTH         = 102

    AVAILABLE_SLOT = "|█| "
    EMPTY_SLOT = "[ ] "

    def initialize(data, format = '%T%:z')
      @data   = data
      @format = format
    end

    def self.generate_output(*args)
      new(*args).generate_output
    end

    def generate_output(show_header: true, show_base: true, show_min_overlap: true, show_full_overlap: true)
      duration    = @data[:duration]
      min_overlap = @data[:min_overlap]

      render_header if show_header
      render_base if show_base
      render_min_overlap if show_min_overlap
      render_full_overlap if show_full_overlap

      @data
    end

    private

    def render_header
      puts "-" * WIDTH
      puts "*** Your overlap hours in #{@data[:my_time_zone]} ***".center(WIDTH)
      puts "-" * WIDTH
    end

    def render_base
      puts "* #{BASE}"
      puts "#{formated_time(@data[:original][:start], true)} - #{formated_time(@data[:original][:end])}".green
      timeline(@data[:original][:start], @data[:original][:end])
    end

    def render_min_overlap
      puts "* #{EARLY_BIRD} (#{@data[:min_overlap]} hours of overlap)"
      puts "#{formated_time(@data[:overlap_1][:start], true)} - #{formated_time(@data[:overlap_1][:end])}".green
      timeline(@data[:overlap_1][:start], @data[:overlap_1][:end])

      if @data[:overlap_2]
        puts "* #{NIGHT_OWL} (#{@data[:min_overlap]} hours of overlap)"
        puts "#{formated_time(@data[:overlap_2][:start], true)} - #{formated_time(@data[:overlap_2][:end])}".green
        timeline(@data[:overlap_2][:start], @data[:overlap_2][:end])
      end
    end

    def render_full_overlap
      puts "* #{FULL_OVERLAP} (#{@data[:duration]} hours of overlap)"
      puts "#{formated_time(@data[:full_overlap][:start], true)} - #{formated_time(@data[:full_overlap][:end])}".green
      timeline(@data[:full_overlap][:start], @data[:full_overlap][:end])
    end


    def separator
      puts (" " * 102)
    end

    def formated_time(time, with_zone=false)
      format = "%T"
      format.prepend("TZ: %:z | ") if with_zone
      time.strftime(format)
    end

    def get_color(hour)
      case hour
        when 0..5
          then :blue
        when 6..7
          then :light_blue
        when 8..17
          then :light_yellow
        when 18..21
          then :light_blue
        when 22..23
          then :blue
      end

    end

    def with_color(string, hour)
      string.colorize(get_color(hour))
    end

    def timeline(start_time, end_time)
      print "    "
      (0..23).each do |hour|
        printf("%-4s", hour)
      end

      puts ""

      print AM

      (0..23).each do |hour|
        # print NOON if hour == 12
        # print SIX_AM if hour == 6
        # print SIX_PM if hour == 18

        if start_time.hour < end_time.hour
          if (start_time.hour..end_time.hour).cover?(hour)
            if end_time.hour != hour
              print with_color(AVAILABLE_SLOT, hour)
            else
              print with_color(EMPTY_SLOT, hour)
            end
          else
            print with_color(EMPTY_SLOT, hour)
          end
        else
          if start_time.hour <= 12
            if (end_time.hour..start_time.hour).cover?(hour)
              if end_time.hour != hour
                print with_color(AVAILABLE_SLOT, hour)
              else
                print with_color(EMPTY_SLOT, hour)
              end
            else
              print with_color(EMPTY_SLOT, hour)
            end
          else
            if (end_time.hour..start_time.hour).cover?(hour)
              if (start_time.hour == hour)
                print with_color(AVAILABLE_SLOT, hour)
              else
                print with_color(EMPTY_SLOT, hour)
              end
            else
              if end_time.hour != hour
                print with_color(AVAILABLE_SLOT, hour)
              else
                print with_color(EMPTY_SLOT, hour)
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
