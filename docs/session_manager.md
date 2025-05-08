# SessionManager Class Developer Documentation

## Overview

The `SessionManager` class is responsible for managing user sessions, authentication, and device information updates. It provides methods for handling authentication, updating session data, and managing deep link sessions.

---

## Features

- Session Management: Handles user session initialization and updates.
- Authentication: Authenticates the SDK with partner credentials.
- Deep Link Handling: Sends session-related deep link data.
- Device Info Updates: Updates device information to the server.
- Token Management: Manages user tokens and clears session data.

---

## Key Methods

### `retry`
Retries the authentication process by resetting the current token and reinitializing the session.

**Declaration**:  
`class func retry()`

**Usage**:  
SessionManager.retry()

---

### `sendSessionDeeplink`
Sends the last deep link data to the server.

**Declaration**:  
`public class func sendSessionDeeplink()`

**Usage**:  
SessionManager.sendSessionDeeplink()

---

### `authWithBaseUrl`
Authenticates the SDK using the provided partner credentials and base URL.

**Declaration**:  
`public class func authWithBaseUrl(partnerCode: String, appSecret: String, baseUrl: String)`

**Parameters**:  
- `partnerCode`: The partner code for authentication.  
- `appSecret`: The app secret for authentication.  
- `baseUrl`: The base URL for the API.

**Usage**:  
SessionManager.authWithBaseUrl(partnerCode: "partner_code", appSecret: "app_secret", baseUrl: "https://api.example.com")

---

### `auth`
Authenticates the SDK using the partner credentials and generates the base URL.

**Declaration**:  
`public class func auth(partnerCode: String, appSecret: String)`

**Parameters**:  
- `partnerCode`: The partner code for authentication.  
- `appSecret`: The app secret for authentication.

**Usage**:  
SessionManager.auth(partnerCode: "partner_code", appSecret: "app_secret")

---

### `updateInfo`
Updates the device information on the server.

**Declaration**:  
`public class func updateInfo(data: [String: Any]?)`

**Parameters**:  
- `data`: A dictionary containing the device information to update.

**Usage**:  
SessionManager.updateInfo(data: ["key": "value"])

---

### `clear`
Clears all session data and resets the SDK.

**Declaration**:  
`public class func clear()`

**Usage**:  
SessionManager.clear()

---

### `removeUserToken`
Removes the Firebase token associated with the user.

**Declaration**:  
`public class func removeUserToken()`

**Usage**:  
SessionManager.removeUserToken()

---

## Development Notes

- Ensure that the `baseUrl` is properly configured before calling authentication methods.
- Use the `updateInfo` method to keep device information up-to-date.
- Handle errors returned by the server in the callback closures.

---

## Testing

- Test authentication with valid and invalid credentials.
- Simulate deep link scenarios and verify that the session data is sent correctly.
- Validate that device information updates are reflected on the server.

---

## Contribution Guidelines

- Follow the coding standards defined in the project.
- Ensure all changes are tested thoroughly.
- Submit pull requests with detailed descriptions of changes.

---

## License

This project is licensed under the [insert license type, e.g., MIT License]. See the `LICENSE` file for more details.
