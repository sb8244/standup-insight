class QuestionSet
  def questions
    {
      1 => "What did you do yesterday?",
      2 => "What are you going to do today?",
      3 => "Do you have any blockers?"
    }
  end

  def question(id)
    questions[Integer(id)]
  end

  def question_ids
    questions.keys
  end

  def first
    questions[1]
  end

  def next_question_id(id)
    current_question_index = question_ids.index(id)
    question_ids[current_question_index + 1]
  end
end
