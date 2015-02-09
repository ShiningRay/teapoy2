# coding: utf-8
module User::BalanceAspect
  extend ActiveSupport::Concern

  included do
    has_one :balance, :autosave => true
    has_many :transactions, :through => :balance
    has_many :salaries

    def credit
      balance.credit
    end

    class_eval do
      alias original_balance balance
      def balance
        original_balance || create_balance
      end
    end

    #include BalancePatch
  end
=begin
  module BalancePatch
    def balance
      super || create_balance
    end
  end
=end

    def gain_credit(amount, reason='')
      transaction :requires_new => true do
        balance.save! if balance.new_record?
        balance.lock!
        credit = balance.credit + amount
        raise Balance::InsufficientFunds if credit < 0
        balance.credit = credit
        balance.transactions.create :amount => amount, :reason => reason
        yield if block_given?
        balance.save!
      end
    end

    def spend_credit(amount, reason='', &block)
      gain_credit(-amount, reason, &block)
    end

    def salary_paid?(type, date)
      salaries.unpaid.find_by_type_and_created_on(type.classify, date)
    end

    def get_salary salary_name, salary_date = Date.today
      salary_name ||= ''
      salary = salaries.unpaid.find_by_type_and_created_on(salary_name.classify, salary_date)
      if salary && salary.unpaid? && salary.amount > 0
        begin
          transaction do
            salary.lock!
            gain_credit(salary.amount, salary.class.name)
            salary.status = 1
            salary.save!
          end
          #领工资成功，返回true 和 工资数目
          return true ,salary.amount
        rescue
          #有工资可以领，但是失败了，返回 false 和 0
          return false,0
        end
      else
        #没有工资可以领，或者是工资金额为0（这个貌似不会发生，除非自己改数据库）
        return true,0
      end
    end

    def make_salary salary_name, date = Date.today
      s = Salary.cast(salary_name)
      unless s.where(:user_id => self.id, :created_on => date).exists?
        salaries << s.new(:created_on => date)
      end
    end

    def make_salary_async salary_name, date = Date.today
      SalaryMakingWorker.perform_async self.id, salary_name, date
    end

  #module ClassMethods
  #
  #end
end
