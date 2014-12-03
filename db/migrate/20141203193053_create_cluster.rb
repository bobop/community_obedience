class CreateCluster < ActiveRecord::Migration
  def change
    create_table :clusters do |t|
      t.string :name
      t.text :content
      t.timestamps
    end 
  end
end
