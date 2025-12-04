class Student < ApplicationRecord
  has_many :section_students, dependent: :destroy
  has_many :sections, through: :section_students
  
  validates :name, presence: true
  validates :student_id, presence: true, uniqueness: true
  
  def to_s
    "#{name} (#{student_id})"
  end
end