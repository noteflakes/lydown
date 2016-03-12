info = Lydown::Rendering.layout_info(context)
return unless info

layout = Lydown::Rendering::Layout

`
\paper {
  %{{layout.define_paper_size(info)}}
  %#(layout-set-staff-size {{layout.to_pp(info[:staff_size])}})
}

\layout {
}
`
