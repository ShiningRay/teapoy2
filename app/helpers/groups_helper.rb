# coding: utf-8
module GroupsHelper
  #include TagsHelper
  def latest_group_topics_path(group)
    "/groups/#{group.alias}/topics"
  end

  def latest_all_topics_path
    "/"
  end

  def hottest_all_topics_path
    "/all/hottest"
  end

  def url_for_group group
    group = Group.find(group) unless group.is_a? Group
    url_for('/', :host => group.domain)
  end

  def category_traverse(category, level = 0, s = [], &block)
    s << yield(category, level)
    level+=1
    for i in category.children
      category_traverse(i, level, s, &block)
    end
    s.join
  end

  def categories_options
    nested_set_options(Group) {|i| "#{'-' * i.level} #{i.name}" }
  end

  def group_detail_for(topic)
    group = topic.group
    if logged_in? and !current_user.is_member_of?(group)
      link_to topic.group.name, group_topics_path(topic.group),:data=>{:id=>"#{group.alias}",:description=>"#{group.description}"},:class=>"group_card"
    else
      link_to topic.group.name, group_topics_path(topic.group),:data=>{:description=>"#{group.description}"},:class=>"group_card"
    end
  end

  def calendar_options_for_group(group)
   dates = []
   first = group.created_at.to_date
   last = Date.today
   first_month = first.month
   first_year = first.year
   last_year = last.year
   last_month = last.month
   (first_year..last_year).each do |year|
   (1..12).each do |month|
       unless (Time.mktime(year,month) < Time.mktime(first_year,first_month) || Time.mktime(year,month) > Time.mktime(last_year,last_month))
          dates<<"#{year}-#{month}"
        end
    end
  end
  select_tag("select_date_for_group",options_for_select(dates),:id=>"select_date_for_group",:data=>{:alias=>group.alias},:include_blank => true)
  end
   #alias_method :group_path_original, :group_path

end
