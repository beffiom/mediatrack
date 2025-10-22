class CreateWatchlistItems < ActiveRecord::Migration[8.1]
  def change
    create_table :watchlist_items do |t|
      t.references :user, null: false, foreign_key: true
      t.references :media_item, null: false, foreign_key: true
      t.string :status, null: false, default: "planned"
      t.date :watched_on

      t.timestamps
    end

    add_index :watchlist_items, [:user_id, :media_item_id], unique: true
  end
end
