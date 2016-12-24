class CreateSlackIntegrations < ActiveRecord::Migration[5.0]
  def change
    create_table :slack_integrations do |t|
      t.belongs_to :user, null: false
      t.belongs_to :group, index: true, null: false
      t.text :bot_token, null: false
      t.text :bot_user_id, null: false
      t.text :slack_team_name, null: false
      t.text :slack_team_id, null: false
      t.text :slack_team_url, null: false
      t.text :slack_user_id, null: false

      t.timestamps
    end
  end
end
