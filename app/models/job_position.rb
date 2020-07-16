class JobPosition < ApplicationRecord
    has_many :lead_emails, dependent: :delete_all
    belongs_to :company
    belongs_to :user

    validates_associated :lead_emails
end
