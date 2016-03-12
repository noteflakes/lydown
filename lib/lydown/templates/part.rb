render_mode = context.render_mode

setting_opts = {movement: movement_name, part: name}

inline_part_title = nil
if name && (name != '')
  part_title = Lydown::Rendering::Staff.part_title(context, setting_opts)
  voice_prefix = "#{name}_"
else
  part_title = "#\"\""
  voice_prefix = nil
end
staff_id = Lydown::Rendering::Staff.staff_id(name)

score_mode = render_mode == :score

clef = Lydown::Rendering::Staff.clef(context, setting_opts)
prevent_remove_empty = Lydown::Rendering::Staff.prevent_remove_empty(context, setting_opts)

midi_mode = (context['render_opts/format'] == 'midi') ||
            (context['render_opts/format'] == 'mp3')
midi_instrument = midi_mode && Lydown::Rendering::Staff.midi_instrument(name)

beaming_mode = Lydown::Rendering::Staff.beaming_mode(context, setting_opts)
partial = context.get_setting(:pickup, setting_opts)
partial = partial ? "\\partial #{partial}" : ""

end_barline = Lydown::Rendering::Staff.end_barline(context, setting_opts)

time = context.get_setting(:time, setting_opts)
cadenza = time == 'unmetered'

skip_bars = (render_mode == :proof) || (render_mode == :part)

instrument_names = context.get_setting(:instrument_names, setting_opts)
hide_instrument_names = 
  (instrument_names == 'hide') || 
  (instrument_names =~ /^inline\-?(.+)?$/)
  
if instrument_names =~ /^inline\-?(.+)?$/
  alignment = $1 && "\\#{$1}"
  inline_part_title = Lydown::Rendering::Staff.inline_part_title(
    context, setting_opts.merge(alignment: alignment)
  )
end

`
<<

\new Staff = {{staff_id}} \with {
  {{? prevent_remove_empty }}
    \override VerticalAxisGroup.remove-empty = ##f
  {{/}}
  
  {{? size = context.get_setting(:staff_size, setting_opts)}}
    fontSize = #{{ size }}
    \override StaffSymbol.staff-space = #(magstep {{ size }})
  {{/}}

}

\context Staff = {{staff_id}} {
  {{? skip_bars }}
    \set Score.skipBars = ##t
  {{/}}
    
  {{? tempo = context.get_setting(:tempo, setting_opts)}}
    \tempo "{{tempo}}"
  {{/}}

  {{? score_mode && !hide_instrument_names}}
    \set Staff.instrumentName = {{part_title}}
  {{/}}

  {{? midi_instrument}}
    \set Staff.midiInstrument = #"{{midi_instrument}}"
  {{/}}

  {{? clef}}
    \clef "{{clef}}"
  {{/}}

  {{partial}}

  {{? score_mode && inline_part_title}}
    {{inline_part_title}}
  {{/}}
  
  {{beaming_mode}}

  \{{Lydown::Rendering.variable_name(setting_opts.merge(stream: :music))}}

  {{? end_barline}}
    \bar "{{end_barline}}"
  {{/}}
}
`

if part['lyrics']
  multi_voice = part['lyrics'].size > 1
  part['lyrics'].each_key do |voice|
    above_staff = multi_voice && ['voice1', 'voice3'].include?(voice)
    part['lyrics'][voice].keys.sort.each do |idx|
      var_name = Lydown::Rendering.variable_name(setting_opts.merge(
        stream: :lyrics, voice: voice, idx: idx))
      `
      \new Lyrics 
      {{? above_staff}}
        \with { alignAboveContext = "{{staff_id}}" }
      {{/}}
      { \lyricsto "{{voice_prefix}}{{voice}}" { \{{var_name}} } }
      `
    end
  end
end

if part['figures']
  var_name = Lydown::Rendering.variable_name(setting_opts.merge(stream: :figures))
  `
  \new FiguredBass { \{{var_name}} }
  `
end

`
>>
`
 