class AnswersController < ApplicationController
  def create
    return not_full_answers_error unless has_all_questions_answered?
    return already_answered_error if stand_up_already_answered?
    create_answers!
    redirect_to group_path(group, query_params)
  end

  private

  def query_params
    params.permit(query_params: [:when]).fetch(:query_params, {}).to_h
  end

  def not_full_answers_error
    flash[:standup_form_error] = "All questions must be answered."
    redirect_to group_path(group, query_params)
  end

  def already_answered_error
    flash[:standup_form_error] = "This standup has already been submitted."
    redirect_to group_path(group, query_params)
  end

  def has_all_questions_answered?
    question_set.questions.all? do |question_id, question|
      params.fetch(:answers)[question_id.to_s].present?
    end
  end

  def stand_up_already_answered?
    stand_up.completed?
  end

  def create_answers!
    Answer.transaction do
      params.fetch(:answers).each do |question_id, content|
        question_content = question_set.question(question_id)
        current_user.answers.create!(
          stand_up_id: stand_up.id,
          question_id: question_id,
          question_content: question_content,
          content: content
        )
      end
      flash[:standup_form_success] = "Thanks for your standup!"
    end
  end

  def stand_up
    @stand_up ||= current_user.stand_ups.find(params.fetch(:stand_up_id)).for_user(current_user)
  end

  def group
    @group ||= stand_up.group
  end

  def question_set
    @question_set ||= group.question_set
  end
end
