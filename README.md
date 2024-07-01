# Fribe

Fribe is a powerful Swift SDK that allows you to interact with the Fribe API for place search, place details, distance calculations, and more. This SDK is designed to be easy to integrate and use within your iOS projects.

## Overview

The Fribe SDK simplifies the process of making API requests to the Fribe service. It handles networking, error handling, and response parsing, providing you with clean and usable data.

## Setup

To start using the Fribe SDK, you need to configure it with your API keys.

### Configure SDK

```swift
import FribeSDK

// Configure the SDK with your API keys
FribeSDKConfiguration.shared.setup(clientId: "your-client-id", secretKey: "your-secret-key", publishableKey: "your-publishable-key")

## Usage

### Initialize FribeService

Create an instance of `FribeService` and set the necessary delegates to handle responses and errors.

```swift
import FribeSDK

class YourViewController: UIViewController, PlaceSearchDelegate, PlaceDetailsDelegate, DistanceDelegate, DistanceWithPolylineDelegate, DistanceWithGEOJSONDelegate, NearbySearchDelegate, FribeServiceErrorDelegate {
    
    private var fribeService: FribeService?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize the Fribe service with the appropriate delegates
        fribeService = FribeService(
            placeSearchDelegate: self,
            placeDetailsDelegate: self,
            distanceDelegate: self,
            distanceWithPolylineDelegate: self,
            distanceWithGEOJSONDelegate: self,
            nearbySearchDelegate: self,
            errorDelegate: self
        )
    }
}

## Making API Requests
### Search Places

```swift
fribeService?.request(.searchPlaces(text: "salon"))
```
### Get Place Details
```swift
fribeService?.request(.searchPlaceDetails(text: "oman", location: "some-location"))
```
### Calculate Distance
```swift
fribeService?.request(.distance(originLatLng: "57.535793,22.376252", destinationLatLng: "57.535236,22.376083", annotations: ["distance", "duration"]))
```
### Get Distance with Polyline Geometry
```swift
fribeService?.request(.distanceWithPolyline(originLatLng: "17.6125018,54.0344293", destinationLatLng: "21.473534,55.975414", steps: true, overview: .simplified))
```
### Get Distance with GeoJSON Geometry
```swift
fribeService?.request(.distanceWithGeoJSON(originLatLng: "17.6125018,54.0344293", destinationLatLng: "21.473534,55.975414", steps: true, overview: .simplified))
```
### Nearby Search
```swift
fribeService?.request(.nearbySearch(location: "some-location", radius: "500", locationName: "some-name"))
```
