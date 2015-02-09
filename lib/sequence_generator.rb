# coding: utf-8
module SequenceGenerator
  class BaseGenerator
    attr_accessor :options
    def initialize(options={})
      self.options = options
    end

    def next_id(scope)
      raise 'Not Implemented'
    end
  end

  class DatabaseSequenceGenerator < BaseGenerator
    attr_accessor :connection, :table_name, :scope_column
    def initialize(options={})
      super options.reverse_merge(:table_name => 'sequences')
      self.connection = options[:connection]
      self.table_name = options[:table_name]=connection.sanitize(options[:table_name])
      self.scope_column=options[:scope_column]=connection.sanitize(options[:scope_column])
      self.counter_column=options[:counter_column]=connection.sanitize(options[:counter_column])
    end
  end

  class MyISAM < DatabaseSequenceGenerator
    def next_id(scope)
      connection.execute "INSERT INTO #{options[:table_name]} (`#{options[:scope_column]}`) VALUES(#{scope})"
      connection.select_value "SELECT last_insert_id()"
    end

    def zap_sequence!
      connection.execute 'delete from `comment_sequence` using comment_sequence left join (SELECT article_id, max(floor) as mf FROM `comment_sequence` WHERE 1 group by article_id) as st on comment_sequence.article_id = st.article_id where comment_sequence.floor < st.mf'
    end
  end
  class Memcache < BaseGenerator
    def initialize(options={})
      super(options.reverse_merge(:scope))
    end

    def next_id(scope)
      memcache.inc()
    end
  end

  class Mongodb < DatabaseSequenceGenerator
    def initialize(options={})
      super options
    end
    def next_id(scope)
      connection
    end
  end
end
