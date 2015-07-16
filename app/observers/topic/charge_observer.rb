# encoding: utf-8

# When a user post an topic to a group
# if the user is not the owner of that group,
# the user should spent some amount of credits
# and the group owner gains half of that amount of credits
class Topic::ChargeObserver < ActiveRecord::Observer
	observe :topic
	def before_save(topic)
		if topic and topic.group and \
      topic.original_user and topic.group.owner and \
      topic.original_user != topic.group.owner and topic.group_id > 0 and topic.slug != 'new'
			User.transaction do
				topic.original_user.spend_credit(10, "发帖消费10分")
				topic.group.owner.gain_credit(5, "有人发帖你赚5分")
			end
		end
	end
end
