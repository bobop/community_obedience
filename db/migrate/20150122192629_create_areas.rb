class CreateAreas < ActiveRecord::Migration
  def change
    create_table :areas do |t|
      t.integer :day
      t.integer :cluster_id
      t.string :name
      t.text :content
      t.timestamps
    end
  end
end
