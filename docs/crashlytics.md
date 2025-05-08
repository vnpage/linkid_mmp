# Crashlytics Class Developer Documentation

## Overview

The `Crashlytics` class is responsible for handling application crashes and errors. It provides methods to set up crash handlers, log crash details, and send crash reports to the server.

---

## Features

- **Crash Handling**: Captures uncaught exceptions and signals.
- **Crash Logging**: Saves crash logs locally for later retrieval.
- **Crash Reporting**: Sends crash logs to the server for analysis.
- **Error Recording**: Records custom errors with stack traces.
- **Crash Check**: Checks for previously saved crash logs and reports them.

---

## Key Methods

### `setup`
Sets up the crash handlers for uncaught exceptions and signals.

**Declaration**:
`public static func setup()`

**Usage**:
Crashlytics.setup()

---

### `recordError`
Records a custom error with a name and stack trace. If the user is authenticated, the error is sent to the server; otherwise, it is saved locally.

**Declaration**:
`public static func recordError(name: String, stackTrace: String)`

**Parameters**:
- `name`: The name of the error.
- `stackTrace`: The stack trace of the error.

**Usage**:
Crashlytics.recordError(name: "CustomError", stackTrace: "Stack trace details")

---

### `check`
Checks for any previously saved crash logs and sends them to the server if available.

**Declaration**:
`public static func check()`

**Usage**:
Crashlytics.check()

---

### `saveCrashLog`
Saves a crash log locally with a hash for identification.

**Declaration**:
`private static func saveCrashLog(_ crashLog: String, hash: String)`

**Parameters**:
- `crashLog`: The crash log details.
- `hash`: A unique hash for the crash log.

**Usage**:
This method is used internally to save crash logs.

---

### `sendCrashLogToServer`
Sends a crash log to the server with additional device and app information.

**Declaration**:
`private static func sendCrashLogToServer(_ crashLog: String, hash: String)`

**Parameters**:
- `crashLog`: The crash log details.
- `hash`: A unique hash for the crash log.

**Usage**:
This method is used internally to report crash logs to the server.

---

### `signalHandler`
Handles signals such as `SIGABRT`, `SIGILL`, `SIGSEGV`, etc., and logs the signal details.

**Declaration**:
`private static func signalHandler(_ signal: Int32)`

**Parameters**:
- `signal`: The signal code.

**Usage**:
This method is used internally to handle signals.

---

### `handleException`
Handles uncaught exceptions and logs the exception details.

**Declaration**:
`private static func handleException(_ exception: NSException)`

**Parameters**:
- `exception`: The uncaught exception.

**Usage**:
This method is used internally to handle exceptions.

---

## Development Notes

- Ensure that `Crashlytics.setup()` is called during app initialization to enable crash handling.
- Use `recordError` to log custom errors with detailed stack traces.
- The `check` method should be called during app startup to report any previously saved crash logs.

---

## Testing

- Simulate uncaught exceptions and verify that they are logged and reported correctly.
- Test signal handling by triggering signals such as `SIGABRT` or `SIGSEGV`.
- Validate that custom errors are recorded and sent to the server when authenticated.
- Ensure that saved crash logs are correctly retrieved and reported during app startup.

---

## Contribution Guidelines

- Follow the coding standards defined in the project.
- Ensure all changes are tested thoroughly.
- Submit pull requests with detailed descriptions of changes.

---

## License

This project is licensed under the [insert license type, e.g., MIT License]. See the `LICENSE` file for more details.
