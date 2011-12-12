# coding: utf-8

require 'fileutils'

module VkPlaylist
  class FileSaver
    def initialize(save_dir)
      if !Dir.exist?(save_dir)
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

    def saved_tracks
      all_tracks = []
      artists = Dir.entries(@save_dir) - ['.', '..']
      artists.each do |artist|
        inner_tracks = Dir.entries("#@save_dir/#{artist}") - ['.', '..']
        inner_tracks.each do |inner_track|
          title = inner_track.split("#{artist} - ")[1].split(/\.\w+$/)[0]
          all_tracks << [artist, title]
        end
      end

      all_tracks
    end

    def save_track(artist, title, file_path)
      artist_dir = "#@save_dir/#{artist}"
      if !Dir.exist?(artist_dir)
        begin
          Dir.mkdir(artist_dir)
        rescue SystemCallError
          STDERR << "Невозможно создать директорию #{artist_dir}\n"
          raise
        end
      end

      ext = File.extname(file_path)
      FileUtils.mv(file_path, "#{artist_dir}/#{artist} - #{title}#{ext}")
    end
  end

end
