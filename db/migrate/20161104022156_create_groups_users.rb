class CreateGroupsUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :groups_users do |t|
      t.belongs_to :group, foreign_key: true, null: false
      t.belongs_to :user, foreign_key: true, null: false
    end

    add_index :groups_users, [:group_id, :user_id], unique: true
  end
end
