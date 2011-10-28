include RKelly::Nodes

class Node
	attr_accessor :depth
	
	class << self
	  attr_accessor :instrument, :private_duration
	end
	
  def self.duration_impact
    self.private_duration ||= 0
  end
	  
  def self.notes=(nts)
    @notes = nts
    self.private_duration = Array(nts).inject(0) do |m, (_, d)|
      m + d
    end
  end
    
  def self.notes ; @notes ||= [] ; end
    
  def self.name
    super[15..-1]
  end
	
	def self.adds_depth? ; false ; end

  def orchestrate_self(delay, conductor, opts)
    unless self.class.notes.empty?
      conductor.enqueue(self.class.name, self.class.instrument, self.class.notes, 4, 4, duration, delay, height)
    end
  end

	def orchestrate(delay, conductor, opts = {})
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
	def adds_depth?
	  true
	end
end

class IfNode
  extend Useful
  
  self.instrument = :guitar
  self.notes = [[0,   0.5],
                [nil, 0.5],
                [2,   0.5],
                [0,   0.25],
                [0,   0.25],
                [nil, 1],
                [5,   1]]
  
  def children
    Array(@conditions) + Array(@value) + Array(@else)
  end
end

class ConditionalNode
  extend Useful
  
  self.instrument = :guitar
  self.notes = [[9, 1.5], [9, 0.25], [2, 0.5], [0, 0.25], [nil, 1], [5, 0.5]]

  def children
    Array(@conditions) + Array(@value) + Array(@else)
  end
end

EmptyStatementNode.extend Useful

def value_only(klazz)
  klazz.extend Useful
  
  yield klazz
end

def binary(other = :@left, *klazzes)
  for klazz in klazzes
    klazz.extend Useful
    def klazz.children
      Array(instance_variable_get(other)) + Array(@value)
    end
    
    yield klazz
  end
end

value_only TrueNode do |ctx|
  ctx.instrument = :moog
  ctx.notes =  [[0, 0.5], [4, 0.5], [7, 0.5], [0, 0.5]] 
end

value_only FalseNode do |ctx|
  ctx.instrument = :moog
  ctx.notes =  [[7, 0.5], [4, 0.5], [2, 0.5], [0, 0.5]] 
end

value_only DeleteNode do |ctx| 
  ctx.instrument = :guitar
  ctx.notes =  [[2, 1]] 
end

value_only ReturnNode do |ctx|
  ctx.instrument = :sinmix
  ctx.notes =  [[7, 0.25], [5, 0.25]] 
end

value_only TypeOfNode do |ctx|
  ctx.instrument = :sawsaw
  ctx.notes =  [[0, 0.5], [4, 0.5], [0, 0.5], [4, 0.5], [2, 0.5], [7, 0.5], [2, 0.5], [7,0.5]] 
end

value_only ThrowNode do |ctx|
  ctx.instrument = :sinmix
  ctx.notes =  [[7, 0.25], [4, 0.25], [2, 0.25], [4, 0.25]] 
end

value_only UnaryMinusNode do |ctx|
  ctx.instrument = :sinmix
  ctx.notes =  [[nil, 0.5], [4, 0.5], [nil, 0.25], [5, 0.25], [7, 0.25], [9, 0.25]] 
end

value_only ElementNode do |ctx|
  ctx.instrument = :sinmix
  ctx.notes =  [[2, 0.25], [nil, 0.25], [4, 0.25], [nil, 0.25], [nil, 0.25], [7, 0.25], [9, 0.5], [12, 1]] 
end

value_only NullNode do |ctx|
  ctx.instrument = :piano2
  ctx.notes =  [[9, 0.25], [7, 0.25], [2, 0.25], [0, 0.25]] 
end

value_only ThisNode do |ctx|
  ctx.instrument = :moog
  ctx.notes =  
      [[0,  0.25],
       [4,  0.25],
       [7,  0.25],
       [9,  0.25]] 
end

value_only ArrayNode do |ctx|
  ctx.instrument = :guitar
  ctx.notes =  [[7, 0.5], [5, 0.5], [4, 0.5], [2, 0.5]] 
end

value_only ContinueNode do |ctx|
  ctx.instrument = :moog
  ctx.notes =  [[7, 0.5], [nil, 0,5], [7, 1], [nil, 1], [nil, 1]] 
end

value_only BreakNode do |ctx|
  ctx.instrument = :sinmix
  ctx.notes =  [[0, 0.5], [0, 0.5], [7, 0.5], [7, 0.5]] 
end

value_only ParameterNode do |ctx|
  ctx.instrument = :moog
  ctx.notes =  [[12, 0.5], [4, 0.5], [7, 0.5], [12, 0.5]] 
end

value_only ObjectLiteralNode do |ctx|
  ctx.instrument = :sawsaw, 
  ctx.notes = [[0, 0.75],
               [5, 0.25],
               [2, 0.75],
               [7, 0.25],
               [4, 0.75],
               [9, 0.25],
               [5, 0.75],
               [12, 0.25]] 
end
  
# value_only SourceElementsNode do |ctx| 
#   ctx.instrument = :sinosc
#  ctx.notes =  [[0, 1], [7, 1], [12, 1], [4, 1]] 
# end

value_only VarStatementNode do |ctx|
  ctx.instrument = :sinmix
  ctx.notes =  [[12, 0.25], [5, 0.75], [9, 0.25], [4, 0.75], [7, 0.25], [2, 0.75], [7, 0.25], [0, 0.75]] 
end

binary CaseClauseNode do |ctx|
  ctx.instrument = :guitar
  ctx.notes =  [[9, 0.25], [7, 0.25], [5, 0.5], [12, 2]] 
end

binary SwitchNode do |ctx|
  ctx.instrument = :piano2
  ctx.notes =  [ [5, 0.5], [4, 0.25], [0, 0.25]] 
end

binary DoWhileNode do |ctx|
  ctx.instrument = :sawsaw
  ctx.notes =  [[7, 1], [4, 1], [2, 1], [0, 0.5], [7, 0.5]] 
end

binary InNode do |ctx|
  ctx.instrument = :sawsaw
  ctx.notes =  [[5, 1], [4, 1]]   
end

binary InstanceOfNode do |ctx|
  ctx.instrument = :moog
  ctx.notes =  [[nil, 0.5], [0, 0.5], [nil, 0.5], [7, 0.5]] 
end

binary WhileNode, WithNode do |ctx|
  ctx.instrument = :moog
  ctx.notes =  [[12, 1], [4, 0.5], [2, 0.5],[12, 1]] 
end

binary :@name, LabelNode do |ctx|
  ctx.instrument = :sawsaw
  ctx.notes =  [[0, 1], [0, 1], [0, 1], [0, 1]] 
end
  
binary :@name, PropertyNode do |ctx|
  ctx.instrument = :sawsaw
  ctx.notes =  [[0, 0.25]] 
end

binary :@name, VarDeclNode do |ctx|
  ctx.instrument = :sinosc
  ctx.notes =  [[0, 0.5], [0, 0.5], [5, 0.25], [7, 0.25]] 
end

binary :@name, PostfixNode do |ctx|
  ctx.instrument = :sinosc
  ctx.notes =  [[0, 1], [4, 1]] 
end
  
binary :@name, PrefixNode do |ctx|
  ctx.instrument = :sinosc
  ctx.notes =  [[5, 1], [7, 1]] 
end

class FunctionCallNode
  extend Useful
  
  def children
    Array(@arguments) + Array(@value)
  end
  
  self.instrument = :sinmix
  self.notes = [[0, 1], [4, 1], [7, 1], [12, 1]]
end

class FunctionDeclNode
  extend Useful
  
  def children
    Array(@value) + Array(@arguments) + Array(@function_body)
  end
  
  self.instrument = :sawsaw
  self.notes = [[7, 0.5], [4, 0.5], [2, 0.5], [7, 0.5]]
end

class FunctionExprNode
  def children
    Array(@value) + Array(@arguments) + Array(@function_body)
  end
end


