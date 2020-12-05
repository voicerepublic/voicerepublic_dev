class AddDryrunToTalks < ActiveRecord::Migration[6.0]
  def change
    add_column :talks, :dryrun, :boolean, default: false
  end
end
