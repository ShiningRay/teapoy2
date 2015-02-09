# coding: utf-8
class CreateReferences < ActiveRecord::Migration
  def change
    create_table :references do |t|
      t.integer :source_id
      t.integer :target_id
      t.string :relation_type
      t.boolean :detected
      t.timestamps
    end
  end
end
