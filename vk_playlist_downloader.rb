# coding: utf-8

def ruby_is_1_9_2?
  RUBY_VERSION == '1.9.2'
end

unless ruby_is_1_9_2?
  STDERR << "Ваша версия Ruby не позволяет обрабатывать разный регистр русских букв. Обновите Ruby до версии 1.9.2\n"
  exit!
end

LIB_PATH = File.dirname(__FILE__) + '/lib'
libs = Dir.entries(LIB_PATH) - ['.', '..']
libs.each do |lib_file|
  require LIB_PATH + '/' + lib_file
end

config_file_name = 'config.yml'
logger = STDOUT
begin
  VkPlaylist::Downloader.go(config_file_name, logger)
rescue Interrupt
  logger << "\nотменено\n"
end
