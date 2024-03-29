# coding: utf-8

require 'vk-console'

module VkPlaylist
  class Session
    def self.rebuild(string)
      new_str = string.strip
      new_str.gsub!('&amp;', '&')
      new_str.gsub!('&quot;', '"')
      new_str.gsub!('&#39;', "'")
      new_str.gsub!('&#33;', "!")
      new_str.gsub!(/[\\\/]/, '')
      new_str.squeeze!(' ')
      PlaylistString.new(new_str)
    end

    attr_reader :total_tracks

    def initialize(config)
      @config = config
      begin
        console = VK::Console.new(app_id: @config.app_id,
                                  email: @config.email,
                                  password: @config.password,
                                  settings: 'notify,audio')
      rescue
        STDERR << "Произошла ошибка при подключению к ВКонтакту\n"
        exit!
      end

      @all_tracks = console.audio.get(uid: @config.user_id).map do |track|
        track['artist'] = self.class.rebuild(track['artist'])
        track['title'] = self.class.rebuild(track['title'])
        track
      end
      @total_tracks = @all_tracks.size
    end

    def tracks
      @all_tracks = filter_start_stop(@all_tracks)
      @all_tracks = filter_artists(@all_tracks)
    end

    private

    def filter_start_stop(tracks)
      start = @config.start_track
      stop = @config.stop_track

      if start || stop
        filtered_tracks = []

        target_begin = !start
        tracks.each do |track|
          filtered_tracks << track if target_begin

          if (!target_begin && start && start['artist'] == track['artist'] && start['title'] == track['title'])
            target_begin = true
            redo
          end

          if (target_begin && stop && stop['artist'] == track['artist'] && stop['title'] == track['title'])
            #target_begin = false
            break
          end
        end

        tracks = filtered_tracks
      end

      tracks
    end

    def filter_artists(tracks)
      tracks = tracks.select do |track|
        @config.only_artists.include?(track['artist'])
      end if @config.only_artists

      tracks = tracks.select do |track|
        !@config.except_artists.include?(track['artist'])
      end if @config.except_artists

      tracks
    end

  end
end
