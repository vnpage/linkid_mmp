# Airflex SDK Development Documentation

## Overview

The `Airflex` SDK is a modular and extensible solution designed for iOS applications. It provides functionalities for event tracking, user session management, revenue tracking, feature flagging, and deep link handling. The SDK is built to integrate seamlessly with external services like Crashlytics and offers multiple initialization options for flexibility.

---

## Features

- **Event Tracking**: Log custom events and screen views.
- **User Session Management**: Manage user information and sessions.
- **Revenue Tracking**: Record revenue-related data.
- **Feature Flags**: Dynamically manage feature flags for A/B testing or feature rollouts.
- **Deeplink Handling**: Handle deep links for navigation or other purposes.
- **Product Management**: Track product lists and related data.
- **Crash Reporting**: Integrates with Crashlytics for error and crash reporting.
- **SDK Initialization**: Flexible initialization options with customizable configurations.

---

## Project Structure

- **`Airflex.swift`**: Core implementation of the SDK.
- **`TrackingEvent`**: Handles event tracking.
- **`SessionManager`**: Manages user sessions and authentication.
- **`Crashlytics`**: Integrates crash reporting.
- **`FlagHelper`**: Manages feature flags.
- **`StorageHelper`**: Handles persistent storage for SDK data.
- **`DeviceInfo`**: Provides device-related information.

---

## Initialization

The SDK provides multiple ways to initialize:

### Basic Initialization
```swift
Airflex.initSDK(partnerCode: "your_partner_code", appSecret: "your_app_secret")
```
### Initialization with Options
```swift
let options = AirflexOptions()
options.showLog = true
options.autoTrackingScreen = true
Airflex.initSDK(partnerCode: "your_partner_code", appSecret: "your_app_secret", options: options)
```
### Initialization with Extra Code
```swift
Airflex.initSDK(partnerCode: "your_partner_code", appSecret: "your_app_secret", extra: "extra_code")
```
## Key Methods
### Event Tracking
```swift
let userInfo = UserInfo(userId: "12345", name: "John Doe")
Airflex.setUserInfo(userInfo: userInfo)
Airflex.removeUserToken()
```
### User Session Management
```swift
let userInfo = UserInfo(userId: "12345", name: "John Doe")
Airflex.setUserInfo(userInfo: userInfo)
Airflex.removeUserToken()
```
### Revenue Tracking
```swift
Airflex.setRevenue(orderId: "order123", amount: 99.99, currency: "USD", data: ["key": "value"])
```
### Feature Flags
```swift
Airflex.setFlag(flagKey: "feature_x", flagValue: "enabled", description: "Enable feature X") { flagData in
    print(flagData)
}

Airflex.getFlags(limit: 10, offset: 0) { flagData in
    print(flagData)
}
```
### Deep Link Handling
```swift
Airflex.handleDeeplink { deeplink in
    print("Received deeplink: \(deeplink)")
}
```
### Product Management
```swift
let products = [ProductItem(id: "1", name: "Product A"), ProductItem(id: "2", name: "Product B")]
Airflex.setProductList(listName: "Featured Products", products: products)
```
## Development Notes
- Logging: Use Airflex.setDevMode(true) to enable debug logs during development.
- Crash Reporting: Ensure Crashlytics is properly configured in your project for error reporting.
- Dependencies: The SDK integrates with external services like Crashlytics. Ensure all required dependencies are installed.

## Testing
- Unit tests are included for core functionalities.
- Use XCTest framework for running tests.
- Ensure to run tests on both simulator and physical devices for comprehensive coverage.
- Mock data can be used for testing purposes.


## Author

Tuan Dinh, tuandv@lynkid.vn

## License

linkid_mmp is available under the MIT license. See the LICENSE file for more info.
