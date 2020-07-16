class Lead < ApplicationRecord
    has_many :lead_emails, dependent: :delete_all
    belongs_to :column
    belongs_to :company

    validates_associated :lead_emails
end
