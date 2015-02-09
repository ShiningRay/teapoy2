class UserProfile
  include Mongoid::Document
  include Tenacity
  t_belongs_to :user
  field :sex, type: String, default: ''
  field :birthday, type: Date
  field :hometown, type: String
  field :bio, type: String
  field :want_receive_notification_email, type: Boolean, default: true

  def self.migrate_from_mysql_to_mongo(start=0)
    conn = ActiveRecord::Base.connection
    loop do
      pres = conn.select "select * from preferences where id > #{start} and owner_type='User' order by id asc limit 1000"
      break if pres.size == 0
      pres.each do |p|
        start = p['id']
        unless p['value'] == '0'
          doc = UserProfile.collection.find(user_id: p['owner_id']).first || {:user_id => p['owner_id']}
          doc[p['name']] = p['value']
          if doc['_id']
            UserProfile.collection.find('_id' => doc['_id']).update(doc)
          else
            UserProfile.collection.insert(doc)
          end
        end
      end
    end
  end
end
