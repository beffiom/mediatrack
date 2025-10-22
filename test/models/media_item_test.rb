require "test_helper"

class MediaItemTest < ActiveSupport::TestCase
  test "validates presence" do
    m = MediaItem.new
    refute m.valid?
    assert_includes m.errors.attribute_names, :tmdb_id
    assert_includes m.errors.attribute_names, :title
    assert_includes m.errors.attribute_names, :media_type
  end

  test "validates tmdb_id uniqueness" do
    existing = MediaItem.create!(tmdb_id: 123, title: "a", media_type: "movie")
    dup = MediaItem.new(tmdb_id: existing.tmdb_id, title: "dup", media_type: "movie")
    refute dup.valid?
    assert_includes dup.errors.attribute_names, :tmdb_id
  end
end
