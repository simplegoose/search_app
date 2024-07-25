class AddCountColumnToSearches < ActiveRecord::Migration[7.1]
  def change
    add_column :searches, :count, :integer, :default => 0
  end
end
