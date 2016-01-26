class CreateClips < ActiveRecord::Migration
  def change
    create_table :clips do |t|
      t.belongs_to :video, index: true, foreign_key: true
      t.integer :position
      t.integer :duration

      t.timestamps null: false
    end
  end
end
