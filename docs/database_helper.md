# Developer Documentation

## Class: DatabaseHelper

### Description
The `DatabaseHelper` class is responsible for managing the SQLite database using the GRDB library. It provides methods to initialize the database, create tables, and perform CRUD operations on the `EventData` table.

---

### Properties

#### `shared`
- **Type**: `DatabaseHelper`
- **Description**: Singleton instance of the `DatabaseHelper` class.

#### `dbQueue`
- **Type**: `DatabaseQueue?`
- **Description**: The database queue used to perform database operations.

---

### Methods

#### `initDb()`
- **Description**: Initializes the database by creating a database file in the document directory.
- **Parameters**: None
- **Return Value**: `Void`

#### `createTable()`
- **Description**: Creates the `EventData` table in the database with predefined columns.
- **Parameters**: None
- **Return Value**: `Void`

#### `addEvent(event: EventData)`
- **Description**: Adds a new event record to the `EventData` table.
- **Parameters**:
  - `event`: `EventData` - The event object to be added.
- **Return Value**: `Void`

**Example**:
```swift
// Adding an event 
DatabaseHelper.shared.addEvent(event: event)
```

#### `checkExistsByKeyAndTime(key: String, time: Int) -> Bool`
- **Description**: Checks if an event with the specified key and time exists in the database.
- **Parameters**:
  - `key`: `String` - The key of the event.
  - `time`: `Int` - The time of the event.
- **Return Value**: `Bool` - `true` if the event exists, otherwise `false`.

**Example**:
```swift
// Checking if an event exists 
let exists = DatabaseHelper.shared.checkExistsByKeyAndTime(key: "eventKey", time: 1234567890)
```

#### `getEvents(limit: Int) -> [EventData]?`
- **Description**: Retrieves a list of events from the `EventData` table, filtered by `appId` if available.
- **Parameters**:
  - `limit`: `Int` - The maximum number of events to retrieve.
- **Return Value**: `[EventData]?` - An array of `EventData` objects or `nil` if no events are found.

**Example**:
```swift
// Removing events 
DatabaseHelper.shared.removeEvents(events: events)
```

---

### Notes
- Ensure the database file is accessible and the `dbQueue` is properly initialized before performing any operations.
- Handle errors appropriately when performing database operations.

---

### Author
- **Name**: Tuan Dinh
- **Email**: tuandv@lynkid.vn
- **Date Created**: 23/05/2023
