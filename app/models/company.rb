class Company < ApplicationRecord
    has_many :job_positions, dependent: :delete_all
    has_many :leads, dependent: :delete_all
    belongs_to :user

    validates_associated :job_positions, :leads

    # global validations
    validates :name, :linkedin_url, :user_id, { 
        presence: true 
    }


end
