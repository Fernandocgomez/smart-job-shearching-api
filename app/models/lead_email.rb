class LeadEmail < ApplicationRecord
    belongs_to :lead
    belongs_to :job_positions
end
