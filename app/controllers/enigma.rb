require 'sinatra/base'
require_relative '../models/enigma_message'

class EnigmaApp < Sinatra::Base
  set :root, File.expand_path("..", __dir__)

  get '/' do
    erb :index
  end


  post '/enigma_encrypt' do
    e = Enigma.new
    encryption = e.encrypt("#{params[:message]}", params[:key].to_i)
    @message = encryption[:message]
    @key = encryption[:key]
    erb :display
  end

  post '/enigma_decrypt' do
    e = Enigma.new
    decryption = e.decrypt("#{params[:message]}", params[:key].to_i)
    @message = decryption[:message]
    erb :display
  end
  
  post '/enigma_crack' do
    e = Enigma.new
    decryption = e.crack("#{params[:message]}")
    @message = decryption[:message]
    erb :display
  end
  
end