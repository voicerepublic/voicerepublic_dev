class CreateParticipantBases < ActiveRecord::Migration
  def change
    rename_table :participants, :participant_bases
  end
end
