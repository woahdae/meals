# copied from ruby-debug-core
module Kernel

  # Enters the debugger in the current thread after _steps_ line events occur.
  # Before entering the debugger startup script is read.
  #
  # Setting _steps_ to 0 will cause a break in the debugger subroutine
  # and not wait for a line event to occur. You will have to go "up 1"
  # in order to be back in your debugged program rather than the
  # debugger. Settings _steps_ to 0 could be useful you want to stop
  # right after the last statement in some scope, because the next
  # step will take you out of some scope.

  # If a block is given (and the debugger hasn't been started, we run the 
  # block under the debugger. Alas, when a block is given, we can't support
  # running the startup script or support the steps option. FIXME.
  def debugger(steps = 1, &block)
    if block
      Debugger.start({}, &block)
    else
      Debugger.start unless Debugger.started?
      Debugger.run_init_script(StringIO.new)
      if 0 == steps
        Debugger.current_context.stop_frame = 0
      else
        Debugger.current_context.stop_next = steps
      end
    end
  end
  alias breakpoint debugger unless respond_to?(:breakpoint)
  
  #
  # Returns a binding of n-th call frame
  #
  def binding_n(n = 0)
    Debugger.skip do
      Debugger.current_context.frame_binding(n+2)
    end
  end
end
