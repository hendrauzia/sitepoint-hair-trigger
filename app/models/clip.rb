class Clip < ActiveRecord::Base
  belongs_to :video

  def self.update_video_duration_sql
    <<-SQL
      UPDATE videos SET duration = (
        SELECT sum(clips.duration)
        FROM clips
        WHERE clips.video_id = videos.id
      )
    SQL
  end

  trigger.after(:create) do
    <<-SQL
      #{ self.update_video_duration_sql }
      WHERE videos.id = NEW.video_id
    SQL
  end

  trigger.after(:update).of(:duration) do
    <<-SQL
      #{ self.update_video_duration_sql }
      WHERE videos.id = NEW.video_id
    SQL
  end

  trigger.after(:delete) do
    <<-SQL
      #{ self.update_video_duration_sql }
      WHERE videos.id = OLD.video_id
    SQL
  end
end
