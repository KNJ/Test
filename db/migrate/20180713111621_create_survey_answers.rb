class CreateSurveyAnswers < ActiveRecord::Migration[5.1]
  def change
    create_table :survey_answers do |t|
      t.references :survey, foreign_key: true
      t.string :answer
      t.integer :rank
      t.integer :votes
      
      t.timestamps
    end
  end
end
