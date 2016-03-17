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

work = context.get_setting('work', {})

part_title =  (context.render_mode == :part) && 
              (part = context['render_opts/parts']) &&
              Lydown::Rendering::Staff.heading_part_title(context, part: part)
              
markup = lambda {|m| Lydown::Rendering::Markup.convert(m) }

page_break = context.get_setting("#{context.render_mode}/document/page_break", {})

`
\book {
  {{?page_break == 'blank page before'}}
  \paper { 
     first-page-number = #-1 
  } 
  {{/}}
  
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
    
  {{?page_break == 'before'}}
  \pageBreak
  {{/}}
  
  {{?page_break == 'blank page before'}}
    \paper { oddHeaderMarkup = ##f evenHeaderMarkup = ##f }
    \markup " "
  } \bookpart {
    \paper { oddHeaderMarkup = ##f evenHeaderMarkup = ##f
      bookTitleMarkup = ##f } \markup { " " }
  } \bookpart { 
    \paper { bookTitleMarkup = ##f }
  {{/}}
`

  context['movements'].each do |n, m|
    __render__(:movement, context: context, name: n, movement: m)
  end
  
`
  }
}
`