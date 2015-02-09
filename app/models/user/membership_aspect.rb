# coding: utf-8
class User
  module MembershipAspect
    extend ActiveSupport::Concern
    #include ActiveSupport::Memoizable
    included do
      has_many :memberships
      #has_many :joined_groups, :through => :memberships, :source => :group
    end

      def joined_groups_ids
        @joined_groups_ids ||= Rails.cache.fetch([self, :joined_groups]) do
          memberships.collect{|m| m.group_id}
        end
      end
      def joined_groups
        @joined_groups ||= Group.find_all_by_id(joined_groups_ids)
      end

      def is_member_of?(g)
        g = Group.wrap(g)
        #memberships.where(:group_id => g.id).size == 1
        joined_groups_ids.include?(g.id)
      end

      def join_group(g)
        Rails.cache.delete([self, :joined_groups])
        return  if g.status == "pending"
        if g.private
          memberships.create :group => g, :role =>"pending"
        else
          m = if g.options.membership_need_approval
            memberships.create :group => g, :role => "pending"
          else
            memberships.create :group => g, :role => "subscriber"
          end
          unless g.options.only_member_can_view
            subscribe(g)
          end
          m
        end
        #    group_role = g.private ?  "pending" : "subscribe"
        #    memberships.create :group => g, :role =>group_role
        #    subscribe(g)
      end

      def quit_group(g)
        Rails.cache.delete([self, :joined_groups])
        memberships.where(:group_id => g.id).delete_all
        unsubscribe(g)
      end
    end

end
