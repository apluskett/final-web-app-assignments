class Prefix < ApplicationRecord
  has_many :courses, dependent: :restrict_with_error
  
  validates :code, presence: true, uniqueness: true, format: { with: /\A[A-Z]{2,4}\z/, message: "must be 2-4 letters only" }
  validates :description, presence: true
  
  before_validation :upcase_code
  
  def to_s
    "#{code} - #{description}"
  end
  
  def display_name
    "#{code} - #{description}"
  end
  
  private
  
  def upcase_code
    self.code = code.upcase if code.present?
  end
end