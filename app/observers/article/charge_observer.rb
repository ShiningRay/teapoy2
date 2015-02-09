# encoding: utf-8

# When a user post an article to a group
# if the user is not the owner of that group,
# the user should spent some amount of credits
# and the group owner gains half of that amount of credits
class Article::ChargeObserver < Mongoid::Observer
	observe :article
	def before_save(article)
		if article and article.group and \
      article.original_user and article.group.owner and \
      article.original_user != article.group.owner and article.group_id > 0 and article.slug != 'new'
			User.transaction do
				article.original_user.spend_credit(10, "发帖消费10分")
				article.group.owner.gain_credit(5, "有人发帖你赚5分")
			end
		end
	end
end
