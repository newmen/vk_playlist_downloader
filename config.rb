# coding: utf-8

require 'rubygems'
require 'yaml'

module VkPlaylist
  class Config
    APP_ID = 2715094

    class_eval do
      [:app_id, :email, :password, :user_id, :save_dir].each do |m|
        define_method(m) do
          get(m.to_s)
        end
      end
    end

    def initialize
      if File.exist?(config_file = 'config.yml')
        yaml_config = YAML::load(File.open(config_file))
        @config = yaml_config['vk']
      else
        STDERR << "Конфигурационный файл #{config_file} не найден!\n"
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
  end

end
