# coding: utf-8
class AddStatusToGroups < ActiveRecord::Migration

  class Group < ActiveRecord::Base

  end

  class Article < ActiveRecord::Base

  end

  def change
    add_column :groups, :status, :string, :null => false, :default => 'open'
    add_column :groups, :score,  :integer, :null => false, :default => 0
    Group.reset_column_information
    Group.all.each do |g|
      g.update_attributes!(:score=>(Article.count :all, :conditions => ['group_id = ? and created_at >= ? and created_at <= ?', g.id, 1.week.ago.strftime("%Y-%m-%d"),Time.now.strftime("%Y-%m-%d")]))
    end
  end
  def self.down
    remove_column :groups, :status
    remove_column :groups, :score
  end
end
