require "thor"

module TimeOverlap
  class CLI < Thor

    desc 'count',
      "Example:

       `time_overlap count 8 16 +00:00 Bangkok 4`

       8       -> from (hour, integer)
       16      -> to (hour, integer)
       +00:00  -> base time zone
       Bangkok -> my/your time zone
       4       -> min_overlap (hours, integer)

       Tip:
       Run `time_overlap list` to get all available Time Zones
       You can also use +01:00 format
      "
    def count(from, to, base_time_zone, my_time_zone, min_overlap)
      TimeOverlap::Calculator.count(
        from: from.to_i,
        to: to.to_i,
        time_zone: base_time_zone,
        my_time_zone: my_time_zone,
        min_overlap: min_overlap.to_i
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
