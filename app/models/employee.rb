class Employee < ApplicationRecord
    belongs_to :office_manager, optional: true
    has_one :office, dependent: :destroy
    has_many :assignments, dependent: :destroy
    has_many :projects, through: :assignments

    validates :name, presence: true, length: { maximum: 200 }

    # simple search by name
    scope :search, ->(q) do
        return all if q.blank?
        sanitized = "%#{q.downcase}%"
        where("LOWER(name) LIKE ?", sanitized)
    end
end
