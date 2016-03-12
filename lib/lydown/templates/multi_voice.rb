beaming_mode = Lydown::Rendering::Staff.beaming_mode(context, 
  context.current_setting_opts)
voice_prefix = part.nil? || (part == "") ? nil : "#{part}_"

`
<<
`

context['process/voices'].each do |voice, stream|
  `
  {{? voice != 'voice1' }}
    \new Voice = "{{voice_prefix}}{{voice}}"
  {{/}}

  {
    {{beaming_mode}}
    {{Lydown::Rendering::VoiceSelect.voice_command(voice)}}
    {{stream['music']}}
  }
  `
end
`
>>
\oneVoice 
`