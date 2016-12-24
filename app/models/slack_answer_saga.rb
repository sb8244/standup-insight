class SlackAnswerSaga
  def initialize(slack_user_mapping)
    @slack_user_mapping = slack_user_mapping
    @active_session = slack_user_mapping.active_session
  end

  def process(text:, reply_proc:)
    if active_session
      if text.downcase == "next" && next_question_id
        reply_proc.call(text: "Thanks! #{next_question}")
        active_session.update!(current_question_id: next_question_id)
      elsif text.downcase == "finish" && !next_question_id
        active_session.complete!(question_set)
        reply_proc.call(text: "Thanks! Your standup for #{active_session.stand_up.date_of_standup} is complete.")
      else
        active_session.slack_responses.create!(text: text, question_id: current_question_id, question_content: current_question)

        if next_question_id
          reply_proc.call(text: "Thanks! Continue answering this question or type 'next' to continue.")
        else
          reply_proc.call(text: "Thanks! Continue answering this question or type 'finish' to complete your standup.")
        end
      end
    else
      reply_proc.call(text: "I don't seem to be taking a standup from you right now!")
    end
  end

  private

  attr_reader :active_session, :slack_user_mapping

  def question_set
    @question_set ||= slack_user_mapping.group.question_set
  end

  def next_question_id
    question_set.next_question_id(current_question_id)
  end

  def next_question
    question_set.question(next_question_id)
  end

  def current_question_id
    active_session.current_question_id
  end

  def current_question
    question_set.question(current_question_id)
  end
end
