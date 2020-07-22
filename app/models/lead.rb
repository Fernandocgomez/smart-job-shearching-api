class Lead < ApplicationRecord
  has_many :lead_emails, dependent: :delete_all
  belongs_to :column
  belongs_to :company

  validates_associated :lead_emails

  # Global validations
  validates :first_name, :last_name, :picture_url, :linkedin_url, :status, :notes, :phone_number, {
    presence: true,
  }

  #   first_name & last_name validations
  validates :first_name, :last_name, {
    format: { with: /\A[a-zA-Z]*\z/, message: "only letters are allowed" },
    length: { within: 2..15 },
  }

  # picture_url validations

  # linkedin_url validations

  # note vlidations

  # email validations

  validates :email, {
    format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, message: "email format is not valid" }
  }

  # phone_number validations

  validates :phone_number, telephone_number: {country: :us, types: [:mobile]}


  # column_id validations

  # company_id validations

end
