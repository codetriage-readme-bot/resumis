class WorkExperience < ActiveRecord::Base
  belongs_to :user
  has_many :resumes, through: :resume_work_experience

  default_scope { order(end_date: :desc) }
end
