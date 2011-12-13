# coding: utf-8

require 'yaml'

module VkPlaylist
  class Config
    APP_ID = 2715094
    CONFIG_FILE = 'config.yml'

    class_eval do
      [:app_id, :email, :password, :user_id, :save_dir].each do |m|
        define_method(m) do
          get(m.to_s)
        end
      end
    end

    class_eval do
      [:start, :stop].each do |m|
        define_method("#{m}_track") do
          border_track(m.to_s)
        end
      end
    end

    class_eval do
      [:only, :except].each do |m|
        define_method("#{m}_artists") do
          artists_option("#{m}_artists")
        end
      end
    end

    def initialize
      if File.exist?(CONFIG_FILE)
        yaml_config = YAML::load(File.open(CONFIG_FILE))
        @config = yaml_config['vk']
      else
        STDERR << "Конфигурационный файл #{CONFIG_FILE} не найден!\n"
        @config = {}
      end

      @config['app_id'] = APP_ID unless @config['app_id']
    end

    private

    def ask(thing)
      print "Введите #{thing}: "
      gets.chomp
    end

    def get(thing)
      if @config[thing] && @config[thing] != '?'
        @config[thing]
      else
        @config[thing] = ask(thing)
      end
    end

    def border_track(thing)
      return unless @config[thing]
      unless @config[thing]['artist'] && @config[thing]['title']
        STDERR << "Неправильно указан параметр #{thing} в конфигурационном файле. Нужно в нём указывать artist и title."
        exit!
      end
      @config[thing].each do |key, value|
        @config[thing][key] = PlaylistString.new(value)
      end
    end

    def artists_option(thing)
      artists = @config[thing]
      return nil if !artists || artists == '' || artists.empty?
      artists = [artists] if artists.is_a?(String)
      artists.map { |artist| PlaylistString.new(artist) }
    end
  end

end
