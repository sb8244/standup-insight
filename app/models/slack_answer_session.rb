class SlackAnswerSession < ApplicationRecord
  belongs_to :slack_user_mapping
  belongs_to :stand_up

  has_many :slack_responses

  def complete!(question_set)
    if slack_responses.pluck(:question_id).uniq.sort == question_set.question_ids.uniq.sort
      Answer.transaction do
        user = slack_user_mapping.user
        slack_responses.order(created_at: :asc).each do |response|
          user.answers.create!(
            stand_up: stand_up,
            question_id: response.question_id,
            question_content: response.question_content,
            content: response.text
          )
        end
        update!(status: "complete")
      end
    else
      update!(status: "error")
    end
  end
end
