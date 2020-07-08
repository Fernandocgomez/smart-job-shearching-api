# we use the spec_helper to test just plain ruby classes or functions
# To test models and controllers we use the rails_helper
require 'spec_helper'

RSpec.describe 'an example of a simple test' do 
    it 'works' do 
        expect(10).to eql(10)
    end

    it "doesn't work" do 
        expect(true).to be(false)
    end
end