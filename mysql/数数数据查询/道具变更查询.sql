SELECT
  "#user_id"
, "#account_id"
, "#event_time"
, "$part_date"
, "server_id"
, "item_type"
, "change_after"
, "role_name"
, "change_type"
, "change_num"
, "item_id"
, "item_name"
, "change_before"
, "change_method"
, "item_sub_type"
FROM
  v_event_61
WHERE (("$part_event" = 'item_change') AND ("$part_date" = '2022-01-27') AND("#account_id" = '109980000000060') AND("item_sub_type" = '英雄碎片') AND("change_method" = '英雄升星消耗'))
LIMIT 100
