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
