# AirflexAdView Class Developer Documentation

## Overview

The `AirflexAdView` class is a customizable view for displaying advertisements. It supports different ad types, handles ad fetching, and provides functionality for user interaction with ads.

---

## Features

- **Ad Display**: Displays ads in a customizable view.
- **Ad Fetching**: Fetches ad content from the server.
- **Ad Interaction**: Handles user interactions such as clicks.
- **Pagination Support**: Supports paginated ad content using `UIPageViewController`.

---

## Key Methods

### `init(context: UIView, adType: AdType, adId: String)`
Initializes the `AirflexAdView` with the specified context, ad type, and ad ID.

**Parameters**:
- `context`: The parent view where the ad will be displayed.
- `adType`: The type of the ad (`BANNER` or `PRODUCT`).
- `adId`: The unique identifier for the ad.

**Usage**:
AirflexAdView(context: parentView, adType: .BANNER, adId: "ad123")

---

### `showAd()`
Displays the ad by fetching its content and rendering it in the view.

**Usage**:
airflexAdView.showAd()

---

### `setOnClickAd(_ callback: @escaping (String, String) -> Void)`
Sets a callback to handle ad click events.

**Parameters**:
- `callback`: A closure that takes the ad ID and additional data as parameters.

**Usage**:
airflexAdView.setOnClickAd { adId, data in
    print("Ad clicked: \(adId)")
}

---

### `layoutSubviews()`
Overrides the default layout behavior to adjust the size and position of the ad view.

**Usage**:
This method is called automatically during layout updates.

---

## Development Notes

- Ensure that the `AirflexAdHelper` is properly configured for fetching ads.
- Use the `setOnClickAd` method to handle user interactions with ads.
- The `UIPageViewController` is used for paginated ad content.

---

## Testing

- Test ad fetching with valid and invalid `adId` values.
- Verify that the ad content is displayed correctly for different ad types.
- Simulate user interactions and ensure the click callback is triggered.

---

## Contribution Guidelines

- Follow the coding standards defined in the project.
- Ensure all changes are tested thoroughly.
- Submit pull requests with detailed descriptions of changes.

---

## License

This project is licensed under the [insert license type, e.g., MIT License]. See the `LICENSE` file for more details.
