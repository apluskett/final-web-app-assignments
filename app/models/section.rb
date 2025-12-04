class Section < ApplicationRecord
  belongs_to :course
  has_many :section_students, dependent: :destroy
  has_many :students, through: :section_students
  
  validates :name, presence: true, uniqueness: { scope: :course_id }
  validates :course_id, presence: true
  
  def full_name
    "#{course.full_name} - #{name}"
  end
  
  def to_s
    full_name
  end
end