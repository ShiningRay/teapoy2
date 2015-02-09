# coding: utf-8
package :mongodb do
  description 'MongoDB NoSQL Database'
  #requires :mongodb_apt_source
  apt 'mongodb'

  verify do
    %w(mongod mongo).each{|i|has_executable i}
  end
end

package :mongodb_apt_source do
  runner 'sudo apt-key adv --keyserver keyserver.ubuntu.com --recv 7F0CEB10'
  deb = 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen'
  sourceslist = '/etc/apt/sources.list'
  push_text deb, sourceslist , :sudo => true do
    post :install, 'sudo apt-get update'
  end
  verify do
    file_contains sourceslist, deb
  end
end