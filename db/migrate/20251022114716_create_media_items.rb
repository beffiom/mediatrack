class CreateMediaItems < ActiveRecord::Migration[8.1]
  def change
    create_table :media_items do |t|
      t.integer :tmdb_id
      t.string :title
      t.string :media_type
      t.text :overview
      t.string :poster_path
      t.date :release_date

      t.timestamps
    end
    add_index :media_items, :tmdb_id, unique: true
  end
end
