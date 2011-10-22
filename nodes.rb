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
        
    delay = self.class.duration_impact
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
		(instance_variables - [:@comments, :@line, :@filename]).map {|x| Array(instance_variable_get(x)) }.flatten
	end
end

module Useful
  def duration_impact ; 4 ; end
	def adds_depth? ; true  ; end
end


class IfNode
  extend Useful
  
  def orchestrate_self(delay, conductor, opts) ; end
  
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
end

value_only FalseNode do |delay, conductor, opts|
end

value_only DeleteNode do |delay, conductor, opts| 
end

value_only ReturnNode do |delay, conductor, opts|
end

value_only TypeOfNode do |delay, conductor, opts|
end

value_only NumberNode do |delay, conductor, opts|
end

value_only LogicalNotNode do |delay, conductor, opts|
end

value_only ThrowNode do |delay, conductor, opts|
end

value_only UnaryMinusNode do |delay, conductor, opts|
end

value_only ElementNode do |delay, conductor, opts|
end

value_only BitwiseNotNode do |delay, conductor, opts|
end

value_only NullNode do |delay, conductor, opts|
end

value_only StringNode do |delay, conductor, opts|
end

value_only ThisNode do |delay, conductor, opts|
end

value_only ArrayNode do |delay, conductor, opts|
end

value_only ContinueNode do |delay, conductor, opts|
end

value_only BreakNode do |delay, conductor, opts|
end

value_only ParameterNode do |delay, conductor, opts|
end

value_only RegexpNode do |delay, conductor, opts|
end

value_only ArgumentsNode do |delay, conductor, opts|
end

value_only CaseBlock do |delay, conductor, opts|
end
  
value_only ConstStatement do |delay, conductor, opts|
end

value_only ObjectLiteral do |delay, conductor, opts|
end
  
value_only SourceElementsNode do |delay, conductor, opts| 
end

value_only VarStatement do |delay, conductor, opts|
end

binary BitAnd, BitOr, BitXOr, LogicalAnd, LogicalOr do |delay, conductor, opts|
  
end

binary CaseClause do |delay, conductor, opts|
end

binary Switch do |delay, conductor, opts|
end

binary Divide, Modulus, Add, Multiply, Subtract do |delay, conductor, opts|
end

binary do |delay, conductor, opts|While do |delay, conductor, opts|
end

binary Equal, Greater, GreaterOrEqual, Less, LessOrEqual,
           NotEqual, NotStrictEqual, StrictEqual do |delay, conductor, opts|
             
end

binary In do |delay, conductor, opts|
  
end


binary InstanceOf do |delay, conductor, opts|
end

binary LeftShift, RightShift, UnsignedRightShift do |delay, conductor, opts|
end

binary While, With do |delay, conductor, opts|
end


binary :@name, Label do |delay, conductor, opts|
end
  
binary :@name, Property do |delay, conductor, opts|
end

binary :@name, VarDecl do |delay, conductor, opts|
end

binary :@name, Postfix do |delay, conductor, opts|
  
binary :@name, Prefix do |delay, conductor, opts|
end

binary :@name, If, Conditional do |delay, conductor, opts|
  # remember, @else could be nil... if @else.nil?
end

class FunctionCall
  extend Useful
  
  def children
    Array(@value) + Array(@arguments)
  end
  
  def orchestrate_self(delay, conductor, opts)
    
  end
end

class FunctionCall
  extend Useful
  
  def children
    Array(@value) + Array(@arguments) + Array(@function_body)
  end
  
  def orchestrate_self(delay, conductor, opts)
    
  end
end

