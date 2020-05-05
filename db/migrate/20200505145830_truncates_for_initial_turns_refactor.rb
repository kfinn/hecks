class TruncatesForInitialTurnsRefactor < ActiveRecord::Migration[6.0]
  def up
    execute <<~SQL
      TRUNCATE TABLE games CASCADE;
    SQL
  end

  def down
  end
end
