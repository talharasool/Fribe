//
//  FribeProtocols.swift
//  FribeApp
//
//  Created by mac on 15/06/2024.
//

import Foundation

// Protocol for a successful API response
public protocol APIResponse: Codable {}

// Protocol for handling Place Search responses
public protocol PlaceSearchDelegate: AnyObject {
    func didReceivePlaceSearch(places: [Place], _ pagination : Pagination)
    func didFailReceivePlaceSearch(_ message : String)
}


public protocol NearbySearchDelegate: AnyObject {
    func didReceiveNearbySearch(places: [Place])
    func didFailReceiveNearbySearch(_ message : String)
}

// Protocol for handling Place Details responses
public protocol PlaceDetailsDelegate: AnyObject {
    func didReceivePlaceDetailsResponse(place: Place)
    func didFailReceivePlaceDetailsResponse(_ message : String)
}

// Protocol for handling errors
public protocol FribeServiceErrorDelegate: AnyObject {
    func didFailWithError(error: Error)
}

// Protocol for handling network errors
public protocol NetworkErrorHandling {
    func handleNetworkError(error: NetworkError)
}

// Protocol for handling timeout errors
public protocol TimeoutErrorHandling {
    func handleTimeoutError()
}

// Protocol for handling server errors
public protocol ServerErrorHandling {
    func handleServerError(error: Error)
}

// Protocol for handling Distance with Geometry Polyline
public protocol DistanceWithPolylineDelegate: AnyObject {
    func didReceiveDistanceWithGeometryResponse(_ distancePolyline: DistanceWithPolylineData)
    func didFailReceiveDistanceWithGeometryResponse(_ message: String)
}

// Protocol for handling Distance with Geometry GEOJSON
public protocol DistanceWithGEOJSONDelegate: AnyObject {
    func didReceiveGEOJSON(_ distanceGEOJSON: GeoJSONData)
    func didFailReceiveDistanceWithGeometryResponse(_ message: String)
}

// Protocol for handling Distance Delegate
public protocol DistanceDelegate: AnyObject {
    func didReceiveDistanceResponse(distance: DistanceData)
    func didFailReceiveDistanceResponse(_ message: String)
}
