import Foundation


import Foundation

//PlaceDetailsResponse
public struct PlaceDetailsResponse: Codable, APIResponse {
    public let statusCode: Int
    public let data: Place?
    
    enum CodingKeys: String, CodingKey {
        case statusCode
        case data
    }
    
}


public struct PlaceSearchResponse: Codable, APIResponse {
    public let statusCode: Int
    public let message: String
    public let pagination: Pagination
    public let data: [Place]
    
    enum CodingKeys: String, CodingKey {
        case statusCode
        case message
        case pagination = "_pagination"
        case data
    }
}

public struct NearbySearchResponse: Codable, APIResponse {
    public let statusCode: Int
    public let message: String
    public let data: [Place]
    
    enum CodingKeys: String, CodingKey {
        case statusCode
        case message
        case data
    }
}

public struct Pagination: Codable {
    public let total: Int
    public let totalPage: Int
    public let currentPage: Int
}

public struct Place: Codable {
    public let id: String?
    public let shortId: String?
    public let formattedAddress: String
    public let name: String
    public let city: String
    public let country: String
    public let alpha2: String?
    public let alpha3: String?
    public let countryCode: String?
    public let latitude: Double?
    public let longitude: Double?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case shortId
        case formattedAddress
        case name
        case city
        case country
        case alpha2
        case alpha3
        case countryCode
        case latitude
        case longitude
    }
    
    // Computed properties to return the unwrapped value if available
    public var idValue: String {
        get { return id ?? "" }
    }
    
    public var shortIdValue: String {
        get { return shortId ?? "" }
    }
    
    public var formattedAddressValue: String {
        get { return formattedAddress }
    }
    
    public var nameValue: String {
        get { return name }
    }
    
    public var cityValue: String {
        get { return city }
    }
    
    public var countryValue: String {
        get { return country }
    }
    
    public var alpha2Value: String {
        get { return alpha2 ?? "" }
    }
    
    public var alpha3Value: String {
        get { return alpha3 ?? ""  }
    }
    
    public var countryCodeValue: String {
        get { return countryCode ?? "" }
    }
    
    public var latitudeValue: Double {
        get { return latitude ?? 0.0 }
    }
    
    public var longitudeValue: Double {
        get { return longitude ?? 0.0 }
    }
}

// Error response struct
public struct ErrorResponse: Codable {
    public let statusCode: Int
    public let message: String
    public let metadata: Metadata
    
    enum CodingKeys: String, CodingKey {
        case statusCode
        case message
        case metadata = "_metadata"
    }
}

public struct Metadata: Codable {
    public let languages: [String]
    public let requestId: String
    public let version: String
}


//MARK: Distance API Model

public struct DistanceWithGeometryResponse: Codable, APIResponse {
    public let statusCode: Int
    public let message: String
    public let data: DistanceWithPolylineData?
    
    enum CodingKeys: String, CodingKey {
        case statusCode
        case message
        case data
    }
}

public struct DistanceWithPolylineData: Codable {
    public let routes: [Route]?
    public let waypoints: [Waypoint]?
    public let distance: Double?
    public let duration: Double?
    
    enum CodingKeys: String, CodingKey {
        case routes
        case waypoints
        case distance
        case duration
    }
}

public struct Route: Codable {
    public let geometry: String?
    public let legs: [Leg]
    public let distance: Double?
    public let duration: Double?
    public let weightName: String?
    public let weight: Double?
    
    enum CodingKeys: String, CodingKey {
        case geometry
        case legs
        case distance
        case duration
        case weightName = "weight_name"
        case weight
    }
}

public struct Leg: Codable {
    public let steps: [Step]
    public let distance: Double?
    public let duration: Double?
    public let summary: String?
    public let weight: Double?
    
    enum CodingKeys: String, CodingKey {
        case steps
        case distance
        case duration
        case summary
        case weight
    }
}

public struct Step: Codable {
    public let intersections: [Intersection]
    public let drivingSide: String?
    public let geometry: String?
    public let mode: String?
    public let duration: Double?
    public let maneuver: Maneuver
    public let ref: String?
    public let weight: Double?
    public let distance: Double?
    public let name: String?
    
    enum CodingKeys: String, CodingKey {
        case intersections
        case drivingSide = "driving_side"
        case geometry
        case mode
        case duration
        case maneuver
        case ref
        case weight
        case distance
        case name
    }
}

public struct Intersection: Codable {
    public let out: Int?
    public let entry: [Bool]
    public let bearings: [Int]
    public let location: [Double]
    
    enum CodingKeys: String, CodingKey {
        case out
        case entry
        case bearings
        case location
    }
}

public struct Maneuver: Codable {
    public let bearingAfter: Int
    public let location: [Double]
    public let bearingBefore: Int
    public let type: String
    
    enum CodingKeys: String, CodingKey {
        case bearingAfter = "bearing_after"
        case location
        case bearingBefore = "bearing_before"
        case type
    }
}

public struct Waypoint: Codable {
    public let hint: String?
    public let distance: Double?
    public let name: String?
    public let location: [Double]
    
    enum CodingKeys: String, CodingKey {
        case hint
        case distance
        case name
        case location
    }
}


//DISTANCE MODEL With Annotation
public struct DistanceModel: Codable,APIResponse {
    public let statusCode: Int
    public let message: String
    public let data: DistanceData?
    
    enum CodingKeys: String, CodingKey {
        case statusCode
        case message
        case data
    }
}

public struct DistanceData: Codable {
    public let durations: [[Double]]
    public let destinations: [Location]
    public let sources: [Location]
    public let distances: [[Double]]?
    
    enum CodingKeys: String, CodingKey {
        case durations
        case destinations
        case sources
        case distances
    }
}

public struct Location: Codable {
    public let hint: String
    public let distance: Double
    public let name: String
    public let location: [Double]
    
    enum CodingKeys: String, CodingKey {
        case hint
        case distance
        case name
        case location
    }
}


// MARK: - GeoJSONResponse
public struct GeoJSONResponse: Codable,APIResponse {
    let statusCode: Int
    let message: String
    let data: GeoJSONData
}

// MARK: - GeoJSONData
public struct GeoJSONData: Codable {
    let routes: [GeoJSONRoute]
    let waypoints: [GeoJSONWaypoint]
    let distance: Double
    let duration: Double
}

// MARK: - GeoJSONRoute
public struct GeoJSONRoute: Codable {
    let geometry: GeoJSONGeometry
    let legs: [GeoJSONLeg]
    let distance: Double
    let duration: Double
    let weightName: String
    let weight: Double

    enum CodingKeys: String, CodingKey {
        case geometry, legs, distance, duration
        case weightName = "weight_name"
        case weight
    }
}

// MARK: - GeoJSONGeometry
public struct GeoJSONGeometry: Codable {
    let coordinates: [[Double]]
    let type: String
}

// MARK: - GeoJSONLeg
public struct GeoJSONLeg: Codable {
    let steps: [GeoJSONStep]
    let distance: Double
    let duration: Double
    let summary: String
    let weight: Double
}

// MARK: - GeoJSONStep
public struct GeoJSONStep: Codable {
    let intersections: [GeoJSONIntersection]
    let drivingSide: String
    let geometry: GeoJSONGeometry
    let mode: String
    let duration: Double
    let maneuver: GeoJSONManeuver
    let ref: String
    let weight: Double
    let distance: Double
    let name: String

    enum CodingKeys: String, CodingKey {
        case intersections
        case drivingSide = "driving_side"
        case geometry, mode, duration, maneuver, ref, weight, distance, name
    }
}

// MARK: - GeoJSONIntersection
public struct GeoJSONIntersection: Codable {
    let out: Int?
    let entry: [Bool]
    let bearings: [Int]
    let location: [Double]
    let `in`: Int?

    enum CodingKeys: String, CodingKey {
        case out, entry, bearings, location
        case `in` = "in"
    }
}

// MARK: - GeoJSONManeuver
public struct GeoJSONManeuver: Codable {
    let bearingAfter: Int
    let location: [Double]
    let bearingBefore: Int
    let type: String

    enum CodingKeys: String, CodingKey {
        case bearingAfter = "bearing_after"
        case location
        case bearingBefore = "bearing_before"
        case type
    }
}

// MARK: - GeoJSONWaypoint
public struct GeoJSONWaypoint: Codable {
    let hint: String
    let distance: Double
    let name: String
    let location: [Double]
}

