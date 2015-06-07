# coding: utf-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

User.create login: 'guest', name: 'guest', password: '1234qwer!@#$', password_confirmation: '1234qwer!@#$', email: 'guest@bling0.com'
User.connection.execute "update users set id = 0 where login like 'guest'"
r = Role.find_or_create_by name: 'admin'
u = User.create login: 'shiningray', name: 'ShiningRay', password: '1234qwer', password_confirmation: '1234qwer', email: 'shiningray@bling0.com'
u.roles << r
u.status='active'
u.save
Group.create :alias => 'pool', name: '水库', owner_id: u.id