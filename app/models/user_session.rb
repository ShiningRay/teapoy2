# coding: utf-8
class UserSession < Authlogic::Session::Base
  find_by_login_method :find_by_login_or_email
  disable_magic_states true
  after_persisting :make_salary

  def make_salary
    #Rails.logger.debug('make_salary')
    current_user = record
    #return unless logged_in?
    return unless current_user
    unless Rails.cache.exist?("#{current_user.id}_#{Date.today.to_s}_login_salary")
      current_user.make_salary_async "daily_login"
      Salary::SequentialLogin.delay.make(current_user.id)
      Rails.cache.write("#{current_user.id}_#{Date.today.to_s}_login_salary", '1', :expires_in => (Date.today.end_of_day-Time.now).to_i)
    end
    Rails.logger.debug(Rails.cache.exist?("#{current_user.id}_#{Date.today.to_s}_login_salary"))
    return true
  end

  def find_by_persistence_token(token)
    PersistenceToken.where(token: token).first.try :user
  end

  def persist_by_cookie
    persistence_token, record_id = cookie_credentials
    if !persistence_token.nil?
      record = record_id.nil? ? search_for_record("find_by_persistence_token", persistence_token) : search_for_record("find_by_#{klass.primary_key}", record_id)
      self.unauthorized_record = record if record && (record.persistence_token == persistence_token || record.persistence_tokens == persistence_token)
      valid?
    else
      false
    end
  end

  def save_cookie
    super
    PersistenceToken.create user_id: record.id, token: record.persistence_token unless PersistenceToken.where( user_id: record.id, token: record.persistence_token).exists?
  end

  # def destroy_cookie
  #   persistence_token, record_id = cookie_credentials
  #   PersistenceToken.where( user_id: record_id, token: persistence_token).delete_all
  #   super
  # end
end
