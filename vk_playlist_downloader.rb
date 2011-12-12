# coding: utf-8

LIB_PATH = File.dirname(__FILE__) + '/lib'
libs = Dir.entries(LIB_PATH) - ['.', '..']
libs.each do |lib_file|
  require LIB_PATH + '/' + lib_file
end

logger = STDOUT
begin
  VkPlaylist::Downloader.go(logger)
rescue Interrupt
  logger << "\nотменено\n"
end
