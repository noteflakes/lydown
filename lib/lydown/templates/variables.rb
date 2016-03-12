var_name = lambda {|opts| Lydown::Rendering.variable_name(opts)}
context['movements'].each do |mvt_name, mvt|
  mvt['parts'].each do |part_name, part|
    var_opts = {movement: mvt_name, part: part_name}
    notation_size = context.get_setting(:notation_size, var_opts)
    notation_size = "\\#{notation_size}" if notation_size

    if part_name && !part_name.empty?
      voice_prefix = "#{part_name}_"
    else
      voice_prefix = nil
    end

    `
    {{var_name[var_opts.merge(stream: :music)]}} = \relative c {
      <<
        \new Voice = "{{voice_prefix}}voice1" {
          {{notation_size}}
          {{part['music']}}
        }
      >>
    }
    `
  
    if part['lyrics']
      part['lyrics'].each do |voice, voice_lyrics|
        voice_lyrics.each do |idx, lyrics|
          opts = var_opts.merge(stream: :lyrics, voice: voice, idx: idx)
          `
          {{var_name[opts]}} = \lyricmode { {{lyrics}} }
          `
        end
      end
    end

    if part['figures']
      `
      {{var_name[var_opts.merge(stream: :figures)]}} = 
        \figuremode { {{part['figures']}} }
      `
    end
  end
end 
