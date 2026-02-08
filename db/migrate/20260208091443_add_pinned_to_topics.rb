class AddPinnedToTopics < ActiveRecord::Migration[8.0]
  def change
    add_column :topics, :pinned, :boolean, default: false, null: false
  end
end
