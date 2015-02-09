module I18n
  module Backend
    module Base
      def load_yml(filename)
        begin
          YAML.load(File.open(filename, 'r:utf-8').read)
        rescue TypeError
          nil
        rescue SyntaxError
          nil
        end
      end
    end
  end
end
