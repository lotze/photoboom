class FixConstraints < ActiveRecord::Migration[5.1]
  def change
    # allow team to be nil (registered for a game, but no team selected yet)
    change_column_null :registrations, :team_id, true
    #change_column :registrations, :team_id, :integer, null: true
  end
end
