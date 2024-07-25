require 'rails_helper'

RSpec.describe Search, type: :model do
  let(:valid_attributes) do
    {
      ip_address: '127.0.0.1',
      search_params: 'hello world'
    }
  end

  it 'is valid with valid attributes' do
    search = Search.create! valid_attributes
    expect(search).to be_valid
  end
end
