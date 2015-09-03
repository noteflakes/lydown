\version "2.18.2"

ldMusic = \relative c {
  <<
    \new Voice = "voice1" {
      R1*1
      
      <<
        {
          \voiceOne
          r4 e' g r
        }

        \new Voice = "voice2" {
          \voiceTwo
          c2 b4 r
        }
      >>
    
      \oneVoice
      R1*2
      c4 b a g
    }
  >>
}
ldLyricsVoiceOneI = \lyricmode {
  Bin ich's?
  Nein ja nein ja
}
ldLyricsVoiceTwoI = \lyricmode {
  Ja ja!
}
ldLyricsVoiceTwoII = \lyricmode {
  Nei nei
}

\book {
  \header {
  }

  \bookpart { 
    \score {
      <<
      \new Staff = Staff \with { }
      \context Staff = Staff {
        \ldMusic
      }
      \new Lyrics \with { alignAboveContext = "Staff" } {
        \lyricsto "voice1" { \ldLyricsVoiceOneI }
      }

      \new Lyrics {
        \lyricsto "voice2" { \ldLyricsVoiceTwoI }
      }

      \new Lyrics {
        \lyricsto "voice2" { \ldLyricsVoiceTwoII }
      }
      >>
    }
  }
}
