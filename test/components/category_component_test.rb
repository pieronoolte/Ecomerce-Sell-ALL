# frozen_string_literal: true

require "test_helper"

class CategoryComponentTest < ViewComponent::TestCase
  
  def test_component_renders_something_useful
    assert_equal(
      %(<a class=\"category text-gray-600 px-4 py-2 rounded-2xl drop-shadow-sm hover:bg-gray-300 m-1 text-center bg-gray-400\" href=\"/\"><span class=\"translation_missing\" title=\"translation missing: en.category_component.All, locale: en\">All</span></a>),
      render_inline(CategoryComponent.new).to_html
    )
  end

  def test_component_renders_a_category
    category = Category.last
    assert_equal(
      %(<a class=\"category text-gray-600 px-4 py-2 rounded-2xl drop-shadow-sm hover:bg-gray-300 m-1 text-center bg-white\" href=\"/?category_id=#{category.id}\">#{category.name}</a>),
      render_inline(CategoryComponent.new(category: category)).to_html
    )
  end
end
