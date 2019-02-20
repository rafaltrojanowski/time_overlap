require "time_overlap/version"
require "time_overlap/presenter"
require "time_overlap/cli"
require 'time'
require 'active_support/core_ext/time'

module TimeOverlap
  class Calculator

    # TODO: add meeting time to choose overlap 1 or overlap 2

    def initialize(from:, to:, time_zone:, my_time_zone:, min_overlap:)
      @current_year = Time.current.year
      @current_month = Time.current.month
      @current_day = Time.current.day
      @from = from
      @to = to
      @time_zone = time_zone
      @my_time_zone = my_time_zone
      @min_overlap = min_overlap

      @duration = (end_time - start_time).to_i / 60 / 60

      @data = {}
    end

    def self.count(*args)
      self.new(*args).execute
    end

    def execute
      offset = duration - min_overlap

      start_time_in_my_time_zone = start_time.in_time_zone(my_time_zone)
      end_time_in_my_time_zone = end_time.in_time_zone(my_time_zone)

      x_start_time = (start_time - offset * 60 * 60).in_time_zone(my_time_zone)
      x_end_time = (end_time - offset * 60 * 60).in_time_zone(my_time_zone)

      y_start_time = (end_time - min_overlap * 60 * 60).in_time_zone(my_time_zone)
      y_end_time = (y_start_time + duration * 60 * 60).in_time_zone(my_time_zone)

      @data = {
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

      check
      Presenter.new(@data).print

      @data
    end

    private

    attr_reader(
      :current_year,
      :current_month,
      :current_day,
      :from,
      :to,
      :time_zone,
      :my_time_zone,
      :min_overlap,
      :data,
      :duration
    )

    def start_time
      @start_time ||= Time.new(
        current_year,
        current_month,
        current_day,
        from,
        0,
        0,
        Time.zone_offset(time_zone)
      )
    end

    def end_time
      @end_time ||= Time.new(
        current_year,
        current_month,
        current_day,
        to,
        0,
        0,
        Time.zone_offset(time_zone)
      )
    end

    def check
      raise "Wrong Overlap 1" unless (data[:overlap_1][:end] - data[:overlap_1][:start]).to_i / 60 / 60 == duration
      raise "Wrong Overlap 2" unless (data[:overlap_2][:end] - data[:overlap_2][:start]).to_i / 60 / 60 == duration
    end
  end
end
