require 'ruby-progressbar'

module Lydown::CLI
  # Simple wrapper around ProgressBar
  def self.show_progress(title, total)
    $progress_bar = ProgressBar.create(
      title: title,
      total: total
    )
    yield $progress_bar
  ensure
    $progress_bar.stop
    $progress_bar = nil
  end
end