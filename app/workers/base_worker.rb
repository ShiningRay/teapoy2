# coding: utf-8
class BaseWorker
  class << self
    def method_missing(selector, *args, &block)
      if selector.to_s =~ /^async_(\w+)/
        if method_defined? $1
          new.delay.__send__ $1, *args, &block
        else
          super
        end
      else
        super
      end
    end
  end
end