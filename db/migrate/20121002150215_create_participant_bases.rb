class CreateParticipantBases < ActiveRecord::Migration[6.0]
  def change
    rename_table :participants, :participant_bases
  end
end
