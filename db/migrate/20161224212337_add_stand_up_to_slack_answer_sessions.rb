class AddStandUpToSlackAnswerSessions < ActiveRecord::Migration[5.0]
  def change
    add_reference :slack_answer_sessions, :stand_up, null: false
  end
end
