require 'active_support/all'

class PlaylistString < String
  def ==(other)
    self.mb_chars.downcase == other.mb_chars.downcase
  end
end