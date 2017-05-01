require 'rubygems'
require 'bundler'

Bundler.require

$LOAD_PATH.unshift(File.expand_path("app", __dir__))

require 'controllers/enigma.rb'

run EnigmaApp 