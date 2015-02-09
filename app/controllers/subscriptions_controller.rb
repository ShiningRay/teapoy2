# coding: utf-8
class SubscriptionsController < ApplicationController
  before_filter :login_required
  def index
  end

  protected
  def begin_of_association_chain
    current_user
  end
end
