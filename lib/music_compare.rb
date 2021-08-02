# frozen_string_literal: true

require_relative 'music_compare/version'
require 'rspotify'
require 'dotenv/load'
require 'csv'

module MusicCompare
  class Error < StandardError; end

  class Compare
    def initialize(client_id: ENV['CLIENT_ID'], client_secret: ENV['CLIENT_SECRET'])
      RSpotify.authenticate(client_id, client_secret)
    end

    def compare(playlist1, playlist2, dir_path: '')
      fetch_playlists!([playlist1, playlist2], dir_path: dir_path)
      file1 = CSV.read(playlist_path(playlist1, dir_path: @dir_path))
      file2 = CSV.read(playlist_path(playlist2, dir_path: @dir_path))
      matches_arr = file1 & file2
      CSV.open("#{dir_path}matches.csv", 'w') do |matches|
        matches_arr.each { |line| matches << line }
      end
      rm_dir(dir_path)
    end

    def fetch_playlists!(playlists, dir_path: '')
      create_dir(dir_path)
      playlists.each do |playlist|
        response = make_request(playlist_request(playlist))
        CSV.open(playlist_path(playlist, dir_path: @dir_path), 'a') do |playlist_file|
          loop do
            response['items'].each do |track|
              playlist_file << [
                track['track']['name'],
                track['track']['artists'].map { |artist| artist['name'] }.join(' ')
              ]
            end
            break if response['next'].nil?

            response = make_request(response['next'])
          end
        end
      end
    end

    private

    def make_request(request)
      RSpotify.resolve_auth_request(nil, request)
    rescue RestClient::BadRequest
      raise Error, 'invalid playlist id'
    end

    def rm_dir(dir_path)
      FileUtils.rm_rf("#{dir_path}playlists")
    end

    def create_dir(dir_path)
      process_dir_path!(dir_path)
      Dir.mkdir("#{dir_path}playlists")
    rescue Errno::ENOENT
      @dir_path = ''
      Dir.mkdir('playlists')
    end

    def playlist_path(playlist, dir_path: '')
      "#{dir_path}playlists/#{playlist}.csv"
    end

    def playlist_request(playlist)
      "playlists/#{playlist}/tracks?fields=items(track(name,artists(name))),next"
    end

    def process_dir_path!(dir_path)
      return if dir_path.empty?

      @dir_path = dir_path
      @dir_path << '/' unless dir_path.end_with?('/')
    end
  end
end
