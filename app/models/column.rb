class Column < ApplicationRecord
    has_many :leads
    belongs_to :board
end
