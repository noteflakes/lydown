`
\version "2.18.2"

{{? context.render_mode}}
#(define lydown:render-mode '{{context.render_mode}})
{{/}}

{{? !context['render_opts/no_lib']}}
\pinclude "{{File.join(LY_LIB_DIR, 'lib.ly')}}"
{{/}}
`

Lydown::Rendering.get_set_variables(context).each do |k, v|
`
#(define lydown:{{k}} {{v}})
`
end

proof_mode = context.render_mode == :proof

includes = Lydown::Rendering.include_files(context, {})
includes.each {|i| __emit__[i, " "]}

if proof_mode
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

work = context.get_setting('work', {}) || {}
markup = lambda {|m| Lydown::Rendering::Markup.convert(m) }
part_title =  (context.render_mode == :part) &&
              (part = context['render_opts/parts']) &&
              Lydown::Rendering::Staff.heading_part_title(context, part: part)
doc_page_break = (context.render_mode == :part) ?
  context.get_setting("parts/#{context['render_opts/parts']}/document/page_break", {}) :
  context.get_setting("#{context.render_mode}/document/page_break", {})

`
{{? !proof_mode}}
\book {
{{/}}
  {{?doc_page_break == 'blank page before'}}
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
    {{?t = work[:edition]}}edition = {{markup[t]}}{{/}}
    {{?part_title}}instrument = {{markup[part_title]}}{{/}}
  }

  {{? !proof_mode}}
  \bookpart {
  {{/}}

  {{?doc_page_break == 'before'}}
  \pageBreak
  {{/}}

  {{?doc_page_break == 'blank page before'}}
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
{{? !proof_mode}}
} }
{{/}}
`
