class StandUp < ApplicationRecord
  belongs_to :group

  has_many :answers
end
