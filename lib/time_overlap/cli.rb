require "thor"

module TimeOverlap
  class CLI < Thor

    desc 'count',
      "
        Display possible options based on passed args
        Example: time_overlap count 10 18 +1:00 Bangkok 4'
      "
    def count(from, to, time_zone, my_time_zone, min_overlap)
      TimeOverlap.count(
        from: from.to_i,
        to: to.to_i,
        time_zone: time_zone,
        my_time_zone: my_time_zone,
        min_overlap: min_overlap.to_i
      )
    end
  end
end
