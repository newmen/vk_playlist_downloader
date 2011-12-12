require 'singleton'
require 'rubygems'
require 'vk-console'

require File.dirname(__FILE__) + '/config'

module VkPlaylist
  class Session
    include Singleton

    def initialize
      @config = Config.new
    end

    def tracks
      connect_to_vk
      @console.audio.get(:uid => @config.user_id)
    end

    def save_dir
      @config.save_dir
    end

    private

    def connect_to_vk
      @console = VK::Console.new(:app_id => @config.app_id,
                                 :email => @config.email,
                                 :password => @config.password,
                                 :scope => 'notify,audio')
    end
  end

end
