class OfficeManager < ApplicationRecord
  has_many :employees, dependent: :nullify

  validates :name, presence: true, length: { maximum: 200 }

  # simple case-insensitive search by name
  scope :search, ->(q) do
    return all if q.blank?
    sanitized = "%#{q.downcase}%"
    where("LOWER(name) LIKE ?", sanitized)
  end
end
