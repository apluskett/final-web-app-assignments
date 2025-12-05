class Student < ApplicationRecord
  has_many :section_students, dependent: :destroy
  has_many :sections, through: :section_students
  
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :student_id, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  
  # Keep name for backward compatibility, but auto-populate from first/last name
  before_save :update_full_name
  
  def to_s
    "#{first_name} #{last_name} (#{student_id})"
  end
  
  private
  
  def update_full_name
    self.name = "#{first_name} #{last_name}".strip
  end
end