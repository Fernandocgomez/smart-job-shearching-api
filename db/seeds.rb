require File.expand_path('../../spec/instance_helper', __FILE__)
User.destroy_all
Board.destroy_all
Column.destroy_all
Lead.destroy_all
JobPosition.destroy_all
LeadEmail.destroy_all
Company.destroy_all

user_1 = User.create(InstanceHelper.seed_get_user_params)

company_1 = Company.create(InstanceHelper.seed_get_company_params)

board_1 = Board.create(InstanceHelper.seed_get_board_params(user_1.id))

column_1 = Column.create(InstanceHelper.seed_get_column_params(board_1.id))

lead_1 = Lead.create(InstanceHelper.seed_get_lead_params(column_1.id, company_1.id))

job_position_1 = JobPosition.create(InstanceHelper.seed_get_job_position_params(user_1.id, company_1.id))

lead_email_1 = LeadEmail.create(InstanceHelper.seed_get_lead_email_params(lead_1.id, job_position_1.id))