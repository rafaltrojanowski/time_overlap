RSpec.describe TimeOverlap::Calculator do

  before { Timecop.freeze(Time.local(2019, 02, 9, 10, 0, 0)) }
  after  { Timecop.return }

  it "has a version number" do
    expect(TimeOverlap::VERSION).not_to be nil
  end

  it "does not raise an error for all listed time zones" do
    time_zones = ActiveSupport::TimeZone.all.map(&:name)
    time_zones.each do |zone_name|
      expect(described_class.show(
                from: 10,
                to: 18,
                min_overlap: 4,
                time_zone: zone_name,
                my_time_zone: zone_name,
              )
            ).to_not be_empty
    end
  end

  it "EST (-7:00) and Bangkok(+7:00)" do
    expect(described_class.show(
              from: 10,
              to: 18,
              min_overlap: 4,
              time_zone: '-07:00',
              my_time_zone: 'Bangkok'
            )
          ).to eq({
            :full_overlap => {
              :end =>   Time.parse('2019-02-10 08:00:00.000000000 +0700'),
              :start => Time.parse('2019-02-10 00:00:00.000000000 +0700')
            },
            :original => {
              :end =>   Time.parse('2019-02-09 18:00:00.000000000 -0700'),
              :start => Time.parse('2019-02-09 10:00:00.000000000 -0700')
            },
            :overlap_1 => {
              :end =>   Time.parse('2019-02-10 04:00:00.000000000 +0700'),
              :start => Time.parse('2019-02-09 20:00:00.000000000 +0700')
            },
            :overlap_2 => {
              :end =>   Time.parse('2019-02-10 12:00:00.000000000 +0700'),
              :start => Time.parse('2019-02-10 04:00:00.000000000 +0700')
            },
            :duration => 8,
            :min_overlap => 4,
            :my_time_zone => "Bangkok"
          })
  end

  it "EST (GMT-5) and Bangkok(+7:00)" do
    expect(described_class.show(
              from: 8,
              to: 18,
              time_zone: 'EST', #"-05:00"
              my_time_zone: 'Bangkok',
              min_overlap: 4
            )
          ).to eq({
            :full_overlap => {
              :end =>   Time.parse('2019-02-10 06:00:00.000000000 +0700'),
              :start => Time.parse('2019-02-09 20:00:00.000000000 +0700')
            },
            :original => {
              :end =>   Time.parse('2019-02-09 18:00:00.000000000 -0500'),
              :start => Time.parse('2019-02-09 08:00:00.000000000 -0500')
            },
            :overlap_1 => {
              :end =>   Time.parse('2019-02-10 00:00:00.000000000 +0700'),
              :start => Time.parse('2019-02-09 14:00:00.000000000 +0700')
            },
            :overlap_2 => {
              :end =>   Time.parse('2019-02-10 12:00:00.000000000 +0700'),
              :start => Time.parse('2019-02-10 02:00:00.000000000 +0700')
            },
            :duration => 10,
            :min_overlap => 4,
            :my_time_zone => "Bangkok"
          })
  end

  it "GTM+0 and Bangkok (+7:00)" do
    expect(described_class.show(
              from: 8,
              to: 16,
              time_zone: '+00:00',
              my_time_zone: 'Bangkok',
              min_overlap: 4
            )
          ).to eq({
            :full_overlap => {
              :end =>   Time.parse('2019-02-09 23:00:00.000000000 +0700'),
              :start => Time.parse('2019-02-09 15:00:00.000000000 +0700')
            },
            :original => {
              :end =>   Time.parse('2019-02-09 16:00:00.000000000 +0000'),
              :start => Time.parse('2019-02-09 08:00:00.000000000 +0000')
            },
            :overlap_1 => {
              :end =>   Time.parse('2019-02-09 19:00:00.000000000 +0700'),
              :start => Time.parse('2019-02-09 11:00:00.000000000 +0700')
            },
            :overlap_2 => {
              :end =>   Time.parse('2019-02-10 03:00:00.000000000 +0700'),
              :start => Time.parse('2019-02-09 19:00:00.000000000 +0700')
            },
            :duration => 8,
            :min_overlap => 4,
            :my_time_zone => "Bangkok"
          })
  end

  it "Bangkok (+7:00) - Warsaw (+1:00)" do
    expect(described_class.show(
              from: 9,
              to: 17,
              time_zone: '+07:00',
              my_time_zone: 'Warsaw',
              min_overlap: 4
            )
          ).to eq({
            :full_overlap => {
              :end =>   Time.parse('2019-02-09 11:00:00.000000000 +0100'),
              :start => Time.parse('2019-02-09 03:00:00.000000000 +0100')
            },
            :original => {
              :end =>   Time.parse('2019-02-09 17:00:00.000000000 +0700'),
              :start => Time.parse('2019-02-09 09:00:00.000000000 +0700')
            },
            :overlap_1 => {
              :end =>   Time.parse('2019-02-09 07:00:00.000000000 +0100'),
              :start => Time.parse('2019-02-08 23:00:00.000000000 +0100')
            },
            :overlap_2 => {
              :end =>   Time.parse('2019-02-09 15:00:00.000000000 +0100'),
              :start => Time.parse('2019-02-09 07:00:00.000000000 +0100')
            },
            :duration => 8,
            :min_overlap => 4,
            :my_time_zone => "Warsaw"
          })
  end

  it "Warsaw (+01:00) - Bangkok (+07:00)" do
    expect(described_class.show(
              from: 9,
              to: 17,
              time_zone: '+01:00',
              my_time_zone: 'Bangkok',
              min_overlap: 2
            )
          ).to eq({
            :full_overlap => {
              :end =>   Time.parse('2019-02-09 23:00:00.000000000 +0700'),
              :start => Time.parse('2019-02-09 15:00:00.000000000 +0700')
            },
            :original => {
              :end =>   Time.parse('2019-02-09 17:00:00.000000000 +0100'),
              :start => Time.parse('2019-02-09 09:00:00.000000000 +0100')
            },
            :overlap_1 => {
              :end =>   Time.parse('2019-02-09 17:00:00.000000000 +0700'),
              :start => Time.parse('2019-02-09 09:00:00.000000000 +0700')
            },
            :overlap_2 => {
              :end =>   Time.parse('2019-02-10 05:00:00.000000000 +0700'),
              :start => Time.parse('2019-02-09 21:00:00.000000000 +0700')
            },
            :duration => 8,
            :min_overlap => 2,
            :my_time_zone => "Bangkok",
          })
  end

  it "1 hour call within 2 hours time span" do
    expect(described_class.show(
              from: 17,
              to: 19,
              time_zone: '+02:00',
              my_time_zone: 'Bangkok',
              min_overlap: 1
            )
          ).to eq({
            :full_overlap => {
              :end =>   Time.parse('2019-02-10 00:00:00.000000000 +0700'),
              :start => Time.parse('2019-02-09 22:00:00.000000000 +0700')
            },
            :original => {
              :end =>   Time.parse('2019-02-09 19:00:00.000000000 +0200'),
              :start => Time.parse('2019-02-09 17:00:00.000000000 +0200')
            },
            :overlap_1 => {
              :end =>   Time.parse('2019-02-09 23:00:00.000000000 +0700'),
              :start => Time.parse('2019-02-09 21:00:00.000000000 +0700')
            },
            :overlap_2 => {
              :end =>   Time.parse('2019-02-10 01:00:00.000000000 +0700'),
              :start => Time.parse('2019-02-09 23:00:00.000000000 +0700')
            },
            :duration => 2,
            :min_overlap => 1,
            :my_time_zone => "Bangkok"
          })
  end

  it "when min overlap is greater than duration" do
    expect {
      described_class.show(
        from: 17,
        to: 19,
        time_zone: '+02:00',
        my_time_zone: 'Bangkok',
        min_overlap: 4
      )
    }.to raise_error('Min overlap must be lower that duration')
  end

  it "only displays overlap 1 when overlap 2 is the same" do
    # https://gist.github.com/lucascaton/bec400d18f7dcda61275
    expect(
      described_class.show(
        from: 9,
        to: 17,
        time_zone: '-11:00',
        my_time_zone: 'Tokelau Is.', # +13:00
        min_overlap: 8
      )).to eq({
        :full_overlap => {
          :end =>   Time.parse('2019-02-10 17:00:00.000000000 +1300'),
          :start => Time.parse('2019-02-10 09:00:00.000000000 +1300')
        },
        :original => {
          :end =>   Time.parse('2019-02-09 17:00:00.000000000 -1100'),
          :start => Time.parse('2019-02-09 09:00:00.000000000 -1100')
        },
        :overlap_1 => {
          :end =>   Time.parse('2019-02-10 17:00:00.000000000 +1300'),
          :start => Time.parse('2019-02-10 09:00:00.000000000 +1300')
        },
        :duration => 8,
        :min_overlap => 8,
        :my_time_zone => "Tokelau Is."
      })
  end

  context 'when time zones (names) passed in' do
    it 'calculates offset and returns data' do
      expect(described_class.show(
                from: 10,
                to: 18,
                time_zone: 'Budapest',
                my_time_zone: 'Bangkok',
                min_overlap: 4
            )).to eq({
              :full_overlap => {
                :end=>    Time.parse('2019-02-10 00:00:00.000000000 +0700'),
                :start=>  Time.parse('2019-02-09 16:00:00.000000000 +0700')
              },
              :original => {
                :end=>    Time.parse('2019-02-09 18:00:00.000000000 +0100'),
                :start=>  Time.parse('2019-02-09 10:00:00.000000000 +0100')
              },
              :overlap_1 => {
                :end=>    Time.parse('2019-02-09 20:00:00.000000000 +0700'),
                :start=>  Time.parse('2019-02-09 12:00:00.000000000 +0700')
              },
              :overlap_2 => {
                :end=>    Time.parse('2019-02-10 04:00:00.000000000 +0700'),
                :start=>  Time.parse('2019-02-09 20:00:00.000000000 +0700')
              },
              :duration => 8,
              :min_overlap => 4,
              :my_time_zone => "Bangkok"
            })
    end
  end
end
