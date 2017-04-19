class AddRequester < ActiveRecord::Migration[5.0]
  def change
    add_column :cat_rental_requests, :requester_id, :integer, null: false
    add_index :cat_rental_requests, :requester_id
  end
end
