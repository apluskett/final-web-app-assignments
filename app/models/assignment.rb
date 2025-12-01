class Assignment < ApplicationRecord
  belongs_to :employee
  belongs_to :project

  validates :employee_id, presence: true
  validates :project_id, presence: true
  validates :project_id, uniqueness: { scope: :employee_id } # avoid duplicates
end
