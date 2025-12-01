class Project < ApplicationRecord
    has_many :assignments, dependent: :destroy
    has_many :employees, through: :assignments

    # this app's column is `project_name` in the schema
    validates :project_name, presence: true, length: { maximum: 255 }

    # simple case-insensitive search over project_name and description
    scope :search, ->(q) do
        return all if q.blank?
        sanitized = "%#{q.downcase}%"
        where("LOWER(project_name) LIKE ? OR LOWER(COALESCE(description, '')) LIKE ?", sanitized, sanitized)
    end
end
