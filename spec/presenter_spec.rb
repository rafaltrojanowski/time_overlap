RSpec.describe TimeOverlap::Presenter do

  let(:data) {{
    :original=>{
      :start=>Time.parse('2019-02-09 10:00:00 -0700'),
      :end=>Time.parse('2019-02-09 18:00:00 -0700')
    },
    :full_overlap=>{
      :start=>Time.parse('Sun, 10 Feb 2019 00:00:00 +07 +07:00'),
      :end=>Time.parse('Sun, 10 Feb 2019 08:00:00 +07 +07:00')
    },
    :overlap_1=>{
      :start=>Time.parse('Sat, 09 Feb 2019 20:00:00 +07 +07:00'),
      :end=>Time.parse('Sun, 10 Feb 2019 04:00:00 +07 +07:00')
    },
    :overlap_2=>{
      :start=>Time.parse('Sun, 10 Feb 2019 04:00:00 +07 +07:00'),
      :end=>Time.parse('Sun, 10 Feb 2019 12:00:00 +07 +07:00')
    }
  }}

  it "returns data" do
    expect(described_class.new(data).generate_output).to eq(data)
  end

  it 'prints' do
    expect do
      described_class.new(data).generate_output
    end.to output(
<<~EOS.gsub!('\n', ' ')
Original:
10:00:00 - 18:00:00 (-07:00)
    0   1   2   3   4   5   6   7   8   9   10  11  12  13  14  15  16  17  18  19  20  21  22  23
AM [ ] [ ] [ ] [ ] [ ] [ ] [ ] [ ] [ ] [ ] |█| |█| |█| |█| |█| |█| |█| |█| [ ] [ ] [ ] [ ] [ ] [ ]  PM

Full overlap:
00:00:00 - 08:00:00 (+07:00)
    0   1   2   3   4   5   6   7   8   9   10  11  12  13  14  15  16  17  18  19  20  21  22  23
AM |█| |█| |█| |█| |█| |█| |█| |█| [ ] [ ] [ ] [ ] [ ] [ ] [ ] [ ] [ ] [ ] [ ] [ ] [ ] [ ] [ ] [ ]  PM

Overlap 1:
20:00:00 - 04:00:00 (+07:00)
    0   1   2   3   4   5   6   7   8   9   10  11  12  13  14  15  16  17  18  19  20  21  22  23
AM |█| |█| |█| |█| [ ] [ ] [ ] [ ] [ ] [ ] [ ] [ ] [ ] [ ] [ ] [ ] [ ] [ ] [ ] [ ] |█| |█| |█| |█|  PM

Overlap 2:
04:00:00 - 12:00:00 (+07:00)
    0   1   2   3   4   5   6   7   8   9   10  11  12  13  14  15  16  17  18  19  20  21  22  23
AM [ ] [ ] [ ] [ ] |█| |█| |█| |█| |█| |█| |█| |█| [ ] [ ] [ ] [ ] [ ] [ ] [ ] [ ] [ ] [ ] [ ] [ ]  PM
EOS
).to_stdout
  end
end
