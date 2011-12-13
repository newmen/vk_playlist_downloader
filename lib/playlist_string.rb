# coding: utf-8

require 'active_support/all'

class PlaylistString < String
  def ==(other)
    begin
      self.mb_chars.downcase == other.mb_chars.downcase
    rescue SystemStackError
      STDERR << "Ваша версия Ruby не позволяет обрабатывать разный регистр русских букв. Обновите Ruby до версии не ниже 1.9.2\n"
      exit!
    end
  end
end
