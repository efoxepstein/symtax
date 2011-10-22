include RKelly::Nodes 

class Node
	attr_accessor :depth
	
	def self.duration_impact ; 0 ; end
	def self.adds_depth? ; false ; end

  def orchestrate_self(delay, conductor, opts)
    # conductor.enqueue()
  end

	def orchestrate(delay, conductor, opts = {})
	  puts "Orchestrating #{self.class.name}, delay #{delay}"
	  orchestrate_self(delay, conductor, opts)
        
    delay += self.class.duration_impact
    for child in children
      if Node === child
        child.orchestrate(delay, conductor)
        delay += child.duration
      end
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
		(instance_variables - [:@comments, :@line, :@filename]).map {|x| Array(instance_variable_get(x)) }.flatten
	end
end

module Useful
  def duration_impact ; 4 ; end
	def adds_depth? ; true  ; end
end


class IfNode
  extend Useful
  
  def orchestrate_self(delay, conductor, opts)
    notes = [[0,   0.5],
             [nil, 0.5],
             [2, 0.5],
             [0, 0.25],
             [0, 0.25],
             [nil, 1],
             [5, 1]]
    conductor.enqueue(:guitar, notes, 4, 4, duration, delay, height)
  end
  
  def children
    Array(@conditions) + Array(@value) + Array(@else)
  end
end
class Conditional
  extend Useful
  
  def orchestrate_self(delay, conductor, opts)
    conductor.enqueue(:guitar, [[9, 1.5], [9, 0.25] [2, 0.5], [0, 0.25], [nil, 1], [5, 0.5]], 4, 4, duration, delay, height)
  end
  
  def children
    Array(@conditions) + Array(@value) + Array(@else)
  end
end

EmptyStatementNode.extend Useful

def value_only(klazz, &blk)
  klazz.extend Useful
  klazz.send :define_method, :orchestrate_self, &blk
end

def binary(other = :@left, *klazzes, &blk)
  for klazz in klazzes
    klazz.extend Useful
    def klazz.children
      Array(instance_variable_get(other)) + Array(@value)
    end
    klazz.send :define_method, :orchestrate_self, &blk
  end
end

value_only TrueNode do |delay, conductor, opts|
  conductor.enqueue(:moog, [[0, 1], [4, 1], [7, 1], [0, 1]], 4, 4, duration, delay, height)
end

value_only FalseNode do |delay, conductor, opts|
  conductor.enqueue(:moog, [[7, 1], [4, 1], [2, 1], [7, 1]], 4, 4, duration, delay, height)
end

value_only DeleteNode do |delay, conductor, opts| 
  conductor.enqueue(:guitar, [[2, 4]], 2, 4, duration, delay, height)
end

value_only ReturnNode do |delay, conductor, opts|
  conductor.enqueue(:sinmix, [[7, 1], [5, 1], [4, 1], [2, 0.5], [0, 1]], 4, 4, duration, delay, height)
end

value_only TypeOfNode do |delay, conductor, opts|
  conductor.enqueue(:sawsaw, [[0, 0.5], [4, 0.5], [0, 0.5], [4, 0.5], [2, 0.5], [7, 0.5], [2, 0.5], [7,0.5]], 5, 4, duration, delay, height)
end

value_only ThrowNode do |delay, conductor, opts|
  conductor.enqueue(:sinmix, [[7, 1], [4, 1], [2, 1], [4, 1]], 6, 4, duration, delay, height)
end

value_only UnaryMinusNode do |delay, conductor, opts|
  conductor.enqueue(:sinmix, [[nil, 0.5], [4, 0.5], [nil, 0.25], [5, 0.25], [7, 0.25], [9, 0.25], [nil, 1], [12, 1]], 4, 4, duration, delay, height)
end

value_only ElementNode do |delay, conductor, opts|
  conductor.enqueue(:sinmix, [[2, 0.25], [nil, 0.25], [4, 0.25], [nil, 0.25], [nil, 0.25], [7, 0.25], [9, 0.5], [12, 1]], 4, 4, duration, delay, height)
end

value_only NullNode do |delay, conductor, opts|
  conductor.enqueue(:piano2, [[9, 1], [7, 1], [2, 1], [0, 1]], 4, 4, duration, delay, height)
end

value_only ThisNode do |delay, conductor, opts|
  conductor.enqueue(:moog, [[0, 0.25], [4, 0.25], [7, 0.25], [9, 0.25], [12, 0.25], [7,0.25], [5, 0.25], [4, 0.25], [4, 1], [7, 1]], 4, 4, duration, delay, height)
end

value_only ArrayNode do |delay, conductor, opts|
  conductor.enqueue(:guitar, [[7, 1], [5, 1], [4, 1], [2, 1]], 4, 4, duration, delay, height)
end

value_only ContinueNode do |delay, conductor, opts|
  conductor.enqueue(:moog, [[7, 0.5], [nil, 0,5] [7, 1], [nil, 1], [nil, 1]], 4, 4, duration, delay, height)
end

value_only BreakNode do |delay, conductor, opts|
  conductor.enqueue(:sinmix, [[0, 0.5], [0, 0.5], [0, 0.5], [0, 0.5], [7, 0.5], [7, 0.5], [7, 0.5], [7, 0.5]], 4, 4, duration, delay, height)
end

value_only ParameterNode do |delay, conductor, opts|
  conductor.enqueue(:piano2, [[7, 1], [4, 1], [3, 1], [7, 1]], 4, 4, duration, delay, height)
end

value_only ObjectLiteralNode do |delay, conductor, opts|
  conductor.enqueue(:sawsaw, [[0, 0.75], [5, 0.25], [2, 0.75], [7, 0.25], [4, 0.75], [9, 0.25], [5, 0.75], [12, 0.25]], 4, 4, duration, delay, height)
end
  
value_only SourceElementsNode do |delay, conductor, opts| 
  conductor.enqueue(:moog, [[0, 1], [7, 1], [12, 1], [4, 1]], 2, 4, duration, delay, height)
end

value_only VarStatementNode do |delay, conductor, opts|
  conductor.enqueue(:sinmix, [[12, 0.25], [5, 0.75], [9, 0.25], [4, 0.75], [7, 0.25], [2, 0.75], [7, 0.25], [0, 0.75]], 4, 4, duration, delay, height)
end

binary CaseClauseNode do |delay, conductor, opts|
  conductor.enqueue(:guitar, [[9, 0.25], [7, 0.25], [5, 0.5], [12, 2]], 4, 4, duration, delay, height)
end

binary SwitchNode do |delay, conductor, opts|
  conductor.enqueue(:piano2, [[nil, 2], [5, 0.5], [4, 0.25], [0, 0.25]], 3, 4, duration, delay, height)
end

binary DoWhileNode do |delay, conductor, opts|
  conductor.enqueue(:sawsaw, [[7, 1], [4, 1], [2, 1], [0, 0.5], [7, 0.5]], 3, 4, duration, delay, height)
end

binary InNode do |delay, conductor, opts|
  conductor.enqueue(:sawsaw, [[5, 1], [4, 1], [2, 1], [7, 1]], 6, 4, duration, delay, height)
  
end


binary InstanceOfNode do |delay, conductor, opts|
  conductor.enqueue(:moog, [[nil, 0.5], [0, 0.5], [nil, 0.5], [nil, 0.5], [7, 0.5], [5, 1]], 5, 4, duration, delay, height)
end

binary WhileNode, WithNode do |delay, conductor, opts|
  conductor.enqueue(:moog, [[12, 1], [4, 0.5], [2, 0.5], [7, 1], [12, 1]], 3, 4, duration, delay, height)
end


binary :@name, LabelNode do |delay, conductor, opts|
  conductor.enqueue(:sawsaw, [[0, 1], [0, 1], [0, 1], [0, 1]], 4, 4, duration, delay, height)
end
  
binary :@name, PropertyNode do |delay, conductor, opts|
  conductor.enqueue(:sawsaw, [[7, 1], [7, 1], [7, 1], [2, 0.25], [4, 0.25], [5,0.25]], 4, 4, duration, delay, height)
end

binary :@name, VarDeclNode do |delay, conductor, opts|
  conductor.enqueue(:sinosc, [[0, 0.5], [0, 0.5], [5, 0.25], [7, 0.25], [nil, 1], [12, 1]], 5, 4, duration, delay, height)
end

binary :@name, PostfixNode do |delay, conductor, opts|
  conductor.enqueue(:sinosc, [[0, 1], [4, 1], [7, 1], [5, 1]], 5, 4, duration, delay, height)
end
  
binary :@name, PrefixNode do |delay, conductor, opts|
  conductor.enqueue(:sinosc, [[5, 1], [7, 1], [4, 1], [0, 1]], 5, 4, duration, delay, height)
end


class FunctionCallNode
  extend Useful
  
  def children
    Array(@value) + Array(@arguments)
  end
  
  def orchestrate_self(delay, conductor, opts)
    conductor.enqueue(:sawsaw, [[7, 1], [4, 1], [3, 1], [7, 1]], 4, 4, duration, delay, height)
    
  end
end

class FunctionDeclNode
  extend Useful
  
  def children
    Array(@value) + Array(@arguments) + Array(@function_body)
  end
  
  def orchestrate_self(delay, conductor, opts)
    conductor.enqueue(:sawsaw, [[7, 1], [4, 1], [3, 1], [7, 1]], 4, 4, duration, delay, height)
    
  end
end

