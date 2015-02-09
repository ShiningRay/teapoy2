# coding: utf-8
package :build_essential do
  description 'Build tools'
  apt 'build-essential' do
    pre :install, 'sudo apt-get update'
  end
  requires :dns
  verify do
    %w(gcc g++ make).each{|f| has_executable f}

  end
end

package :dns do
  dns = <<dns
nameserver 8.8.8.8
nameserver 8.8.4.4
nameserver 208.67.222.222
nameserver 208.67.220.220
dns
  push_text dns, '/etc/resolv.conf', :sudo => true
  verify do
    dns.split.each do |l|
      file_contains '/etc/resolv.conf', l
    end
  end
end

package :libpcre do
  apt 'libpcre3-dev'
end

package :zlib do
  apt 'zlib1g-dev'
end

package :libcurl do
  apt 'libcurl4-openssl-dev'
end

# net.ipv4.tcp_slow_start_after_idle = 0