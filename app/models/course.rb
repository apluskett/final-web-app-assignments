class Course < ApplicationRecord
  belongs_to :prefix
  has_many :sections, dependent: :destroy
  
  validates :number, presence: true, uniqueness: { scope: :prefix_id }
  validates :prefix_id, presence: true
  
  def full_name
    "#{prefix.name} #{number}"
  end
  
  def to_s
    full_name
  end
end