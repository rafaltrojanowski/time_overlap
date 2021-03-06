module TimeOverlap
  class Calculator

    def initialize(from:, to:, time_zone:, my_time_zone:, min_overlap:, expert: true, show_base: true)
      @current_year = Time.current.year
      @current_month = Time.current.month
      @current_day = Time.current.day

      @from = from
      @to = to
      @time_zone = time_zone
      @my_time_zone = my_time_zone
      @min_overlap = min_overlap
      @start_time = set_time(from)
      @end_time = set_time(to)
      @duration = (end_time - start_time).to_i / 60 / 60

      @expert = expert
      @show_base = show_base

      @data = {}
    end

    def self.show(*args)
      self.new(*args).execute
    end

    def execute
      @data = build_data

      if @data[:overlap_1][:start] == @data[:overlap_2][:start] &&
        @data[:overlap_1][:end] == @data[:overlap_2][:end]
          @data.delete(:overlap_2)
      end

      throw_errors!

      unless @expert
        @data.delete(:overlap_1)
        @data.delete(:overlap_2)
      end

      present_result
    end

    private

    attr_reader(
      :start_time,
      :end_time,
      :from,
      :to,
      :time_zone,
      :my_time_zone,
      :min_overlap,
      :data,
      :duration
    )

    def build_data
      offset = duration - min_overlap

      start_time_in_my_time_zone = start_time.in_time_zone(my_time_zone)
      end_time_in_my_time_zone = end_time.in_time_zone(my_time_zone)

      overlap_1_start_time = (start_time - offset * 60 * 60).in_time_zone(my_time_zone)
      overlap_1_end_time = (end_time - offset * 60 * 60).in_time_zone(my_time_zone)

      overlap_2_start_time = (end_time - min_overlap * 60 * 60).in_time_zone(my_time_zone)
      overlap_2_end_time = (overlap_2_start_time + duration * 60 * 60).in_time_zone(my_time_zone)

      {
        original: {
          start: start_time,
          end: end_time
        },
        full_overlap: {
          start: start_time_in_my_time_zone,
          end: end_time_in_my_time_zone
        },
        overlap_1: {
          start: overlap_1_start_time,
          end: overlap_1_end_time,
        },
        overlap_2: {
          start: overlap_2_start_time,
          end: overlap_2_end_time
        },
        duration: duration,
        min_overlap: min_overlap,
        time_zone: time_zone,
        my_time_zone: my_time_zone
      }
    end

    def present_result
      presenter_instance.generate_output
    end

    def presenter_instance
      @presenter_instance ||= Presenter.new(@data)
    end

    def set_time(hour)
      offset = Time.zone_offset(time_zone)

      if offset.nil?
        zone = ActiveSupport::TimeZone.new(time_zone)
        if zone.nil?
          raise "Invalid Timezone: #{time_zone}"
        end

        offset = zone.now.utc_offset
      end

      raise "Problem has occured during offset calculation for #{time_zone}" if offset.nil?

      Time.new(
        @current_year,
        @current_month,
        @current_day,
        hour,
        0,
        0,
        offset
      )
    end

    def throw_errors!
      raise "Min overlap must be lower that duration" if @min_overlap > @duration
      raise "Wrong Overlap 1" unless (data[:overlap_1][:end] - data[:overlap_1][:start]).to_i / 60 / 60 == duration

      if data[:overlap_2] && (data[:overlap_2][:end] - data[:overlap_2][:start]).to_i / 60 / 60 != duration
        raise "Wrong Overlap 2"
      end
    end
  end
end
