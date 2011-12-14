# coding: utf-8

require 'active_support/all'

module VkPlaylist
  class PlaylistString < String
    def ==(other)
      self.mb_chars.downcase == other.mb_chars.downcase
    end
  end
end