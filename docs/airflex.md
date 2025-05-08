# Airflex Class Developer Documentation

## Overview

The `Airflex` class is the core of the SDK, providing functionalities such as event tracking, user session management, revenue tracking, feature flagging, and deep link handling. It serves as the main entry point for initializing and interacting with the SDK.

---

## Features

- Event Tracking: Log custom events and screen views.
- User Session Management: Manage user information and sessions.
- Revenue Tracking: Record revenue-related data.
- Feature Flags: Dynamically manage feature flags for A/B testing or feature rollouts.
- Deep Link Handling: Handle deep links for navigation or other purposes.
- Product Management: Track product lists and related data.
- Crash Reporting: Integrates with Crashlytics for error and crash reporting.
- SDK Initialization: Flexible initialization options with customizable configurations.

---

## Key Methods

### `initSDK`
Initializes the SDK with the required credentials and options.

**Declaration**:  
`static public func initSDK(partnerCode: String, appSecret: String, options: AirflexOptions)`

**Parameters**:  
- `partnerCode`: The partner code for authentication.  
- `appSecret`: The app secret for authentication.  
- `options`: An instance of `AirflexOptions` for additional configurations.

**Usage**:  
Define options and initialize the SDK:  
`Airflex.initSDK(partnerCode: "your_partner_code", appSecret: "your_app_secret", options: options)`

---

### `logEvent`
Logs a custom event with optional data.

**Declaration**:  
`static public func logEvent(name: String, data: [String: Any]?)`

**Parameters**:  
- `name`: The name of the event.  
- `data`: Additional data associated with the event.

**Usage**:  
Log an event:  
`Airflex.logEvent(name: "event_name", data: ["key": "value"])`

---

### `setUserInfo`
Sets the user information for session management.

**Declaration**:  
`static public func setUserInfo(userInfo: UserInfo)`

**Parameters**:  
- `userInfo`: An instance of `UserInfo` containing user details.

**Usage**:  
Set user information:  
`Airflex.setUserInfo(userInfo: userInfo)`

---

### `setRevenue`
Records revenue-related data.

**Declaration**:  
`static public func setRevenue(orderId: String, amount: Double, currency: String, data: [String: Any]?)`

**Parameters**:  
- `orderId`: The order ID.  
- `amount`: The revenue amount.  
- `currency`: The currency code.  
- `data`: Additional data related to the revenue.

**Usage**:  
Record revenue:  
`Airflex.setRevenue(orderId: "order123", amount: 99.99, currency: "USD", data: ["key": "value"])`

---

### `handleDeeplink`
Handles incoming deep links and executes a callback.

**Declaration**:  
`public static func handleDeeplink(_ handleDeeplink: @escaping (String) -> Void)`

**Parameters**:  
- `handleDeeplink`: A closure that takes a `String` parameter representing the deep link URL.

**Usage**:  
Handle a deep link:  
`Airflex.handleDeeplink { deeplink in print("Received deeplink: \(deeplink)") }`

---

### `setFlag`
Sets a feature flag with a key-value pair.

**Declaration**:  
`public static func setFlag(flagKey: String, flagValue: String, description: String = "", completion: @escaping (FlagData) -> Void)`

**Parameters**:  
- `flagKey`: The key of the feature flag.  
- `flagValue`: The value of the feature flag.  
- `description`: A description of the flag (optional).  
- `completion`: A closure that returns the `FlagData`.

**Usage**:  
Set a feature flag:  
`Airflex.setFlag(flagKey: "feature_x", flagValue: "enabled", description: "Enable feature X") { flagData in print(flagData) }`

---

### `clear`
Clears all session data and resets the SDK.

**Declaration**:  
`static public func clear()`

**Usage**:  
Clear session data:  
`Airflex.clear()`

---

## Development Notes

- Logging: Use `Airflex.setDevMode(true)` to enable debug logs during development.  
- Crash Reporting: Ensure Crashlytics is properly configured in your project for error reporting.  
- Dependencies: The SDK integrates with external services like Crashlytics. Ensure all required dependencies are installed.

---

## Testing

- Simulate various scenarios such as event tracking, deep link handling, and revenue tracking.  
- Use unit tests to validate the behavior of each method.

---

## Contribution Guidelines

- Follow the coding standards defined in the project.  
- Ensure all changes are tested thoroughly.  
- Submit pull requests with detailed descriptions of changes.

---

## License

This project is licensed under the [insert license type, e.g., MIT License]. See the `LICENSE` file for more details.
