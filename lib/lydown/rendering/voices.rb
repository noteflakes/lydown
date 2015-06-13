module Lydown::Rendering
  class VoiceSelect < Base
    def translate
      if @event[:voice]
        @work['process/voice_selector'] = "voice#{@event[:voice]}"
      else
        self.class.render_voices(@work)
      end
    end
    
    def self.render_voices(work)
      work['process/voice_selector'] = nil
      
      music = Lydown::Templates.render(:multi_voice, work, part: work[:part])
      
      work.emit(:music, music)
      
      work['process/voices'].each_value do |stream|
        if stream['lyrics']
          stream['lyrics'].each do |voice, lyrics_stream|
            lyrics_stream.each do |idx, content|
              work.emit("lyrics/#{voice}/#{idx}", content)
            end
          end
        end
      end
      
      work['process/voices'] = nil
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
