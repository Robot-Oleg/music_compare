# frozen_string_literal: true

RSpec.describe MusicCompare::Compare do
  let(:playlists) { %w[7r88KVwegNkxSl36zrhx30 1Iddrohefgh7PJgNjL9Kmp] }
  let(:compare) { described_class.new }

  before do
    allow(RSpotify).to receive(:authenticate)
  end

  after do
    FileUtils.rm_rf('playlists')
  end

  describe '#fetch_playlists!' do
    subject { compare.fetch_playlists!(playlists) }

    context 'with two playlists' do
      before do
        stub_request(:get, "https://api.spotify.com/v1/playlists/#{playlists[0]}/tracks?fields=items(track(name,artists(name))),next")
          .to_return(status: 200, body: File.new('spec/fixtures/playlists_matches2/playlist1.json'))
        stub_request(:get, "https://api.spotify.com/v1/playlists/#{playlists[1]}/tracks?fields=items(track(name,artists(name))),next")
          .to_return(status: 200, body: File.new('spec/fixtures/playlists_matches2/playlist2.json'))
      end

      it 'creates dir in gem directory' do
        subject
        expect(Dir.exist?('playlists')).to eq(true)
      end

      it 'creates file in gem directory from playlist 1' do
        subject
        expect(File.exist?("playlists/#{playlists[0]}.csv")).to eq(true)
      end

      it 'creates file in gem directory from playlist 2' do
        subject
        expect(File.exist?("playlists/#{playlists[1]}.csv")).to eq(true)
      end
    end
  end

  describe '#compare' do
    subject { compare.compare(playlists[0], playlists[1]) }

    context 'when 1 or more matches' do
      before do
        stub_request(:get, "https://api.spotify.com/v1/playlists/#{playlists[0]}/tracks?fields=items(track(name,artists(name))),next")
          .to_return(status: 200, body: File.new('spec/fixtures/playlists_matches2/playlist1.json'))
        stub_request(:get, "https://api.spotify.com/v1/playlists/#{playlists[1]}/tracks?fields=items(track(name,artists(name))),next")
          .to_return(status: 200, body: File.new('spec/fixtures/playlists_matches2/playlist2.json'))
      end

      it 'creates file with 1 match' do
        subject
        expect(CSV.read('matches.csv'))
          .to match(CSV.read('spec/fixtures/playlists_matches2/matches.csv'))
      end
    end

    context 'without matches' do
      before do
        stub_request(:get, "https://api.spotify.com/v1/playlists/#{playlists[0]}/tracks?fields=items(track(name,artists(name))),next")
          .to_return(status: 200, body: File.new('spec/fixtures/playlists_no_matches/playlist1.json'))
        stub_request(:get, "https://api.spotify.com/v1/playlists/#{playlists[1]}/tracks?fields=items(track(name,artists(name))),next")
          .to_return(status: 200, body: File.new('spec/fixtures/playlists_no_matches/playlist2.json'))
      end

      it 'creates file with no matches' do
        subject
        expect(File.zero?('matches.csv')).to eq(true)
      end
    end
  end
end
