require 'colorize'
require 'terminal-table'

module TimeOverlap
  class Presenter

    AM = "AM "
    PM = " PM"
    NOON = " 12:00 "
    SIX_AM = " 6:00 "
    SIX_PM = " 6:00 "

    EARLY_BIRD    = 'Early Bird'
    NIGHT_OWL     = 'Night Owl'

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

    def generate_output
      rows = []

      rows << [base_content]
      rows << [min_overlap_content]
      rows << [full_overlap_content]

      table = Terminal::Table.new :rows => rows
      puts table

      @data
    end

    private

    def duration
      @data[:duration]
    end

    def min_overlap
      @data[:min_overlap]
    end

    def my_time_zone
      @data[:my_time_zone]
    end

    def time_zone
      @data[:time_zone]
    end

    def original
      @data[:original]
    end

    def overlap_1
      @data[:overlap_1]
    end

    def overlap_2
      @data[:overlap_2]
    end

    def full_overlap
      @data[:full_overlap]
    end

    def base_content
      return unless original

      output = ""

      output << "* #{time_zone} (Base)\n"
      output << "#{formated_time(original[:start], true)} - #{formated_time(original[:end])}\n".green

      output << timeline(original[:start], original[:end])
    end

    def min_overlap_content
      return unless overlap_1

      output = ""

      output << "* #{my_time_zone} #{EARLY_BIRD} (#{min_overlap} hour(s) of overlap)\n"
      output << "#{formated_time(overlap_1[:start], true)} - #{formated_time(overlap_1[:end])}\n".green
      output << timeline(overlap_1[:start], overlap_1[:end])

      if overlap_2
        output << "\n"
        output << "* #{my_time_zone} #{NIGHT_OWL} (#{min_overlap} hour(s) of overlap)\n"
        output << "#{formated_time(overlap_2[:start], true)} - #{formated_time(overlap_2[:end])}\n".green
        output << timeline(overlap_2[:start], overlap_2[:end])
      end

      output
    end

    def full_overlap_content
      output = ""
      output << "* #{my_time_zone} (#{duration} hours of overlap)\n"
      output << "#{formated_time(full_overlap[:start], true)} - #{formated_time(full_overlap[:end])}\n".green
      output << timeline(full_overlap[:start], full_overlap[:end])
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

    def timeline(start_time, end_time)
      timeline = ""

      timeline << "    "

      (0..23).map do |hour|
        timeline << "%-4s" % hour
      end

      timeline << "\n"

      timeline << AM

      (0..23).map do |hour|
        if start_time.hour < end_time.hour
          if (start_time.hour..end_time.hour).cover?(hour)
            if end_time.hour != hour
              timeline << with_color(AVAILABLE_SLOT, hour)
            else
              timeline << with_color(EMPTY_SLOT, hour)
            end
          else
            timeline << with_color(EMPTY_SLOT, hour)
          end
        else
          if start_time.hour <= 12
            if (end_time.hour..start_time.hour).cover?(hour)
              if end_time.hour != hour
                timeline << with_color(AVAILABLE_SLOT, hour)
              else
                timeline << with_color(EMPTY_SLOT, hour)
              end
            else
              timeline << with_color(EMPTY_SLOT, hour)
            end
          else
            if (end_time.hour..start_time.hour).cover?(hour)
              if (start_time.hour == hour)
                timeline << with_color(AVAILABLE_SLOT, hour)
              else
                timeline << with_color(EMPTY_SLOT, hour)
              end
            else
              if end_time.hour != hour
                timeline << with_color(AVAILABLE_SLOT, hour)
              else
                timeline << with_color(EMPTY_SLOT, hour)
              end
            end
          end
        end
      end

      timeline << PM
      timeline << "\n"
      timeline << separator


      timeline
    end

    def with_color(string, hour)
      string.colorize(get_color(hour))
    end

    def separator
      " " * WIDTH
    end
  end
end
