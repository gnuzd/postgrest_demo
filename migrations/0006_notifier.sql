CREATE OR REPLACE FUNCTION notify_table_update()
  RETURNS TRIGGER 
  LANGUAGE PLPGSQL  
  AS
$$
BEGIN
  IF TG_OP = 'INSERT' THEN
     PERFORM pg_notify(
        TG_TABLE_NAME,
        '{"new":' || row_to_json(NEW)::text  || '}'     
     );
  END IF;

  IF TG_OP = 'UPDATE' THEN
     PERFORM pg_notify(
        TG_TABLE_NAME,
        '{"new":' || row_to_json(NEW)::text  || ',"old":'  || row_to_json(NEW)::text || '}'
     );
  END IF;

  IF TG_OP = 'DELETE' THEN
     PERFORM pg_notify(
        'update_' || TG_TABLE_NAME,
        '{"old":'  || row_to_json(OLD)::text || '}'
     );
  END IF;
  RETURN null;
END;
$$;

CREATE TRIGGER channels_notify_trigger
    AFTER UPDATE OR INSERT OR DELETE ON private.channels
    FOR EACH ROW
    EXECUTE PROCEDURE notify_table_update();

CREATE TRIGGER channels_notify_trigger
    AFTER UPDATE OR INSERT OR DELETE ON private.channel_members
    FOR EACH ROW
    EXECUTE PROCEDURE notify_table_update();

CREATE TRIGGER channels_notify_trigger
    AFTER UPDATE OR INSERT OR DELETE ON private.messages
    FOR EACH ROW
    EXECUTE PROCEDURE notify_table_update();

