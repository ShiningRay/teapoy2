# coding: utf-8
class AddCorrectCountToWeights < ActiveRecord::Migration
  def self.up
    add_column :weights, :correct, :integer
    execute <<sql
update weights,
(select count(*) as correct,user_id from tickets
 where correct = '1' group by user_id)as t2
set weights.correct=t2.correct
 where weights.user_id = t2.user_id
sql
  end

  def self.down
    remove_column :weights, :correct, :integer
  end
end
