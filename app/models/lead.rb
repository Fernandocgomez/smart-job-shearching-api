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

  # phone_number validations

  validates :phone_number, telephone_number: {country: :us, types: [:mobile]}

end
