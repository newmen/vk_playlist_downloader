# coding: utf-8

require 'fileutils'
require 'mp3info'

module VkPlaylist
  class FileSaver
    def initialize(save_dir)
      if !File.directory?(save_dir)
        STDERR << "Директория #{save_dir} не существует! Попытка создать директорию #{save_dir}...\n"
        begin
          FileUtils.mkdir_p(save_dir)
          STDERR << "#{save_dir} yспешно создана\n"
        rescue Exception
          STDERR << "#{save_dir} не может быть создана!\n"
          raise
        end
      end
      @save_dir = save_dir
    end

    def save_track(artist, title, file_path)
      rename_mp3tags(artist, title, file_path)

      curr_dir = artist_dir(artist)
      if !curr_dir
        curr_dir = "#@save_dir/#{artist}"
        begin
          Dir.mkdir(curr_dir)
        rescue SystemCallError
          STDERR << "Невозможно создать директорию #{curr_dir}\n"
          raise
        end
      end

      ext = File.extname(file_path)
      FileUtils.mv(file_path, "#{curr_dir}/#{artist} - #{title}#{ext}")
    end

    # проверяет что среди скачиваемых треков, некоторые уже сохранены
    def except_exist_tracks(tracks)
      exist_tracks = saved_tracks
      tracks.select do |track|
        !(exist_tracks.index([track['artist'], track['title']]))
      end
    end

    private

    def saved_tracks
      all_tracks = []
      artists.each do |artist|
        artist_regexp = artist.gsub(/([\.\?\*\[\]\{\}\(\)\\\/])/) { '\\' + $1 }
        inner_tracks = Dir.entries("#@save_dir/#{artist}") - ['.', '..']
        inner_tracks.each do |inner_track|
          title = inner_track.split(/#{artist_regexp} - /i)[1].split(/\.\w+$/)[0]
          all_tracks << [PlaylistString.new(artist), PlaylistString.new(title)]
        end
      end

      all_tracks
    end

    def artists
      (Dir.entries(@save_dir) - ['.', '..']).map { |artist| PlaylistString.new(artist) }
    end

    def artist_dir(artist)
      exist_artists = artists
      i = exist_artists.index(artist)
      i ? "#@save_dir/#{exist_artists[i]}" : nil
    end

    def self.rename_mp3tags(artist, title, file_path)
      Mp3Info.open(file_path) do |mp3|
        mp3.tag.artist = artist
        mp3.tag.title = title
      end
    end
  end

end
