class PolyTreeNode

  attr_accessor :parent, :children, :value

  def initialize(value, parent=nil, children = [])
    @value = value
    @parent = parent
    @children = children
  end

  def parent=(parent_node=nil)

    @parent.children = @parent.children - [self] if @parent !=  nil


    @parent = parent_node
    if parent_node != nil
      parent_node.children << self unless parent_node.children.include?(self)

    end
  end

  def add_child(child_node)
    child_node.parent = self
    @children << child_node if !children.include?(child_node)
  end

  def remove_child(child_node)
    child_node.parent = nil
    raise "error" if !@children.include?(child_node)
  end
end

  module Searchable
    # I wrote this as a mixin in case I wanted to later write another
    # TreeNode class (e.g., BinaryTreeNode). All I need is `#children` and
    # `#value` for `Searchable` to work.

    def dfs(target = nil, &prc)
      raise "Need a proc or target" if [target, prc].none?
      prc ||= Proc.new { |node| node.value == target }

      return self if prc.call(self)

      children.each do |child|
        result = child.dfs(&prc)
        return result unless result.nil?
      end

      nil
    end

    def bfs(target = nil, &prc)
      raise "Need a proc or target" if [target, prc].none?
      prc ||= Proc.new { |node| node.value == target }

      nodes = [self]
      until nodes.empty?
        node = nodes.shift

        return node if prc.call(node)
        nodes.concat(node.children)
      end

      nil
    end

    def count
      1 + children.map(&:count).inject(:+)
    end
  end
