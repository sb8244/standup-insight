class SlackAnswerSession < ApplicationRecord
  belongs_to :slack_user_mapping
  belongs_to :stand_up

  has_many :slack_responses

  def complete!(question_set)
    Answer.transaction do
      user = slack_user_mapping.user
      slack_responses.order(created_at: :asc).group_by(&:question_id).each do |question_id, responses|
        user.answers.create!(
          stand_up: stand_up,
          question_id: question_id,
          question_content: responses[0].question_content,
          content: responses.map(&:text).join("\n\n")
        )
      end
      update!(status: "complete")
    end
  end
end
