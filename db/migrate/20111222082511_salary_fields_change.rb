# coding: utf-8
class SalaryFieldsChange < ActiveRecord::Migration
  def up
    rename_column :salaries, :salary_date, :created_on
    rename_column :salaries, :salary_name, :type
    execute 'UPDATE salaries SET type="DailyLogin" WHERE type="daily_login"'
    execute 'UPDATE salaries SET type="DailyArticle" WHERE type="daily_article"'
    execute 'UPDATE salaries SET type="DailyComment" WHERE type="daily_comment"'
  end

  def down
  end
end
