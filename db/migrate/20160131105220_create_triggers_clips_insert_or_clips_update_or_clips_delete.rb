# This migration was auto-generated via `rake db:generate_trigger_migration'.
# While you can edit this file, any changes you make to the definitions here
# will be undone by the next auto-generated trigger migration.

class CreateTriggersClipsInsertOrClipsUpdateOrClipsDelete < ActiveRecord::Migration
  def up
    create_trigger("clips_after_insert_row_tr", :generated => true, :compatibility => 1).
        on("clips").
        after(:insert) do
      <<-SQL_ACTIONS
            UPDATE videos SET duration = (
        SELECT sum(clips.duration)
        FROM clips
        WHERE clips.video_id = videos.id
      )

      WHERE videos.id = NEW.video_id;
      SQL_ACTIONS
    end

    create_trigger("clips_after_update_of_duration_row_tr", :generated => true, :compatibility => 1).
        on("clips").
        after(:update).
        of(:duration) do
      <<-SQL_ACTIONS
            UPDATE videos SET duration = (
        SELECT sum(clips.duration)
        FROM clips
        WHERE clips.video_id = videos.id
      )

      WHERE videos.id = NEW.video_id;
      SQL_ACTIONS
    end

    create_trigger("clips_after_delete_row_tr", :generated => true, :compatibility => 1).
        on("clips").
        after(:delete) do
      <<-SQL_ACTIONS
            UPDATE videos SET duration = (
        SELECT sum(clips.duration)
        FROM clips
        WHERE clips.video_id = videos.id
      )

      WHERE videos.id = OLD.video_id;
      SQL_ACTIONS
    end
  end

  def down
    drop_trigger("clips_after_insert_row_tr", "clips", :generated => true)

    drop_trigger("clips_after_update_of_duration_row_tr", "clips", :generated => true)

    drop_trigger("clips_after_delete_row_tr", "clips", :generated => true)
  end
end
