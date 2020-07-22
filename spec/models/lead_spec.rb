require 'rails_helper'

RSpec.describe Lead, type: :model do
    before(:each) do
      @user = create_user
      @board = create_board(@user.id)
      @column = create_column(@board.id)
      @company = create_company
    end
    subject {
        # This create an instance of the Lead model
        # requests_helper.rb
        create_lead_instance(@column.id, @company.id)
    }
    describe 'Validations' do
      describe 'first_name' do
        it 'must be presence' do
            expect(subject).to be_valid
            subject.first_name = nil
            expect(subject).to_not be_valid
        end
        it 'must be only letters(upper case and lower case)' do
            expect(subject).to be_valid
            subject.first_name = "Fernando 32%"
            expect(subject).to_not be_valid
        end
        it 'must be at least 2 characters long' do
            expect(subject).to be_valid
            subject.first_name = "F"
            expect(subject).to_not be_valid
        end
        it 'must be maximum of 15 characters long' do
            expect(subject).to be_valid
            subject.first_name = "fernandocgomezferferfer"
            expect(subject).to_not be_valid
        end
      end
      describe 'last_name' do
        it 'must be presence' do
            expect(subject).to be_valid
            subject.last_name = nil
            expect(subject).to_not be_valid
        end
        it 'must be only letters(upper case and lower case)' do
            expect(subject).to be_valid
            subject.last_name = "Gomez 32%"
            expect(subject).to_not be_valid
        end
        it 'must be at least 2 characters long' do
            expect(subject).to be_valid
            subject.last_name = "G"
            expect(subject).to_not be_valid
        end
        it 'must be maximum of 15 characters long' do
            expect(subject).to be_valid
            subject.last_name = "fernandocgomezferferfer"
            expect(subject).to_not be_valid
        end
      end
      describe 'picture_url' do
        it 'must be presence' do
            expect(subject).to be_valid
            subject.picture_url = nil
            expect(subject).to_not be_valid
        end
        it 'must have a default value' do
            params = get_lead_params_copy
            params['column_id'] = @column.id
            params['company_id'] = @company.id
            params.except!("picture_url")
            lead = Lead.create(params)
            expect(lead).to be_valid
            expect(lead['picture_url']).to eq("https://mail.achieverspoint.com/img/default-avatar.jpg")
        end
      end
      describe 'linkedin_url' do
        it 'must be presence' do
            expect(subject).to be_valid
            subject.linkedin_url = nil
            expect(subject).to_not be_valid
        end
      end
      describe 'status' do
        it 'must be presence' do
            expect(subject).to be_valid
            subject.status = nil
            expect(subject).to_not be_valid
        end
        it 'must have a default value' do
            params = get_lead_params_copy
            params['column_id'] = @column.id
            params['company_id'] = @company.id
            params.except!("status")
            lead = Lead.create(params)
            expect(lead).to be_valid
            expect(lead['status']).to eq("new")
        end
      end
      describe 'notes' do
        it 'must be presence' do
            expect(subject).to be_valid
            subject.notes = nil
            expect(subject).to_not be_valid
        end
        it 'must have a default value' do
            params = get_lead_params_copy
            params['column_id'] = @column.id
            params['company_id'] = @company.id
            params.except!("notes")
            lead = Lead.create(params)
            expect(lead).to be_valid
            expect(lead['notes']).to eq("write a note...")
        end
      end
      describe 'email' do
        it 'must be optional' do
            expect(subject).to be_valid
            subject.email = nil
            expect(subject['email']).to be_nil
        end
        it 'must be a valid email' do
            expect(subject).to be_valid
            subject.email = "fernando@invalidemail"
            expect(subject).to_not be_valid
        end
      end
      describe 'phone_number' do
        it 'must be presence' do
            expect(subject).to be_valid
            subject.phone_number = nil
            expect(subject).to_not be_valid
        end
        it 'must have a default value' do
            params = get_lead_params_copy
            params['column_id'] = @column.id
            params['company_id'] = @company.id
            params.except!("phone_number")
            lead = Lead.create(params)
            expect(lead).to be_valid
            expect(lead['phone_number']).to eq("3462600832")
        end
        it 'must be a valid US phone number' do
            expect(subject).to be_valid
            subject.phone_number = "346260083"
            expect(subject).to_not be_valid
        end
      end
      describe 'column_id' do
        it 'must be presence' do
            expect(subject).to be_valid
            subject.column_id = nil
            expect(subject).to_not be_valid
        end
        it 'must exist on the DB' do
            expect(subject).to be_valid
            subject.column_id = subject.column_id + 1
            expect(subject).to_not be_valid
        end
      end
      describe 'company_id' do
        it 'must be presence' do
            expect(subject).to be_valid
            subject.company_id = nil
            expect(subject).to_not be_valid
        end
        it 'must exist on the DB' do
            expect(subject).to be_valid
            subject.company_id = subject.company_id + 1
            expect(subject).to_not be_valid
        end
      end
    end
    
end