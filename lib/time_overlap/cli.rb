require "thor"

module TimeOverlap
  class CLI < Thor

    desc 'count',
      "Example: `time_overlap count 8 16 +00:00 Bangkok 4`'
       8       -> from (hour, integer) \n
       16      -> to (hour, integer)
       +00:00  -> target time zone
       Bangkok -> my time zone
       4       -> min_overlap (hours, integer)
      "
    def count(from, to, time_zone, my_time_zone, min_overlap)
      TimeOverlap::Calculator.count(
        from: from.to_i,
        to: to.to_i,
        time_zone: time_zone,
        my_time_zone: my_time_zone,
        min_overlap: min_overlap.to_i
      )
    end
  end
end
