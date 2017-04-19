class RemoveSessionTokenFromUser < ActiveRecord::Migration[5.0]
  def change
    remove_column :users, :session_token
  end
end
