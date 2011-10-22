class Proc

  def arguments
    parameters.map {|x| x[1]}
  end
  
  alias :value :call
  
end