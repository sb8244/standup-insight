class CreateAnswers < ActiveRecord::Migration[5.0]
  def change
    create_table :answers do |t|
      t.belongs_to :stand_up, foreign_key: true, null: false
      t.belongs_to :user, foreign_key: true, null: false
      t.integer :question_id, null: false
      t.text :content, null: false

      t.timestamps
    end
  end
end
