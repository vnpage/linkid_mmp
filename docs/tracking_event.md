# TrackingEvent Class Developer Documentation

## Overview

The `TrackingEvent` class is responsible for tracking events, managing event synchronization, and handling real-time event logging. It ensures that events are queued, synced to the server, and logged in real-time when necessary.

---

## Features

- Event Tracking: Tracks events with associated data.
- Real-Time Event Logging: Logs events in real-time when specified.
- Event Synchronization: Syncs events to the server at regular intervals or when a threshold is reached.
- Heartbeat Management: Sends periodic heartbeat signals to the server.
- Authentication Check: Ensures valid authentication before tracking events.

---

## Key Methods

### `checkAuth`
Checks the authentication status and retries authentication if necessary.

**Declaration**:  
`class func checkAuth()`

**Usage**:  
TrackingEvent.checkAuth()

---

### `trackEvent`
Tracks an event with a name and optional data. Handles real-time logging if specified.

**Declaration**:  
`class func trackEvent(name: String, data: [String: Any]?)`

**Parameters**:  
- `name`: The name of the event.  
- `data`: A dictionary containing additional data for the event.

**Usage**:  
TrackingEvent.trackEvent(name: "event_name", data: ["key": "value"])

---

### `getTotalCount`
Returns the total count of events tracked since the last sync.

**Declaration**:  
`class func getTotalCount() -> Int`

**Usage**:  
let count = TrackingEvent.getTotalCount()

---

### `syncRealtime`
Synchronizes a single event to the server in real-time.

**Declaration**:  
`private class func syncRealtime(_ eventData: EventData)`

**Parameters**:  
- `eventData`: The event data to be synced.

**Usage**:  
This method is used internally for real-time event synchronization.

---

### `sync`
Synchronizes queued events to the server.

**Declaration**:  
`private class func sync()`

**Usage**:  
This method is called automatically when the sync threshold is reached or at regular intervals.

---

### `heartBeat`
Sends a heartbeat signal to the server to indicate the SDK is active.

**Declaration**:  
`private class func heartBeat()`

**Usage**:  
This method is called internally at regular intervals.

---

### `checkTimer`
Ensures the sync timer is running.

**Declaration**:  
`private class func checkTimer()`

**Usage**:  
This method is called internally to manage the sync timer.

---

### `startSyncTimer`
Starts the sync timer to schedule periodic event synchronization.

**Declaration**:  
`private class func startSyncTimer()`

**Usage**:  
This method is called internally to initialize the sync timer.

---

### `stopSyncTimer`
Stops the sync timer and clears it.

**Declaration**:  
`public class func stopSyncTimer()`

**Usage**:  
TrackingEvent.stopSyncTimer()

---

## Development Notes

- Ensure that the `SessionManager` is properly authenticated before tracking events.
- Use the `trackEvent` method to log events with optional data.
- Real-time events are synced immediately, while others are queued for periodic synchronization.

---

## Testing

- Test event tracking with valid and invalid data.
- Simulate real-time event logging and verify server responses.
- Validate periodic synchronization and heartbeat functionality.

---

## Contribution Guidelines

- Follow the coding standards defined in the project.
- Ensure all changes are tested thoroughly.
- Submit pull requests with detailed descriptions of changes.

---

## License

This project is licensed under the [insert license type, e.g., MIT License]. See the `LICENSE` file for more details.
