class CreateStandUps < ActiveRecord::Migration[5.0]
  def change
    create_table :stand_ups do |t|
      t.date :date_of_standup, null: false
      t.belongs_to :group, foreign_key: true, null: false

      t.timestamps
    end
  end
end
