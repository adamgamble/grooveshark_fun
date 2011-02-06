class CreateAlbumArtworks < ActiveRecord::Migration
  def self.up
    create_table :album_artworks do |t|
      t.integer :song_id
      t.string :small_url
      t.string :medium_url
      t.string :large_url
      t.string :artist
      t.string :album

      t.timestamps
    end
  end

  def self.down
    drop_table :album_artworks
  end
end
