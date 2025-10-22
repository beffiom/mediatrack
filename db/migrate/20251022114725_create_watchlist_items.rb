class CreateWatchlistItems < ActiveRecord::Migration[8.1]
  def change
    create_table :watchlist_items do |t|
      t.references :user, null: false, foreign_key: true
      t.references :media_item, null: false, foreign_key: true
      t.string :status

      t.timestamps
    end
  end
end
