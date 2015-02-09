# coding: utf-8
require 'rubygems'
require File.expand_path("../../config/environment", __FILE__)
require 'mailman'
require 'daemons'

Daemons.run_proc 'mailman', dir_mode: :normal,
                            dir:      Rails.root.join('tmp/pids'),
                            log_dir:  Rails.root.join('log'),
                            log_output: true,
                            monitor:  true  do
  Mailman.config.maildir = '~/Maildir'
  ActiveRecord::Base.observers << :'user/returned_mail_observer'
  ActiveRecord::Base.instantiate_observers
  ActiveRecord::Base.verify_active_connections!
  Mailman::Application.run do
    to 'auth@bling0.com' do
      subject = message.subject.to_s.strip
      if subject.blank?
        puts "blank subject"
      else
        user = User.find_by_login(subject) || User.find_by_name(subject)
        if user && message.from.include?(user.email) && user.state == 'pending'
          puts "activate \##{user.id} #{user.login}"
          user.state = 'active'
          user.save!
        end
      end
    end
    rejected_email = Proc.new do
      if message.multipart?
        delivery_status = message.parts.select{|m| m.content_type == "message/delivery-status"}.first
        headers = {}
        delivery_status.body.decoded.split(/\n/).each do |l|
          unless l.blank?
            key, value = l.split(/:/, 2)
            headers[key] = value
          end
        end
        _, email = headers['Final-Recipient'].split( /;/, 2)
        puts email
        user = User.find_by_email(email.strip)
        if user
          puts user.login
          case headers['Diagnostic-Code']
          when /not found/
            puts 'not found'
            User.notify_observers(:address_not_exists, user)
          else #when /reject/
            User.notify_observers(:mail_reject, user)
          end
        end
      end
    end
    from 'MAILER-DAEMON@bling0.com', &rejected_email
    from 'Postmaster@(163|126).com', &rejected_email
    from 'PostMaster@qq.com' do
      if message.multipart?
        returned_message = message.parts.select{|m| m.content_type =~ /message/}.first
        if returned_message.body.decoded =~ /^To: (.*)$/
          address = $1
          puts address
          user = User.find_by_email(address.strip)
          if user
            puts user.login
            User.notify_observers(:address_not_exists, user)
          end
        end
      end
    end
  end
end
