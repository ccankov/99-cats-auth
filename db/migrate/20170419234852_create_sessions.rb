class CreateSessions < ActiveRecord::Migration[5.0]
  def change
    create_table :sessions do |t|
      t.string :session_token, null: false
      t.integer :user_id, null: false
      t.timestamps
    end

    add_index :sessions, :session_token, unique: true
    add_index :sessions, :user_id
    add_index :sessions, [:session_token, :user_id]
  end
end