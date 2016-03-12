render_mode = context.render_mode
staff_groups = Lydown::Rendering::Staff.staff_groups(
  context, {movement: name}, movement['parts'].keys)
parts_in_order = staff_groups.flatten
staff_hierarchy = Lydown::Rendering::Staff.staff_hierarchy(staff_groups)
  
parts = parts_in_order.inject({}) do |m, p|
  m[p] = movement['parts'][p]
  m
end

score_mode = (render_mode == :score) || 
  (render_mode == :proof) || (parts.size > 1)

tacet = Lydown::Rendering::Movement.tacet?(context, name)
movement_title = Lydown::Rendering::Movement.movement_title(context, name)
movement_source = context.get_setting(:movement_source , movement: name)

format = context['options/format'] || context['render_opts/format'] || :pdf
midi_mode = (format == :midi) || (format == :mp3)

empty_staves = context.get_setting(:empty_staves, movement: name)

page_breaks = Lydown::Rendering::Movement.page_breaks(context, movement: name)

includes = Lydown::Rendering.include_files(context, movement: name)

packages = Lydown::Rendering.packages_to_load(context, movement: name)

hide_bar_numbers = Lydown::Rendering::Movement.hide_bar_numbers?(
  context, movement: name
)

if page_breaks[:blank_page_before]
`
} \bookpart {
  \markup \column {
  \null \null \null \null \null \null
  \null \null \null \null \null \null
  \null \null \null \null \null \null
  \null \null \null \null \null \null
  \fill-line { "(this page has been left blank to facilitate page turning)" } 
  }
} \bookpart {
\pageBreak
`
elsif page_breaks[:before]
`
} \bookpart {
`
end

packages.each do |p|
`
\require "{{p}}"
`
end

includes.each do |i|
`
{{i}}
`
end

unless tacet
  `
  \score {
  `
  if movement_title && render_mode != :proof
    `
      \header { 
        piece = \markup { 
          \bold \large { {{movement_title}} } 
          {{?movement_source}}
            \hspace #1 \italic { {{movement_source}} }
          {{/}}
        }
      }
    `
  end
  
  if score_mode
    `
    {{?empty_staves == 'hide'}}
    \layout {
      \context {
        \RemoveEmptyStaffContext
        \override VerticalAxisGroup #'remove-first = ##t
      }
    }      
    {{/}}
    
    \new StaffGroup <<
      \set StaffGroup.systemStartDelimiterHierarchy = {{staff_hierarchy}}
    `
  end
    
  if n = movement['bar_number']
    `
    \set Score.currentBarNumber = #{{n}}
    \set Score.barNumberVisibility = #all-bar-numbers-visible
    \bar ""
    `
  end
      
  parts.each do |n, p|
    __render__(:part, context: context, 
      name: n, part: p, movement: movement, movement_name: name)
  end
  
  if score_mode
    `
    >>
    `
  end

  if midi_mode
    `
    \midi {
      {{? tempo = context.get_setting(:midi_tempo, movement: name)}}
        \tempo {{tempo}}
      {{/}}
    }
    `
  end
    
  if hide_bar_numbers
    `
    \layout {
      \context {
        \Score
        \omit BarNumber
      }
    }
    `
  end

  `
  }
  `
else # tacet %>
`
  \markup { 
    \line { \bold \large { {{movement_title}} } }
    \line { \pad-markup #3 " " }
    
  }
`
end

if page_breaks[:after]
`
\pageBreak
`
end
  
  
  
