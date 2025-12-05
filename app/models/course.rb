class Course < ApplicationRecord
  belongs_to :prefix
  has_many :sections, dependent: :destroy
  has_rich_text :syllabus
  
  validates :title, presence: true
  validates :number, presence: true, uniqueness: { scope: :prefix_id }
  validates :credit_hours, presence: true, numericality: { greater_than: 0, less_than_or_equal_to: 6 }
  validates :prefix_id, presence: true
  
  def full_name
    "#{prefix.code} #{number}"
  end
  
  def to_s
    "#{full_name} - #{title}"
  end
  
  def display_name
    "#{full_name} - #{title}"
  end
end