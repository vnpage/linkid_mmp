# AirflexAdHelper Class Developer Documentation

## Overview

The `AirflexAdHelper` class provides functionalities for managing and tracking advertisements. It includes methods for displaying ads, retrieving ad data, and tracking ad impressions and clicks.

---

## Features

- **Ad Display**: Displays advertisements.
- **Ad Retrieval**: Fetches ad data from the server.
- **Ad Tracking**: Tracks ad impressions and clicks.

---

## Key Methods

### `showAd`
Displays an advertisement.

**Declaration**:  
`public static func showAd()`

**Usage**:  
AirflexAdHelper.showAd()

---

### `getAd`
Fetches ad data from the server using the provided ad ID and ad type.

**Declaration**:  
`public static func getAd(adId: String, adType: String, callback: @escaping (AdItem?) -> Void)`

**Parameters**:  
- `adId`: The ID of the advertisement.  
- `adType`: The type of the advertisement.  
- `callback`: A closure that returns an optional `AdItem` object.

**Usage**:  
AirflexAdHelper.getAd(adId: "ad123", adType: "banner") { adItem in  
&nbsp;&nbsp;&nbsp;&nbsp;if let ad = adItem {  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;// Handle the ad item  
&nbsp;&nbsp;&nbsp;&nbsp;}  
}

---

### `trackImpression`
Tracks an ad impression.

**Declaration**:  
`public static func trackImpression(adId: String, productId: String = "")`

**Parameters**:  
- `adId`: The ID of the advertisement.  
- `productId`: The ID of the product (optional).

**Usage**:  
AirflexAdHelper.trackImpression(adId: "ad123", productId: "product456")

---

### `trackClick`
Tracks an ad click.

**Declaration**:  
`public static func trackClick(adId: String, productId: String = "")`

**Parameters**:  
- `adId`: The ID of the advertisement.  
- `productId`: The ID of the product (optional).

**Usage**:  
AirflexAdHelper.trackClick(adId: "ad123", productId: "product456")

---

## Development Notes

- Ensure that the `HttpClient` is properly configured before using methods that interact with the server.
- Use the `callback` parameter in `getAd` to handle the retrieved ad data.

---

## Testing

- Test ad retrieval with valid and invalid `adId` and `adType` values.
- Verify that ad impressions and clicks are tracked correctly on the server.
- Simulate scenarios where the server returns errors to ensure proper error handling.

---

## Contribution Guidelines

- Follow the coding standards defined in the project.
- Ensure all changes are tested thoroughly.
- Submit pull requests with detailed descriptions of changes.

---

## License

This project is licensed under the [insert license type, e.g., MIT License]. See the `LICENSE` file for more details.
