class AddGetsEmailToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :gets_email, :boolean, default: true
  end
end
