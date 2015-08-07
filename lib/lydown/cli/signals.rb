module Lydown::CLI
  @@abortable_child_processes = []
  
  def self.abort
    $stderr.puts
    if pid = @@abortable_child_processes.last
      Process.kill("INT", pid)
    else
      exit
    end
  end
  
  def self.register_abortable_process(pid)
    @@abortable_child_processes << pid 
  end
  
  def self.unregister_abortable_process(pid)
    @@abortable_child_processes.delete pid
  end
end

Signal.trap("INT") {Lydown::CLI.abort}
Signal.trap("TERM") {exit}
