class AddQuestionContentToAnswers < ActiveRecord::Migration[5.0]
  def change
    add_column :answers, :question_content, :text, null: false
  end
end
