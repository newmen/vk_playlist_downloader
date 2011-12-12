# coding: utf-8

require 'net/http'
require File.dirname(__FILE__) + '/file_saver'
require File.dirname(__FILE__) + '/session'

module VkPlaylist
  class Downloader
    def self.go(logger = STDOUT)
      @downloader = Downloader.new(logger)
      @downloader.save_tracks
    end

    #class << self
    #  protected :new
    #end

    def initialize(logger)
      @logger = logger
      @session = Session.instance
      @saver = FileSaver.new(@session.save_dir)
    end

    #private

    def save_tracks
      tracks = @session.tracks
      @logger << "Всего треков в плейлисте: #{tracks.size}\n"
      tracks.each do |track|
        @logger << "Загружаю #{track['artist']} - #{track['title']}... "
        local_file_path = download(track['url'])
        @saver.save_track(track['artist'], track['title'], local_file_path)
        @logger << "сохранён\n"
      end
    end

    private

    def download(url, tmp_dir = '/tmp')
      server_name = ''
      file_path = ''
      url.gsub(/^http:\/\/(\w+\.\w+\.\w{2,4})\/(.+)$/) do
        server_name = $1
        file_path = $2
      end

      file_name = tmp_dir + '/' + file_path.scan(/\w+\.\w+$/)[0]

      Net::HTTP.start(server_name) do |http|
        resp = http.get(file_path)
        open(file_name, "wb") do |file|
          file.write(resp.body)
         end
      end

      file_name
    end

  end
end
