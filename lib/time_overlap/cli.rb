require "thor"

module TimeOverlap
  class CLI < Thor

    desc 'show',
      "Usage:
      `time_overlap show start_hour end_hour min_overlap base_zone other_zone(s)`
      Example:
      `time_overlap show 8 16 4 Warsaw Bangkok`
      "
    def show(from, to, min_overlap, base_time_zone, *time_zones)
      time_zones.each do |zone_name|
        TimeOverlap::Calculator.show(
          from: from.to_i,
          to: to.to_i,
          min_overlap: min_overlap.to_i,
          time_zone: base_time_zone,
          my_time_zone: zone_name,
          team: false,
          base: false
        )
      end
    end

    desc 'team',
      "Usage:
      `time_overlap team start_hour end_hour base_zone team_zone(s)`
      Example:
      `time_overlap team 7 15 Warsaw Bangkok Chongqing Osaka Hobart Auckland Samoa`
      "
    def team(from, to, base_time_zone, *time_zones)
      time_zones.each_with_index do |zone_name, index|
        TimeOverlap::Calculator.show(
          from: from.to_i,
          to: to.to_i,
          min_overlap: 0,
          time_zone: base_time_zone,
          my_time_zone: zone_name,
          team: true,
          base: index == 0
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
