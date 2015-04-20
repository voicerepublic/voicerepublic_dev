class AddDryrunToTalks < ActiveRecord::Migration
  def change
    add_column :talks, :dryrun, :boolean, default: false
  end
end
