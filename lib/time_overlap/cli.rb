require "thor"
require 'terminal-table'

module TimeOverlap
  class CLI < Thor

    desc 'expert',
      "Usage:
      `time_overlap expert start_hour end_hour min_overlap base_zone other_zone(s)`
      Example:
      `time_overlap expert 8 16 4 Warsaw Bangkok`
      "
    def expert(from, to, min_overlap, base_time_zone, *time_zones)
      rows = []
      header = ""
      header << "*** Your overlap hours in #{time_zones.join(", ")} to #{base_time_zone} (Expert view) ***\n".center(Presenter::WIDTH)
      rows << [header]
      puts Terminal::Table.new rows: rows, :style => { :width => Presenter::WIDTH + 4 }

      raise "Min overlap (#{min_overlap}) need to be Integer from range (1..24)" if min_overlap.to_i.zero?

      time_zones.each_with_index do |zone_name, index|
        TimeOverlap::Calculator.show(
          from: from.to_i,
          to: to.to_i,
          min_overlap: min_overlap.to_i,
          time_zone: base_time_zone,
          my_time_zone: zone_name,
          expert: true,
        )
      end
    end

    desc 'light',
      "Usage:
      `time_overlap light start_hour end_hour base_zone team_zone(s)`
      Example:
      `time_overlap light 7 15 Warsaw Bangkok Chongqing Osaka Hobart Auckland Samoa`
      "
    def light(from, to, base_time_zone, *time_zones)
      rows = []
      header = ""
      header << "*** Your overlap hours in #{time_zones.join(", ")} to #{base_time_zone} (Light view) ***".center(Presenter::WIDTH)
      rows << [header]
      puts Terminal::Table.new rows: rows, :style => { :width => Presenter::WIDTH + 4 }

      time_zones.each_with_index do |zone_name, index|
        TimeOverlap::Calculator.show(
          from: from.to_i,
          to: to.to_i,
          min_overlap: 0,
          time_zone: base_time_zone,
          my_time_zone: zone_name,
          expert: false,
        )
      end
    end

    desc 'list',
      "Example: `time_overlap list`"
    def list
      puts "List of available time zones:"
      puts "-----------------------------"
      ActiveSupport::TimeZone.all.map do |zone|
        puts "#{ActiveSupport::TimeZone[zone.name].formatted_offset}: #{zone.name}"
      end
      puts "-----------------------------"
      self.help
    end
  end
end
