SELECT
  "#user_id"
, "#account_id"
, "$part_event"
, "#event_time"
, "$part_date"
, "server_id"
, "passport_id"
, "hero_quality"
, "hero_power"
, "upgrade_type"
, "hero_name"
, "hero_step"
FROM
  v_event_61
WHERE (("$part_event" = 'hero_upgrade') AND ("$part_date" = '2022-01-28') AND("#account_id" = '109980000000018') AND("upgrade_type" = '升星')) 
LIMIT 20

