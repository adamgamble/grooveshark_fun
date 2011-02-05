load 'lib/tmp_song.rb'
class SongsController < ApplicationController
  before_filter :load_grooveshark_client

  def load_grooveshark_client
    @client = Grooveshark::Client.new
  end

  def index
  end
  def search
    @songs = @client.search_songs(params["search_string"])
  end

  def play
    song = TempSong.new params[:id]
    @song_url = @client.get_song_url(song)
  end
end
