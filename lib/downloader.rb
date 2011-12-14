# coding: utf-8

require 'open-uri'

module VkPlaylist
  class Downloader
    def self.go(config_file_name = 'config.yml', logger = STDOUT)
      @downloader = Downloader.new(config_file_name, logger)
      @downloader.save_tracks
    end

    def initialize(config_file_name, logger)
      @config = Config.new(config_file_name)
      @logger = logger
      @saver = FileSaver.new(@config.save_dir)
      @session = Session.new(@config)
    end

    def save_tracks
      @logger << "Всего треков в плейлисте: #{@session.total_tracks}\n"

      tracks = @session.tracks
      # проверяем что среди скачиваемых треков, некоторые уже сохранены
      saved_tracks = @saver.saved_tracks
      tracks = tracks.select do |track|
        !(saved_tracks.index([track['artist'], track['title']]))
      end

      @logger << "Будет загружено #{tracks.size} треков\n"

      tracks.each do |track|
        @logger << %|Загружаю "#{track['artist']} - #{track['title']}"... |
        local_file_path = download(track['url'])
        @saver.save_track(track['artist'], track['title'], local_file_path)
        @logger << "сохранён\n"
      end
    end

    private

    def download(url, tmp_dir = '/tmp')
      file_name = tmp_dir + '/' + url.scan(/\w+\.\w+$/)[0]

      track_file = open(file_name, "wb")
      track_file.write(open(url).read)
      track_file.close

      file_name
    end

  end
end
