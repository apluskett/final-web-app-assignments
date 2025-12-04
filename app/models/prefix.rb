class Prefix < ApplicationRecord
  has_many :courses, dependent: :destroy
  
  validates :name, presence: true, uniqueness: true
  
  def to_s
    name
  end
end