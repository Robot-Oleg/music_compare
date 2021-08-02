# MusicCompare

With this gem you can:
- fetch public playlists from spotify into .csv files
- compare two .csv playlist files for matches

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'music_compare'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install music_compare

## Usage
First you need to specify 'client_id' and 'client_secret', you can do this in .env file or when you create an object:
```ruby
compare = MusicCompare::Compare.new('client_id', 'client_secret')
```
### Fetch playlists
To fetch playlists from spotify you need playlists id's, for example:
- https://open.spotify.com/playlist/<mark>1Iddrohefgh7PJgNjL9Kmp</mark>
- https://open.spotify.com/playlist/<mark>1Iddrohefgh7PJgNjL9Kmp</mark>?si=0898cf7f075443e9&nd=1

```ruby
playlists = ['1Iddrohefgh7PJgNjL9Kmp', '7r88KVwegNkxSl36zrhx30']
compare.fetch_playlists!(playlists)
```
also you can specify directory path, where you want to store you playlists:

```ruby
compare.fetch_playlists!(playlists, dir_path: 'home/username/')
```
### Compare playlists
```ruby
compare.compare('1Iddrohefgh7PJgNjL9Kmp', '7r88KVwegNkxSl36zrhx30')
```
or with directory path:
```ruby
compare.compare('1Iddrohefgh7PJgNjL9Kmp', '7r88KVwegNkxSl36zrhx30', dir_path: 'home/username')
```
