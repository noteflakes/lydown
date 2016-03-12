module Lydown::Rendering
  class VoiceSelect < Base
    def translate
      if @event[:voice]
        @context['process/voice_selector'] = "voice#{@event[:voice]}"
      else
        self.class.render_voices(@context)
      end
    end
    
    def self.render_voices(context)
      context['process/voice_selector'] = nil
      
      music = Inverso::Template.render(:multi_voice, context: context, part: context[:part])
      
      context.emit(:music, music)
      
      context['process/voices'].each_value do |stream|
        if stream['lyrics']
          stream['lyrics'].each do |voice, lyrics_stream|
            lyrics_stream.each do |idx, content|
              context.emit("lyrics/#{voice}/#{idx}", content)
            end
          end
        end
      end
      
      context['process/voices'] = nil
    end
    
    VOICE_COMMANDS = {
      'voice1' => '\voiceOne',
      'voice2' => '\voiceTwo',
      'voice3' => '\voiceThree',
      'voice4' => '\voiceFour',
    }
    
    def self.voice_command(voice)
      VOICE_COMMANDS[voice]
    end
  end
end
