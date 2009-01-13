module ClassToProc
  def to_proc
    proc(&method(:new))
  end
end
