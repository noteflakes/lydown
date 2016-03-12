`
\version "2.18.2"

{{? !context['render_opts/no_lib']}}
\pinclude "{{File.join(LY_LIB_DIR, 'lib.ly')}}"
{{/}}
`

packages = Lydown::Rendering.packages_to_load(context, {})
packages.each do |p|
`
\require "{{p}}"
`
end

includes = Lydown::Rendering.include_files(context, {})
includes.each {|i| __emit__[i]}

if context.render_mode == :proof
  __emit__[Lydown::Rendering::PROOFING_LY_SETTINGS]
end

unless context['render_opts/no_layout']
  __render__(:layout, _)
end

__render__(:variables, _)

`
\book {
  \header {
  }

  \bookpart {
`

  context['movements'].each do |n, m|
    __render__(:movement, context: context, name: n, movement: m)
  end
  
`
  }
}
`