info = Lydown::Rendering.layout_info(context)
return unless info

layout = Lydown::Rendering::Layout

pp  = lambda {|k| layout.to_pp(info[k])}
m   = lambda {|k, d = nil| layout.fmt(info[k] || d)}
v   = lambda {|k| layout.to_v(info[k])}

vertical_margins = layout.calculate_vertical_margins(info).join(" ")
`
\paper {
  {{?false}}
  annotate-spacing = ##t
  {{/}}

  {{layout.define_paper_size(info)}}
  #(layout-set-staff-size {{pp[:staff_size]}})

  %indent = {{m[:indent, '0mm']}}

  {{?info[:margin_inner]}}
  two-sided = ##t
  inner-margin = {{m[:margin_inner]}}
  outer-margin = {{m[:margin_outer]}}
  binding-offset = 0\mm
  {{/}}

  top-margin = {{m[:margin_top]}}
  bottom-margin = {{m[:margin_bottom]}}
}
\setVerticalMargins {{vertical_margins}}

\layout {
  \context {
    \Score
    \remove "Bar_number_engraver"
  }
}
`
