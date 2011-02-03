load 'lib/tmp_song.rb'
class SongsController < ApplicationController
  before_filter :load_grooveshark_client

  def load_grooveshark_client
    @client = Grooveshark::Client.new
  end

  def index
  end
  def search
    @songs = @client.search_songs_pure(params["search_string"])["result"]["songs"]
    render :update do |page|
      page.replace_html 'search-results', :partial => "search_results"
    end
  end

  def play
    song = TempSong.new params[:id]
    @song_url = @client.get_song_url(song)
    render :update do |page|
      page.replace_html params[:id], :partial => "play_song"
    end
  end
end
