# This migration comes from kblog (originally 20130303192309)
class CreateKblogArticles < ActiveRecord::Migration[6.0]
  def change
    create_table :kblog_articles do |t|
      t.string :title
      t.text :content

      t.timestamps
    end
  end
end
