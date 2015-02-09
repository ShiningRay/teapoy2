class SalaryMakingWorker
  include Sidekiq::Worker
  def perform(user_id, salary_name, date = Date.today)
    user = User.wrap user_id
    user.make_salary(salary_name, date)
  end
end