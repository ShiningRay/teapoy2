# memberships_controller_spec.rb

require 'rails_helper'

describe MembershipsController do
  describe 'GET index' do
    let!(:group) { create :group }
    let!(:membership) { create :membership, group: group }
    it 'returns all memberships' do
      get :index, group_id: group.alias
      expect(assigns(:memberships).size).to eq(2)
    end
  end
end