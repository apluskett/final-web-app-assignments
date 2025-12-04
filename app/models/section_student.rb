class SectionStudent < ApplicationRecord
  belongs_to :section
  belongs_to :student
  
  validates :section_id, presence: true, uniqueness: { scope: :student_id }
  validates :student_id, presence: true
end