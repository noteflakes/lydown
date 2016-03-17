`
\version "2.18.2"

#(define lydown:render-mode '{{context.render_mode}})

{{? !context['render_opts/no_lib']}}
\pinclude "{{File.join(LY_LIB_DIR, 'lib.ly')}}"
{{/}}
`

includes = Lydown::Rendering.include_files(context, {})
includes.each {|i| __emit__[i]}

if context.render_mode == :proof
  __emit__[Lydown::Rendering::PROOFING_LY_SETTINGS]
end

unless context['render_opts/no_layout']
  __render__(:layout, _)
end

packages = Lydown::Rendering.packages_to_load(context, {})
packages.each do |p|
`
\require "{{p}}"
`
end

__render__(:variables, _)

work = context['global/settings/work']
part_title =  (context.render_mode == :part) && 
              (part = context['render_opts/parts']) &&
              Lydown::Rendering::Staff.qualified_part_title(context, part: part)
              
markup = lambda {|m| Lydown::Rendering::Markup.convert(m) }
`
\book {
  \header {
    {{?t = work[:composer]}}composer = {{markup[t]}}{{/}}
    {{?t = work[:opus]}}opus = {{markup[t]}}{{/}}
    {{?t = work[:title]}}title = {{markup[t]}}{{/}}
    {{?t = work[:subtitle]}}subtitle = {{markup[t]}}{{/}}
    {{?t = work[:source]}}source = {{markup[t]}}{{/}}
    {{?part_title}}instrument = {{markup[part_title]}}{{/}}
    {{?context.render_mode == :score}}score-mode = ##t{{/}}
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