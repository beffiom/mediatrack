class AddTmdbApiKeyToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :tmdb_api_key, :string
  end
end
