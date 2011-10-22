require 'rkelly'

class RKelly::Nodes::Node
	attr_accessor :depth
	
	def self.duration_impact
		4
	end
	
	def self.adds_depth?
		true
	end
	
	def play 
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
		@height ||= children.map do |x|
			if RKelly::Nodes::Node === x
				x.height
			else
				0
			end
		end.max.to_i + (self.class.adds_depth? ? 1 : 0)
	end
	
	def children
		(instance_variables - [:@comments, :@line, :@filename]).map {|x| Array(instance_variable_get(x))}.flatten
	end
end

include RKelly::Nodes 
useless_nodes = [AddNode,
ArgumentsNode,
ArrayNode,
AssignExprNode,
AttrNode,
BitAndNode,
BitOrNode,
BitXOrNode,
BitwiseNotNode,
BlockNode,
BracketAccessorNode,
BreakNode,
CaseBlockNode,
ConstStatementNode,
ContinueNode,
DeleteNode,
DivideNode,
DoWhileNode,
ElementNode,
EmptyStatementNode,
EqualNode,
ExpressionStatementNode,
FalseNode,
ForNode,
FunctionBodyNode,
GetterPropertyNode,
GreaterNode,
GreaterOrEqualNode,
InNode,
InstanceOfNode,
LeftShiftNode,
LessNode,
LessOrEqualNode,
LogicalAndNode,
LogicalNotNode,
LogicalOrNode,
ModulusNode,
MultiplyNode,
NotEqualNode,
NullNode,
NumberNode,
ObjectLiteralNode,
OpAndEqualNode,
OpDivideEqualNode,
OpLShiftEqualNode,
OpMinusEqualNode,
OpModEqualNode,
OpMultiplyEqualNode,
OpOrEqualNode,
OpPlusEqualNode,
OpRShiftEqualNode,
OpURShiftEqualNode,
OpXOrEqualNode,
ParameterNode,
RegexpNode,
ReturnNode,
RightShiftNode,
SetterPropertyNode,
SourceElementsNode,
StringNode,
SubtractNode,
SwitchNode,
ThisNode,
ThrowNode,
TrueNode,
TypeOfNode,
UnaryMinusNode,
UnaryPlusNode,
UnsignedRightShiftNode,
VarStatementNode,
VoidNode,
WhileNode,
WithNode]

for node in useless_nodes
	def node.duration_impact ; 0 ; end
	def node.adds_depth? ; false ; end
end
 
class BinaryNode < RKelly::Nodes::Node
def self.adds_depth? ; true ; end
#def self.duration_impact ; 2 ; end
	def children
		Array(@left) + Array(@right)
	end
end

class BracketAccessorNode < RKelly::Nodes::Node
	def self.adds_depth? ; false ; end
	def self.duration_impact ; 0 ; end
	#def children
	#	Array(value)
	#end
end

class CommaNode < RKelly::Nodes::Node
	def self.adds_depth? ; false ; end
	def self.duration_impact ; 0 ; end
end

class IfNode < RKelly::Nodes::Node
	# def initialize(rnode,depth)
	#	condition = rnode.condition
	#	body = rnode.value
	#	else_ = rnode.else
	#	children = [Node.new(condition), Node.new(body), Node.new(else_)]
	#end
	def self.adds_depth? ; true ; end
	def children
		Array(@value) + Array(@conditions) + Array(@else)
	end
end

class DotAccessorNode < RKelly::Nodes::Node
	def self.adds_depth? ; false ; end
	def self.duration_impact ; 0 ; end
	#def children
	#	Array(value)
	#end
end

class ForInNode < RKelly::Nodes::Node
	def self.adds_depth? ; true ; end
end

class ForNode < RKelly::Nodes::Node
	def self.adds_depth? ; true ; end
	
end

class FunctionCallNode < RKelly::Nodes::Node
	#def children
	#	Array(value)
	#end
end

class FunctionExprNode < RKelly::Nodes::Node
	def self.adds_depth? ; true ; end
	#def children
	#	Array(value)
	#end
end

class LabelNode < RKelly::Nodes::Node
def self.adds_depth? ; false ; end
def self.duration_impact ; 0 ; end

	#def children
	#	Array(value)
	#end
end

class NewExprNode < RKelly::Nodes::Node
def self.adds_depth? ; true ; end
	#def children
	#	Array(value)
	#end
end

class OpEqualNode < RKelly::Nodes::Node
def self.adds_depth? ; false ; end
def self.duration_impact ; 0 ; end
	#def children
	#	Array(value)
	#end
end

class PostfixNode < RKelly::Nodes::Node
	def self.adds_depth? ; false ; end
	def self.duration_impact ; 0 ; end
	#def children
	#	Array(value)
	#end
end

class TryNode < RKelly::Nodes::Node
def self.adds_depth? ; true ; end
	#def children
	#	Array(value)
	#end
end

class VarDeclNode < RKelly::Nodes::Node
	def adds_depth? ; false ; end
	def duration_impact ; 0 ; end
	
	#def children
	#	Array(value)
	#end
end

class PropertyNode < RKelly::Nodes::Node
def self.adds_depth? ; false ; end
def self.duration_impact ; 0 ; end

	#def children
	#	Array(value)
	#end
end

class ResolveNode < RKelly::Nodes::Node
def self.adds_depth? ; false ; end
def self.duration_impact ; 0 ; end

	#def children
	#	Array(value)
	#end
end

class CaseClauseNode < BinaryNode
def self.adds_depth? ; true ; end
	#def children
	#	Array(value)
	#end
end

class ConditionalNode < IfNode
def self.adds_depth? ; true ; end
	#def children
	#	Array(value)
	#end
end

class FunctionDeclNode < FunctionExprNode
def self.adds_depth? ; false ; end
def self.duration_impact ; 0 ; end

	#def children
	#	Array(value)
	#end
end

# object?
#class Node < Node
#end

class NotStrictEqualNode < BinaryNode
def self.adds_depth? ; false ; end
def self.duration_impact ; 0 ; end

	def children
		Array(value)
	end
end

class PrefixNode < PostfixNode
def self.adds_depth? ; false ; end
def self.duration_impact ; 0 ; end

	def children
		Array(value)
	end
end

class StrictEqualNode < BinaryNode
def self.adds_depth? ; false ; end
def self.duration_impact ; 0 ; end

	def children
		Array(value)
	end
end



#return instance variables from a node
def debug_instance_variables(node)
  node.instance_variables.to_s
end

# returns a node from an RKelly parser.parse loop
def debug_nodes(node)
  case node
  when RKelly::Nodes::BinaryNode
    return node.to_s()
  when RKelly::Nodes::BracketAccessorNode
    node.to_s()
  when RKelly::Nodes::CaseClauseNode
    node.to_s()
  when RKelly::Nodes::CommaNode
    node.to_s()
  when RKelly::Nodes::ConditionalNode
    node.to_s()
  when RKelly::Nodes::DotAccessorNode
    node.to_s()
  when RKelly::Nodes::ForInNode
    node.to_s()
  when RKelly::Nodes::ForNode
    node.to_s()
  when RKelly::Nodes::FunctionCallNode
    node.to_s()
  when RKelly::Nodes::FunctionDeclNode
    node.to_s()
  when RKelly::Nodes::FunctionExprNode
    node.to_s()
  when RKelly::Nodes::IfNode
    node.to_s()
  when RKelly::Nodes::LabelNode
    node.to_s()
  when RKelly::Nodes::NewExprNode
    node.to_s()
  when RKelly::Nodes::NotStrictEqualNode
    node.to_s()
  when RKelly::Nodes::OpEqualNode
    node.to_s()
  when RKelly::Nodes::PostfixNode
    node.to_s()
  when RKelly::Nodes::PrefixNode
    node.to_s()
  when RKelly::Nodes::PropertyNode
    node.to_s()
  when RKelly::Nodes::ResolveNode
    node.to_s()
  when RKelly::Nodes::StrictEqualNode
    node.to_s()
  when RKelly::Nodes::TryNode
    node.to_s()
  when RKelly::Nodes::VarDeclNode
    node.to_s()
   end
end


parser = RKelly::Parser.new

# Grab our javascript source code here
ast = parser.parse( "

					function boom()
					{
						alert(\"ALERT\")
					}

					var z = 5;
					
					while(z>0)
					{
						z--;
						
					}
					
					document.write(\"Hello Dolly\");
					
					y=5;
					z=2;
					x=y+z;
					
					
					switch(n)
					{
					case 1:
					  
					  break;
					case 2:
					  
					  break;
					default:
					  
					}
					
					try
					{
						//Run some code here
					}
					catch(err)
					{
						//Handle errors here
					}
				  
					for(var i =0; i < 10; i++)
					{ 
						if ( i > 2)
						{}
						
						if(i > 15)
						{
							i = i - 5;
						}
						else
						{
							break;
						}
					}
					") 
                    

def traverse(node, depth)
  #### Added Node here in our traverse method
  if RKelly::Nodes::Node === node
	if(node.duration > 0)
		puts "#{" "*depth} #{node.class} #{node.duration} #{node.height}"
	end
	#puts Node.duration
    Array(node.children).each {|x| traverse(x, depth+1)}
  end
 end

 #ast.each do |node|
	#puts debug_nodes(node)
	#puts debug_instance_variables(node)
	#puts node.children
 #end
 
traverse(ast, 0)


