require 'rails_helper'

RSpec.describe SearchesController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/searches').to route_to('searches#index')
    end

    it 'routes to #show' do
      expect(get: '/analytics').to route_to('searches#show')
    end
  end
end
