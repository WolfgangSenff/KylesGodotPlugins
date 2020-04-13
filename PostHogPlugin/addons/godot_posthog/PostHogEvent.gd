extends Resource
class_name PostHogEvent

# The name of the event you want to record
export (String) var EventName
# The user's distinct ID
export (String) var DistinctId
# The properties to record
export (Dictionary) var Properties

# Optional timestamp; if not supplied, it is supplied by the server
export (String) var Timestamp
