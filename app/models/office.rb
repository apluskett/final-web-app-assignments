class Office < ApplicationRecord
  belongs_to :employee

  validates :number, presence: true, numericality: { only_integer: true }

  # search by office number or the employee's name (case-insensitive)
  scope :search, ->(q) do
    return all if q.blank?
    sanitized = "%#{q.downcase}%"
    joins(:employee).where("CAST(offices.number AS TEXT) LIKE ? OR LOWER(employees.name) LIKE ?", sanitized, sanitized)
  end
end
