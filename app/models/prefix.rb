class Prefix < ApplicationRecord
  has_many :courses, dependent: :destroy
  
  validates :code, presence: true, uniqueness: true
  validates :description, presence: true
  
  def to_s
    "#{code} - #{description}"
  end
  
  def display_name
    "#{code} - #{description}"
  end
end