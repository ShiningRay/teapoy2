# coding: utf-8
class DelayedJobMongoidIndex < ActiveRecord::Migration
  def up
    Delayed::Backend::Mongoid::Job.create_indexes rescue nil
  end

  def down
  end
end
