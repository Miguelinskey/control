class AddCounterCaches < ActiveRecord::Migration[8.1]
  def up
    add_column :categories, :topics_count, :integer, default: 0, null: false
    add_column :topics, :posts_count, :integer, default: 0, null: false

    Category.find_each { |c| Category.reset_counters(c.id, :topics) }
    Topic.find_each { |t| Topic.reset_counters(t.id, :posts) }
  end

  def down
    remove_column :categories, :topics_count
    remove_column :topics, :posts_count
  end
end
