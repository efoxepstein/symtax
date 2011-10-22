include RKelly::Nodes 

class Node
	attr_accessor :depth
	
	def self.duration_impact ; 0 ; end
	def self.adds_depth? ; false ; end

  def orchestrate_self(delay, conductor, opts)
    # conductor.enqueue()
  end

	def orchestrate(delay, conductor, opts = {})
	  orchestrate_self(delay, conductor, opts)
    
    delay = 4
    for child in children
      child.orchestrate(delay, conductor)
      delay += child.duration
    end
	end

	# duration equals our constant duration + the duration of all of the children
	def duration
	  self.class.duration_impact + duration_of_children
	end
	
	# Set our duration of children(doc) value equal to the RKelly node value.
	# For our array object value, we define the result(m) and element(c)
	# c is a children of Node, so we're accessing its duration and summing it.
	# and finally this is a 
	def duration_of_children
	  @doc ||= children.inject(0) do |m, node|
		  m + (RKelly::Nodes::Node === node ? node.duration : 0)
	  end
	end
	
	# see how many children we have
	def height
		@height ||= begin
		  children.map {|x| RKelly::Nodes::Node === x ? x.height : 0 }.max.to_i + 
		    (self.class.adds_depth? ? 1 : 0)
		end
	end
	
	def children
		(instance_variables - [:@comments, :@line, :@filename]).map {|x| Array(instance_variable_get(x))}.flatten
	end
end

module Useful
  def duration_impact ; 4 ; end
	def adds_depth? ; true  ; end
end

class IfNode < Node
  extend Useful
  
  def orchestrate_self ; end
  
  def children
    Array(@conditions) + Array(@value) + Array(@else)
  end
end