require 'erb'

module Lydown
  module Templates
    TEMPLATES_DIR = File.join(File.dirname(__FILE__), 'templates')
    
    @@templates = {}
    
    def self.render(name, ctx, locals = {})
      _binding = ctx.respond_to?(:template_binding) ? ctx.template_binding(locals) : binding
      template(name).result(_binding)
    end
    
    def self.template(name)
      @@templates[name] ||= load_template(name)
    end
    
    def self.load_template(name)
      ERB.new IO.read(File.join(TEMPLATES_DIR, "#{name}.erb")), 0, '<>'
    end
  end
  
  module TemplateBinding
    # Used to bind to instance when rendering templates
    def template_binding(locals = {})
      b = binding
      locals.each {|k, v| b.local_variable_set(k.to_sym, v)}
      b
    end
  end
end