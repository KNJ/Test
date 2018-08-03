class SurveyAnswer < ApplicationRecord
    belongs_to :survey
    validates :answer, presence: true
end