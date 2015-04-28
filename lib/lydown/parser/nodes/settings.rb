module Lydown::Parsing
  module SettingNode
    include LydownNode
    
    def to_stream(stream)
      @setting = {type: :setting}
      _to_stream(self, stream)
    end
    
    def setting
      @setting
    end
    
    def emit_setting(stream)
      stream << @setting
    end
    
    module Key
      def to_stream(stream)
        parent.setting[:key] = text_value
      end
    end
    
    module Value
      def to_stream(stream)
        parent.setting[:value] = text_value.strip
        parent.emit_setting(stream)
      end
    end
  end
end