class CreateSlackResponses < ActiveRecord::Migration[5.0]
  def change
    create_table :slack_responses do |t|
      t.belongs_to :slack_answer_session, index: true, null: false
      t.integer :question_id, null: false
      t.text :text, null: false
      t.text :question_content, null: false

      t.timestamps
    end
  end
end
