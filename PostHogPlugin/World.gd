extends Node2D

func _ready():
    randomize()

func _on_Button_pressed() -> void:
    var postHogEvent = PostHogEvent.new()
    postHogEvent.DistinctId = "Test User Id"
    postHogEvent.EventName = "Test_SingleEvent_Button_Clicked"
    postHogEvent.Properties["President"] = "Ralph Notter"
    postHogEvent.Properties["VicePresident"] = "A bird chirping on a branch"
    PostHog.send_event(postHogEvent)


func _on_Button2_pressed() -> void:
    var batched_events = [
        get_batch_posthog_event(),
        get_batch_posthog_event(),
        get_batch_posthog_event(),
        get_batch_posthog_event(),
        get_batch_posthog_event(),
        get_batch_posthog_event(),
        get_batch_posthog_event(),
        get_batch_posthog_event(),
        get_batch_posthog_event(),
        get_batch_posthog_event(),
        get_batch_posthog_event(),
        get_batch_posthog_event()
       ]
    PostHog.send_event_batch(batched_events)
    
func get_batch_posthog_event() -> PostHogEvent:
    var postHogEvent = PostHogEvent.new()
    postHogEvent.DistinctId = "Test User Id" + str(randi() % 103)
    postHogEvent.EventName = "Test_Button_Batch_Clicked"
    postHogEvent.Properties["Key1"] = randi() % 23
    postHogEvent.Properties["Key2"] = randi() % 2
    
    return postHogEvent
