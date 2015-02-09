# coding: utf-8
package :percona_apt_key do
  runner 'gpg --keyserver  hkp://keys.gnupg.net --recv-keys 1C4CBDCDCD2EFD2A && gpg -a --export CD2EFD2A | sudo apt-key add -'
end
package :percona_apt_source do
  repos = <<text
deb http://repo.percona.com/apt #{$UBUNTU_VERSION} main
deb-src http://repo.percona.com/apt #{$UBUNTU_VERSION} main
text
  list_file = '/etc/apt/sources.list'
  push_text repos, list_file, :sudo => true do
    post :install, 'sudo apt-get update'
  end

  verify do
    repos.split.each do |line|
      file_contains list_file, line
    end
  end
end

package :percona_apt_pinning do
  file = '/etc/apt/preferences.d/00percona.pref'
  content = <<content
Package: *
Pin: release o=Percona Development Team
Pin-Priority: 1001
content
  push_text content, file, :sudo => true
  verify do
    content.split.each do |line|
      file_contains file, line
    end
  end
end

package :percona, :provides => :database do
  description 'Percona MySQL database'
  requires :percona_apt_key
  requires :percona_apt_source
  requires :percona_apt_pinning
  apt %w(percona-server-server-5.5 percona-server-client-5.5 libmysqlclient-dev)
  verify do
    %w(mysql mysqldump mysqlimport).each do |f|
      has_executable f
    end
  end
end