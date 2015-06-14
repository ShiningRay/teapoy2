# coding: utf-8
# == Schema Information
#
# Table name: ticket_types
#
#  id          :integer          not null, primary key
#  name        :string(255)      not null
#  description :string(255)
#  weight      :integer          default(0), not null
#  need_reason :boolean
#  callback    :string(255)
#

class TicketType < ActiveRecord::Base
  def to_s
    "#{name} #{weight}"
  end
end
