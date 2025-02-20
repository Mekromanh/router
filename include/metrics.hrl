-define(METRICS_TICK_INTERVAL, timer:seconds(10)).
-define(METRICS_TICK, '__router_metrics_tick').

-define(METRICS_DC, "router_dc_balance").
-define(METRICS_SC_OPENED_COUNT, "router_state_channel_opened_count").
-define(METRICS_SC_OVERSPENT_COUNT, "router_state_channel_overspent_count").
-define(METRICS_SC_ACTIVE_COUNT, "router_state_channel_active_count").
-define(METRICS_SC_ACTIVE_BALANCE, "router_state_channel_active_balance").
-define(METRICS_SC_ACTIVE_ACTORS, "router_state_channel_active_actors").
-define(METRICS_SC_CLOSE_CONFLICT, "router_state_channel_close_conflicts").
-define(METRICS_ROUTING_OFFER, "router_device_routing_offer_duration").
-define(METRICS_ROUTING_PACKET, "router_device_routing_packet_duration").
-define(METRICS_PACKET_TRIP, "router_device_packet_trip_duration").
-define(METRICS_PACKET_HOLD_TIME, "router_device_packet_hold_time_duration").
-define(METRICS_DECODED_TIME, "router_decoder_decoded_duration").
-define(METRICS_FUN_DURATION, "router_function_duration").
-define(METRICS_CONSOLE_API_TIME, "router_console_api_duration").
-define(METRICS_DOWNLINK, "router_device_downlink_packet").
-define(METRICS_WS, "router_ws_state").
-define(METRICS_CHAIN_BLOCKS, "router_blockchain_blocks").
-define(METRICS_VM_CPU, "router_vm_cpu").
-define(METRICS_VM_PROC_Q, "router_vm_process_queue").
-define(METRICS_VM_ETS_MEMORY, "router_vm_ets_memory").
-define(METRICS_XOR_FILTER, "router_xor_filter").
-define(METRICS_GRPC_CONNECTION_COUNT, "router_grpc_connection_count").
-define(METRICS_SC_CLOSE_SUBMIT, "router_sc_close_submit_count").

-define(METRICS, [
    {?METRICS_DC, prometheus_gauge, [], "Active State Channel balance"},
    {?METRICS_SC_OPENED_COUNT, prometheus_gauge, [], "Opened State Channels count"},
    {?METRICS_SC_OVERSPENT_COUNT, prometheus_gauge, [], "Overspent State Channels count"},
    {?METRICS_SC_ACTIVE_COUNT, prometheus_gauge, [], "Active State Channels count"},
    {?METRICS_SC_ACTIVE_BALANCE, prometheus_gauge, [], "Active State Channels balance"},
    {?METRICS_SC_ACTIVE_ACTORS, prometheus_gauge, [], "Active State Channels actors"},
    {?METRICS_SC_CLOSE_CONFLICT, prometheus_gauge, [], "State Channels close with conflicts"},
    {?METRICS_ROUTING_OFFER, prometheus_histogram, [type, status, reason],
        "Routing Offer duration"},
    {?METRICS_ROUTING_PACKET, prometheus_histogram, [type, status, reason, downlink],
        "Routing Packet duration"},
    {?METRICS_PACKET_TRIP, prometheus_histogram, [type, downlink], "Packet round trip duration"},
    {?METRICS_PACKET_HOLD_TIME, prometheus_histogram, [type], "Packet hold time duration"},
    {?METRICS_DECODED_TIME, prometheus_histogram, [type, status], "Decoder decoded duration"},
    {?METRICS_FUN_DURATION, prometheus_histogram, [function], "Function duration"},
    {?METRICS_CONSOLE_API_TIME, prometheus_histogram, [type, status], "Console API duration"},
    {?METRICS_DOWNLINK, prometheus_counter, [type, status], "Downlink count"},
    {?METRICS_WS, prometheus_boolean, [], "Websocket State"},
    {?METRICS_CHAIN_BLOCKS, prometheus_gauge, [], "Router's blockchain blocks"},
    {?METRICS_VM_CPU, prometheus_gauge, [cpu], "Router CPU usage"},
    {?METRICS_VM_PROC_Q, prometheus_gauge, [name], "Router process queue"},
    {?METRICS_VM_ETS_MEMORY, prometheus_gauge, [name], "Router ets memory"},
    {?METRICS_XOR_FILTER, prometheus_counter, [], "Router XOR Filter udpates"},
    {?METRICS_GRPC_CONNECTION_COUNT, prometheus_gauge, [], "Number of active GRPC Connections"},
    {?METRICS_SC_CLOSE_SUBMIT, prometheus_counter, [status],
        "Router state channels close txn status"}
]).
