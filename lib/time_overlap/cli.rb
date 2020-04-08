require "thor"

module TimeOverlap
  class CLI < Thor

    desc 'show',
      "Example:

       `time_overlap show 8 16 4 +00:00 Bangkok`

       8       -> from (hour, integer)
       16      -> to (hour, integer)
       4       -> min_overlap (hours, integer)
       +00:00  -> base time zone
       Bangkok -> my/your time zone

       Tip:
       Run `time_overlap list` to get all available Time Zones
       You can also use +01:00 format
      "
    def show(from, to, min_overlap, base_time_zone, my_time_zone)
      TimeOverlap::Calculator.show(
        from: from.to_i,
        to: to.to_i,
        min_overlap: min_overlap.to_i,
        time_zone: base_time_zone,
        my_time_zone: my_time_zone,
      )
    end

    desc 'list',
      "Example: `time_overlap list`"
    def list
      puts "List of available time zones:"
      puts "-----------------------------"
      puts ActiveSupport::TimeZone.all.map(&:name).join("\n")
    end
  end
end
