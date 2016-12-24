class CreateSlackAnswerSessions < ActiveRecord::Migration[5.0]
  def change
    create_table :slack_answer_sessions do |t|
      t.belongs_to :slack_user_mapping, null: false, index: true
      t.text :status, null: false, default: "active", index: true
      t.integer :current_question_id, null: false

      t.timestamps
    end
  end
end
