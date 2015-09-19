module Lydown::Rendering
  PROOFING_LY_SETTINGS = <<EOF
    \\paper {
      indent=0\\mm
      line-width=110\\mm
      oddFooterMarkup=##f
      oddHeaderMarkup=##f
      bookTitleMarkup = ##f
      scoreTitleMarkup = ##f
      page-breaking = #ly:minimal-breaking
    }
EOF
  
  class << self
    SKIP_GRACE = {type: :literal, content: "\\grace s8"}
    
    SKIP_ON_CMD = {type: :literal, content: "\\set Score.skipTypesetting = ##t"}
    SKIP_OFF_CMD = {type: :literal, content: "\\set Score.skipTypesetting = ##f"}

    SKIP_BARLINE = {type: :literal, content: "\\bar \"\""}
    SKIP_BAR_NUMBERS_CMD = {type: :literal, content: "\\override Score.BarNumber.break-visibility = ##(#t #t #t) \
      \\set Score.barNumberVisibility = #(every-nth-bar-number-visible 1)"}
    
    HIGHLIGHT_NOTES_CMD = {type: :literal, content: "\\override NoteHead.color = #red"}
    NORMAL_NOTES_CMD = {type: :literal, content: "\\override NoteHead.color = #black"}

    def insert_skip_markers(stream, line_range)
      # find indexes of first and last changed lines
      changed_first_idx = find_line_idx(stream, line_range[0])
      changed_last_idx =  find_line_idx(stream, line_range[1], true)
      
      # find index of first line to include
      start_line = line_range.first - 2; start_line = 0 if start_line < 0
      start_idx = find_line_idx(stream, start_line)
      
      # find index of last line to include
      end_line = line_range.last + 3
      end_idx = find_line_idx(stream, end_line)
      
      if end_idx && end_idx > changed_last_idx
        stream.insert(end_idx, SKIP_ON_CMD)
        stream.insert(end_idx, SKIP_GRACE)
      end
      
      if changed_last_idx
        stream.insert(changed_last_idx + 1, NORMAL_NOTES_CMD)
      end
      
      if changed_first_idx
        stream.insert(changed_first_idx, HIGHLIGHT_NOTES_CMD)
      end
      
      if start_line > 0 && start_idx
        # Insert an invisible barline (in order to show bar number for first
        # bar), and show bar numbers on every subsequent barline.
        stream.insert(start_idx, SKIP_BARLINE)
        stream.insert(start_idx, SKIP_BAR_NUMBERS_CMD)

        stream.insert(start_idx, SKIP_OFF_CMD)
        # "Help" lilypond correctly render rhythms when skipping on/off by
        # inserting a silent grace note.
        # See https://code.google.com/p/lilypond/issues/detail?id=1543&q=skiptypesetting&colspec=ID%20Type%20Status%20Stars%20Owner%20Patch%20Needs%20Summary
        stream.insert(start_idx, SKIP_GRACE)

        # Skip beginning
        stream.insert(0, SKIP_ON_CMD)
      end
    end
    
    # returns index of first event at or after specified line
    def find_line_idx(stream, line, last = false)
      if last
        stream.reverse_each do |e|
          return stream.index(e) if e[:line] && e[:line] <= line
        end
        nil
      else
        stream.index {|e| e[:line] && e[:line] >= line}
      end
    end
  end
end
