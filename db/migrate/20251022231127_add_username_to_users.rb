class AddUsernameToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :username, :string
    
    # Set default username for existing users
    reversible do |dir|
      dir.up do
        User.find_each do |user|
          user.update_column(:username, user.email.split('@').first)
        end
      end
    end
    
    change_column_null :users, :username, false
    add_index :users, :username, unique: true
  end
end
