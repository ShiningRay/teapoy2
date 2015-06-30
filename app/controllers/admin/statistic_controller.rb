# coding: utf-8
class Admin::StatisticController < Admin::BaseController
  before_filter :login_required, :only => [:index]
  #require_role "admin", :except => [:index]
  def index
    today = Date.today
    b = today << 1
    today_topics = ActiveRecord::Base.connection.select_all(<<sql).collect{|c| c["count(*)"].to_i}
select date(created_at),count(*) from topics
where created_at < '#{today}' and created_at > '#{b}'
group by date(created_at)
sql
    today_users = ActiveRecord::Base.connection.select_all(<<sql).collect{|c| c["count(*)"].to_i}
select date(created_at),count(*) from users
where created_at < '#{today}' and created_at > '#{b}'
group by date(created_at)
sql
    date=ActiveRecord::Base.connection.select_all( <<sql ).collect{|c| c["date(created_at)"].to_date.day.to_s}
select date(created_at),count(*) from topics
where created_at < '#{today}' and created_at > '#{b}'
group by date(created_at)
sql

    @chart = LazyHighCharts.new("topics and users statistics" ) do |f|
      f.xAxis categories: date
      f.series name: 'topics', data: today_topics
      f.series name: 'new users', data: today_topics
    end
  end
  def  statistics_info
    @statistic=Statistics.find(:first,:condition=>["limit= ? ccand created_at >?","24_hours", 24.hours.ago])
  end

  def stats
     @today = Date.today
     @start = params[:start] ? Date.parse( params[:start]) : (@today << 1)
     @end = params[:end] ? Date.parse(params[:end]) : (@today+1)
     params[:object]||='User'
     case params[:object]
     when "Topic"
       then  @stats = Post.count :all, :conditions => ["created_at >= ? and created_at <= ? and floor = 0 and (type is NULL or type = 'Picture' or type ='ExternalVideo' )", @start, @end], :group => 'date(created_at)'
     when 'Post'
       then
       @stats = Post.count :all, :conditions => ['created_at >= ? and created_at <= ? and floor != 0 ', @start, @end], :group => 'date(created_at)'
     when "TodayArticleUser"
       then
       @stats = Salary::DailyArticle.count(:all,:conditions =>["	created_on >= ? and 	created_on <= ?", @start, @end],:group => 'date(created_on) ')
     when "Notification"
       then
       conditions = Notification.where(:created_at.gte => @start,:created_at.lte => @end).selector
       temp_results = Notification.collection.group(:keyf => "function(doc) { d = new Date(doc.created_at); return {created_at: d.toLocaleDateString() }; }",
        :initial => { :count => 0 },
        :reduce => "function(doc,prev) { prev.count += +1; }",
        :cond => conditions)
       @stats =  ActiveSupport::OrderedHash.new
       temp_results.each do |result|
         @stats[result['created_at']] = result["count"]
       end
     when "TodayPostUser"
       then
        @stats = Salary::DailyComment.where(" created_on >= ? and created_on <= ?", @start, @end).group('date(created_on)').count
     when "Todayloginuser"
       then
       @stats = Salary::DailyLogin.where("created_on >= ? and created_on <= ?", @start, @end).group('date(created_on)').count
     else
      @class = Kernel.const_get(params[:object])
      @stats = @class.where('created_at >= ? and created_at <= ?', @start, @end).group('date(created_at)').count
    end
    data_1 = []
    data_2 = []
    @stats.to_hash.sort.each do  |datee, count|
      data_1 << datee.to_date.to_s
      data_2 << count.to_i
    end
    @chart = LazyHighCharts::HighChart.new(params[:object]) do |f|
      f.xAxis categories: data_1
      f.series type: 'column', data: data_2
    end
  end
end

