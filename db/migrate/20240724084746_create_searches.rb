class CreateSearches < ActiveRecord::Migration[7.1]
  def change
    create_table :searches do |t|
      t.text :ip_address
      t.text :search_params

      t.timestamps
    end
  end
end
