module Jstree::Rails::JstreeRailsHelper

  # @param jstree_id The ID attribute of the HTML element, which is used by jsTree.
  # @param jstree_nodes An array of tree nodes, each of which must be a hash and the permitted keys are:
  # - (REQUIRED) :parent A parent node ID. If the node is root node, the value must be '#'.
  # - (REQUIRED) :id A node ID. This must be unique amoung all of tree nodes.
  # - (REQUIRED) :text A node text which is shown.
  # - (OPTIONAL) :data A hash value to be set to the data attributes of the tree node.
  def jstree_html_tag(jstree_id, jstree_nodes=[], &block)
    root = jstree_nodes.find { |g| g[:parent] == "#" }

    content_tag :div, id: jstree_id do
      content_tag :ul do
        content_tag :li, content_options(root, &block) do
          concat root[:text]
          concat jstree_node_tag(root, jstree_nodes, &block)
        end
      end
    end
  end

  private

  def jstree_node_tag(parent, jstree_nodes, &block)
    children = jstree_nodes.select { |g| g[:parent] == parent[:id] }

    content_tag :ul do
      children.each do |child|
        concat (
          content_tag :li, content_options(child, &block) do
            concat child[:text]
            concat jstree_node_tag(child, jstree_nodes, &block)
          end
        )
      end
    end
  end

  def content_options(node_hash, &block)
    options = {
      id: node_hash[:id],
      data: node_hash[:data] || {}
    }
    yield options if block_given?
    options
  end
end
