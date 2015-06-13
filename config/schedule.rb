# coding: utf-8
#set :job_template, "/bin/bash -l -c \":job\""
#set :job_template, nil
set :output, {:error => 'log/error.log', :standard => 'log/cron.log'}
job_type :runner,  "cd :path && bundle exec rails runner -e :environment ':task' :output"


every :day, :at => '0:00am' do
  # runner 'Inbox.evict!'
  runner 'Notification.remove_read!'
end

every :day, :at => '11:58pm' do
  runner "DailyStatistic.make_today_record"
end

every 20.minutes do
  # runner 'Importer::Qiushibaike.import'
end

every :day, :at => '3:00am' do
  runner "Group.update_scores"
  runner "GroupMailer.daily_deliver_for_all"
end

every :day, :at => '2:30am' do
  runner "Salary.make_yesterday_salary"
  # runner 'Inbox::UserCount.truncate_inbox'
  # runner 'Inbox.remove_outdated'
end

every :sunday, :at => '3:00am' do
  command "mysqldump teapoy -F --master-data --ignore-table=teapoy.sessions | gzip > $HOME/teapoy-`hostname`-`date +%Y%m%d`.sql.gz"
end
