class CreateSlackUserMappings < ActiveRecord::Migration[5.0]
  def change
    create_table :slack_user_mappings do |t|
      t.belongs_to :user, null: false, index: true
      t.belongs_to :group, null: false, index: true
      t.text :slack_user_id, null: false

      t.timestamps
    end
  end
end
