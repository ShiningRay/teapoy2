# coding: utf-8

require 'rails_helper'

describe GroupsController do
  let(:group) { create :group }

  it 'GET index' do
    get :index
  end

  it 'GET show' do
    get :show, id: group.alias
  end
end
