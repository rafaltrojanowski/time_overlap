require "time_overlap/version"
require "time_overlap/presenter"
require "time_overlap/cli"
require 'time'
require 'active_support/core_ext/time'

module TimeOverlap

  # TODO: add meeting time to choose overlap 1 or overlap 2

  def self.count(from:, to:, time_zone:, my_time_zone:, min_overlap:)
    current_year = Time.current.year
    current_month = Time.current.month
    current_day = Time.current.day

    start_time = Time.new(
      current_year,
      current_month,
      current_day,
      from,
      0,
      0,
      Time.zone_offset(time_zone)
    )

    end_time = Time.new(
      current_year,
      current_month,
      current_day,
      to,
      0,
      0,
      Time.zone_offset(time_zone)
    )

    duration = (end_time - start_time).to_i / 60 / 60
    offset = duration - min_overlap

    start_time_in_my_time_zone = start_time.in_time_zone(my_time_zone)
    end_time_in_my_time_zone = end_time.in_time_zone(my_time_zone)

    x_start_time = (start_time - min_overlap * 60 * 60).in_time_zone(my_time_zone)
    x_end_time = (end_time - offset * 60 * 60).in_time_zone(my_time_zone)

    y_start_time = (end_time - min_overlap * 60 * 60).in_time_zone(my_time_zone)
    y_end_time = (y_start_time + duration * 60 * 60).in_time_zone(my_time_zone)

    data = {
      original: {
        start: start_time,
        end: end_time
      },
      full_overlap: {
        start: start_time_in_my_time_zone,
        end: end_time_in_my_time_zone
      },
      overlap_1: {
        start: x_start_time,
        end: x_end_time
      },
      overlap_2: {
        start: y_start_time,
        end: y_end_time
      }
    }

    Presenter.print(data)
  end
end
