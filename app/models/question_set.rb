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
end
