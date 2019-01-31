RSpec.describe TimeOverlap do
  it "has a version number" do
    expect(TimeOverlap::VERSION).not_to be nil
  end

  it "EST, GMT-5 - Bangkok" do
    expect(TimeOverlap.count(
              from: 8,
              to: 18, # 6
              time_zone: 'EST', #"-05:00"
              my_time_zone: 'Bangkok',
              min_overlap: 4
            )
          ).to eq("OK")
  end

  it "GTM+0 - Bangkok" do
    expect(TimeOverlap.count(
              from: 8,
              to: 16, # 6
              # time_zone: '+00:00', # GMT+0
              time_zone: '+00:00',
              my_time_zone: 'Bangkok',
              min_overlap: 4
            )
          ).to eq("OK")
  end

  it "Bangkok - Warsaw" do
    expect(TimeOverlap.count(
              from: 9,
              to: 17,
              time_zone: '+07:00',
              my_time_zone: 'Warsaw',
              min_overlap: 4
            )
          ).to eq("OK")
  end
end
