extends Node

signal send_event_successful
signal send_event_failed

const APIKey = ""
const YourInstanceName = ""

const PostAddress = "https://" + YourInstanceName + ".herokuapp.com/capture/"
enum SendType { Single, Batch }
var sender : HTTPRequest

var request_queue = []

const ApiKeyKey = "api_key"
const EventKey = "event"
const TypeKey = "type"
const TimestampKey = "timestamp"
const DistinctIdKey = "distinct_id"
const PropertiesKey = "Properties"
const BatchKey = "batch"

const SingleEventBody = {
    ApiKeyKey : APIKey,
    EventKey : "",
    PropertiesKey : {
        DistinctIdKey : ""
       },
    TimestampKey : null
   }

const BatchEventBody = {
    ApiKeyKey : APIKey,
    BatchKey : []
   }

func _ready() -> void:
    sender = HTTPRequest.new()
    add_child(sender)
    sender.connect("request_completed", self, "on_send_event_request_complete")

# Send a single event to the Mixpanel service
func send_event(event : PostHogEvent) -> void:
    var dupe = get_formatted_single_event(event)
    var to_push = to_json(dupe)
    
    if sender.get_http_client_status() == HTTPClient.STATUS_DISCONNECTED:
        sender.request(PostAddress, PoolStringArray(), true, HTTPClient.METHOD_POST, to_push)
    else:
        request_queue.push_back({EventKey: event, TypeKey: SendType.Single})

# Ensure everything in batched_events is of type PostHogEvent
func send_event_batch(batched_events : Array) -> void:
    var dupe = BatchEventBody.duplicate(true)
    for event in batched_events:
        var formatted_event = get_formatted_batch_event(event)
        dupe.batch.push_back(formatted_event)
    
    var to_push = to_json(dupe)
    
    if sender.get_http_client_status() == HTTPClient.STATUS_DISCONNECTED:
        sender.request(PostAddress, PoolStringArray(), true, HTTPClient.METHOD_POST, to_push)
    else:
        request_queue.push_back({EventKey: batched_events, TypeKey: SendType.Batch})

func get_formatted_single_event(event : PostHogEvent) -> Dictionary:
    var dupe = SingleEventBody.duplicate(true)
    dupe.event = event.EventName
    dupe.properties = event.Properties
    dupe.properties[DistinctIdKey] = event.DistinctId
    
    if !event.Timestamp:
        dupe.erase(TimestampKey)
    
    return dupe
    
func get_formatted_batch_event(event : PostHogEvent) -> String:
    var result = get_formatted_single_event(event)
    result.erase(ApiKeyKey)
    return result
    
func on_send_event_request_complete(result, response_code, headers, body):
    if response_code == HTTPClient.RESPONSE_OK:
        emit_signal("send_event_successful")
    else:
        emit_signal("send_event_failed")
    
    if request_queue.size() > 0:
        var request = request_queue[0]
        var event = request[EventKey]
        var type = request[TypeKey]
        if type == SendType.Single:
            send_event(event)
        elif type == SendType.Batch: # Since we can't be sure what type is, ensure it's something correct rather than blanket else
            send_event_batch(event)
            
        request_queue.remove(0)
