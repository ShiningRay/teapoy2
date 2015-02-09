# coding: utf-8
package :redis do
  description 'Redis In-Memory Database'
  apt %w( redis-server )

  verify do
    has_executable 'redis-server'
  end

  requires :redis_apt_source
end

package :redis_apt_source do
  description 'Latest redis server apt source'
  requires :python_software_properties
  runner 'sudo add-apt-repository ppa:rwky/redis'
  runner 'sudo apt-get update'
  verify do
    has_file "/etc/apt/sources.list.d/rwky-redis-#{$UBUNTU_VERSION}.list"
  end
end
