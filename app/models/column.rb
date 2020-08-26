class Column < ApplicationRecord
    has_many :leads, dependent: :delete_all
    belongs_to :board

    # associations validations
    validates_associated :leads

    # Global validations
    validates :name, :position, :board_id, {
        presence: true
    }

    # name validations
    validates :name, {
        length: { within: 5..25 },
        format: { with: /\A[a-zA-Z\s]+\z/, message: "name format is not valid" }
    }

    # position validations
    validates :position, {
        numericality: { greater_than_or_equal_to: 0, only_integer: true}
    }

end
