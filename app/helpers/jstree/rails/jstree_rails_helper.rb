module Jstree::Rails::JstreeRailsHelper

  def jstree_html_tag(jstree_id, jstree_data=[], &block)
    root = jstree_data.find { |g| g['parent'] == "#" }
    
    content_tag :div, id: jstree_id do
      content_tag :ul do
        content_tag :li, id: root['id'] do
          concat root['text']
          concat jstree_node_tag(root, jstree_data, &block)
        end
      end
    end
  end

  private

  def jstree_node_tag(parent, jstree_data, &block)
    children = jstree_data.select { |g| g['parent'] == parent['id'] }

    content_tag :ul do
      children.each do |child|
        concat (
          content_tag :li, id: child['id'] do
            concat child['text']
            concat jstree_node_tag child, jstree_data
          end
        )
      end
    end
  end
end