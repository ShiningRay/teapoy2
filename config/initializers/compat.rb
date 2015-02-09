#-*- coding:utf-8 -*-
#require 'html5-boilerplate'
def ip2long(ip)
  a = 0
  b = 24
  ip.split('.').each do |c|
    a += (c.to_i << b)
    b -= 8
  end
  a
end
def long2ip(ip)
  a = []
  while ip > 0
    a << (ip & 0xFF)
    ip >>= 8
  end
  a.reverse.join('.')
end

class String
  def rot13
    tr "A-Za-z", "N-ZA-Mn-za-m";
  end
  def rot13!
    tr! "A-Za-z", "N-ZA-Mn-za-m";
  end
end
unless defined?(ap)
  def ap *args

  end
end
