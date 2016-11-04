class CreateGroups < ActiveRecord::Migration[5.0]
  def change
    create_table :groups do |t|
      t.text :title, null: false
      t.boolean :active, default: true, null: false

      t.timestamps
    end
  end
end
