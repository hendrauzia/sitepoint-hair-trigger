# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160131105220) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "clips", force: :cascade do |t|
    t.integer  "video_id"
    t.integer  "position"
    t.integer  "duration"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "clips", ["video_id"], name: "index_clips_on_video_id", using: :btree

  create_table "videos", force: :cascade do |t|
    t.string   "title"
    t.integer  "duration"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "clips", "videos"
  # no candidate create_trigger statement could be found, creating an adapter-specific one
  execute(<<-TRIGGERSQL)
CREATE OR REPLACE FUNCTION public.clips_after_delete_row_tr()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
                UPDATE videos SET duration = (
            SELECT sum(clips.duration)
            FROM clips
            WHERE clips.video_id = videos.id
          )
    
          WHERE videos.id = OLD.video_id;
    RETURN NULL;
END;
$function$
  TRIGGERSQL

  # no candidate create_trigger statement could be found, creating an adapter-specific one
  execute("CREATE TRIGGER clips_after_delete_row_tr AFTER DELETE ON \"clips\" FOR EACH ROW EXECUTE PROCEDURE clips_after_delete_row_tr()")

  # no candidate create_trigger statement could be found, creating an adapter-specific one
  execute(<<-TRIGGERSQL)
CREATE OR REPLACE FUNCTION public.clips_after_insert_row_tr()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
                UPDATE videos SET duration = (
            SELECT sum(clips.duration)
            FROM clips
            WHERE clips.video_id = videos.id
          )
    
          WHERE videos.id = NEW.video_id;
    RETURN NULL;
END;
$function$
  TRIGGERSQL

  # no candidate create_trigger statement could be found, creating an adapter-specific one
  execute("CREATE TRIGGER clips_after_insert_row_tr AFTER INSERT ON \"clips\" FOR EACH ROW EXECUTE PROCEDURE clips_after_insert_row_tr()")

  # no candidate create_trigger statement could be found, creating an adapter-specific one
  execute(<<-TRIGGERSQL)
CREATE OR REPLACE FUNCTION public.clips_after_update_of_duration_row_tr()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
                UPDATE videos SET duration = (
            SELECT sum(clips.duration)
            FROM clips
            WHERE clips.video_id = videos.id
          )
    
          WHERE videos.id = NEW.video_id;
    RETURN NULL;
END;
$function$
  TRIGGERSQL

  # no candidate create_trigger statement could be found, creating an adapter-specific one
  execute("CREATE TRIGGER clips_after_update_of_duration_row_tr AFTER UPDATE OF duration ON clips FOR EACH ROW EXECUTE PROCEDURE clips_after_update_of_duration_row_tr()")

end
