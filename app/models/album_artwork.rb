require 'xmlsimple'
require 'net/http'
require 'cgi'
class AlbumArtwork < ActiveRecord::Base
  LASTFM_KEY  = "b25b959554ed76058ac220b7b2e0a026" 
  LASTFM_HOST = "ws.audioscrobbler.com"

  def self.fetch_cover artist, album
    aa = AlbumArtwork.find_by_artist_and_album(artist,album)
    if aa
      return aa
    else
      cover = AlbumArtwork.fetch_cover_from_api(artist, album)
      return AlbumArtwork.create(:artist => artist, :album => album, :small_url => cover[:small], :medium_url => cover[:medium], :large_url => cover[:large])
    end
  end

  def self.fetch_cover_from_api(artist, album)
    artist = CGI.escape(artist)
    album = CGI.escape(album)

    path = "/2.0/?method=album.getinfo&api_key=#{LASTFM_KEY}&artist=#{artist}&album=#{album}"
    data = Net::HTTP.get(LASTFM_HOST, path)
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
