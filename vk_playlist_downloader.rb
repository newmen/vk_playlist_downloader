# coding: utf-8

unless RUBY_VERSION == '1.9.2'
  STDERR << "Ваша версия Ruby не позволяет обрабатывать разный регистр русских букв и устанавливать русские теги в utf-8. Используйте Ruby 1.9.2\n"
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
