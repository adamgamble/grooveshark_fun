load 'lib/tmp_song.rb'
load 'lib/album_art.rb'

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
  private
  def fetch_cover(artist, album)
    lastfm_key = "b25b959554ed76058ac220b7b2e0a026" 
    lastfm_host = "ws.audioscrobbler.com"
    artist = CGI.escape(artist)
    album = CGI.escape(album)

    path = "/2.0/?method=album.getinfo&api_key=#{lastfm_key}&artist=#{artist}&album=#{album}"
    data = Net::HTTP.get(lastfm_host, path)
    xml = XmlSimple.xml_in(data)
    if xml['status'] == 'ok' then
      album = xml['album'][0]

      cover = {
        :small => album['image'][1]['content'],
        :medium => album['image'][2]['content'],
        :big => album['image'][3]['content']
      }

      return cover
    end

    return nil
  end
end
