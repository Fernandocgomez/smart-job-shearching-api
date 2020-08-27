class JobPosition < ApplicationRecord
    has_many :lead_emails, dependent: :delete_all
    belongs_to :company

    validates_associated :lead_emails

    # Global validations
    validates :name, :description, :city, :state, {
        presence: true
    }

    # state validations
    
    validates :state, {
        length: { is: 2 },
        format: { with: /\A[a-zA-Z]*\z/ },
    }

    # applied validations

    validates_inclusion_of :applied, :in => [true, false]

end
