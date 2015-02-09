# coding: utf-8
package :utils do
  requires :htop, :wget, :imagemagick, :libxml2, :python_software_properties
end
package :libxml2 do
  apt 'libxml2-dev libxslt-dev'
end
package :htop do
  apt 'htop'
end

package :wget do
  apt 'wget'
end

package :imagemagick do
  apt 'imagemagick'
  verify do
    has_executable 'convert'
    has_executable 'identify'
  end
end

package 'tokyocabinet' do
  apt 'libtokyocabinet'
end

package :python_software_properties do
  apt 'python-software-properties'
  verify do
    has_executable 'add-apt-repository'
  end
end

package 'newrelic' do
  'wget -O /etc/apt/sources.list.d/newrelic.list http://download.newrelic.com/debian/newrelic.list'
  'apt-key adv --keyserver hkp://subkeys.pgp.net --recv-keys 548C16BF'
  'apt-get update'
  'apt-get install newrelic-sysmond'
end