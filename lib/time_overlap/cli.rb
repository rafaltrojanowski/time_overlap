require "thor"

module TimeOverlap
  class CLI < Thor

    desc 'show',
      "Example:

       `time_overlap show 8 16 4 Warsaw Bangkok`

       8       - from (hour, Integer)
       16      - to   (hour, Integer)
       4       - min_overlap (hours, Integer)
       Warsaw  - base time zone *
       Bangkok - your time zone

       * To get all available time zones, run:
       `time_overlap list`

       Todo:
       Add support for formatted offset, ie:
       `time_overlap show 8 16 4 +02:00 +07:00`
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
