module Lydown::Rendering
  class << self
    SKIP_ON_CMD = {type: :command, key: 'set', arguments: ['Score.skipTypesetting = ##t']}
    SKIP_OFF_CMD = {type: :command, key: 'set', arguments: ['Score.skipTypesetting = ##f']}
    
    BARLINE = {type: :barline, barline: '|'}
    BAR_NUMBERS_CMD = {type: :command, key: 'set', arguments: ['Score.barNumberVisibility = #all-bar-numbers-visible']}
    
    HIGHLIGHT_NOTES_CMD = {type: :command, key: 'override', arguments: ['NoteHead.color = #red']}
    NORMAL_NOTES_CMD = {type: :command, key: 'override', arguments: ['NoteHead.color = #black']}

    def insert_skip_markers(stream, line_range)
      # find indexes of first and last changed lines
      changed_first_idx = find_line_idx(stream, line_range.first)
      changed_last_idx =  find_line_idx(stream, line_range.last, true)
      
      # find index of first line to include
      start_line = line_range.first - 2; start_line = 0 if start_line < 0
      start_idx = find_line_idx(stream, start_line)
      
      if changed_last_idx
        stream.insert(changed_last_idx + 1, NORMAL_NOTES_CMD)
      end
      
      if changed_first_idx
        stream.insert(changed_first_idx, BARLINE)
        stream.insert(changed_first_idx, BAR_NUMBERS_CMD)
        stream.insert(changed_first_idx, HIGHLIGHT_NOTES_CMD)
      end
      
      if start_line > 0 && start_idx
        stream.insert(start_idx, SKIP_OFF_CMD)
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
