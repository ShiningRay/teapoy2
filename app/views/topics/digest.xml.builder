<% for item in digest %>
  <p>
<%= link_to("#{@group.name.mb_chars[0,2]}\##{item.id}", topic_url(item) ) %>
-
<%= item.created_at.strftime("%H:%M:%S") %> <br />
<%= format_content item, @group %>

<% if not item.tag_list.empty? %><p> 标签:
  <% item.tag_list.each do |t| %>
  <%= link_to t, {:controller => :groups, :action => :tag, :id => @group.id, :tag => t, :host => @group.domain},
    {:rel => 'tag'} %>
  <% end %>
    </p>
<% end %>
</p>
<p>
<%= link_to image_tag("http://#{@group.domain}/images/qiushi/good.gif", :alt => '顶', :border=>0),
  {:only_path => false, :controller => :topics, :action => :voteup, :id => item.id, :host => @group.domain} %>
<%= item.pos_score %>
::
<%= link_to image_tag("http://#{@group.domain}/images/qiushi/bad.gif", :alt => '拍', :border=>0),
  {:only_path => false, :controller => :topics, :action => :votedown, :id => item.id, :host => @group.domain} %>
<%= item.neg_score %>
::::
<% c = item.public_comments_count %>
<% if c == 0 %>
<a href="<%= topic_url(item) %>#comments" style="color:red">沙发还在，还不快抢</a>
<% else %>
已有<strong><%= c %></strong>条评论
<a href="<%= topic_url(item) %>#comments" style="color:red">立即参与评论</a>
<% end %>
</p>
<hr style="border:1 dashed #987cb9" size="1" />
<% end %>
<p>
<a href="http://www.qiushibaike.com/">糗事百科</a>是这个星球上最暴笑的糗事分享网站 ::
<a href="http://www.qiushibaike.com/groups/2/add">立即发表我的糗事</a>
|
<a href="http://www.qiushibaike.com/groups/2/hottest/month">查看本月最糗的糗事</a></p>