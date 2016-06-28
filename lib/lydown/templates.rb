require 'erb'

module Lydown
  module Templates
    TEMPLATES_DIR = File.join(File.dirname(__FILE__), 'templates')

    @@templates = {}

    def self.render(name, ctx, locals = {})
      _binding = ctx.respond_to?(:template_binding) ? ctx.template_binding(locals) : binding

      # remove trailing white space and superfluous new lines
      template(name).result(_binding).gsub(/^\s+$/, '').gsub(/\n+/m, "\n")
    end

    def self.template(name)
      @@templates[name] ||= load_template(name)
    end

    def self.load_template(name)
      fn = name.is_a?(Symbol) ?
        File.join(TEMPLATES_DIR, "#{name}.erb") :
        name

      ERB.new IO.read(fn), 0, '<>'
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
