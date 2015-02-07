class CreateNations < ActiveRecord::Migration
  def change
    create_table :nations do |t|
      t.integer :day
      t.integer :province_id
      t.text :content
      t.timestamps
    end
  end
end
