import Foundation

public enum FribeActions {
    case searchPlaces(text: String)
    case searchPlaceDetails(text: String, location: String?)
    case distance(originLatLng: String, destinationLatLng: String, annotations: [String] = [])
    case distanceWithPolyline(originLatLng: String, destinationLatLng: String, steps: Bool = true, overview: GeometryOverview = .simplified)
    case distanceWithGeoJSON(originLatLng: String, destinationLatLng: String, steps: Bool = true, overview: GeometryOverview = .simplified)
    case nearbySearch(location: String, radius: String? = nil, locationName : String? = nil)
    
    var url: String {
        switch self {
        case .searchPlaces:
            return "https://maps.fribe.io/api/user/place/textsearch"
        case .searchPlaceDetails:
            return "https://maps.fribe.io/api/user/place/findplacefromtext"
        case .distance:
            return "https://maps.fribe.io/api/user/place/distance"
        case .distanceWithPolyline:
            return "https://maps.fribe.io/api/user/place/directions"
        case .distanceWithGeoJSON:
            return "https://maps.fribe.io/api/user/place/directions"
        case .nearbySearch:
            return "https://maps.fribe.io/api/user/place/nearbysearch"
        }
    }
    
    var parameters: [String: String] {
        switch self {
        case .searchPlaces(let text):
            return ["search": text, "publishableKey": FribeSDKConfiguration.shared.getPublishableKey() ?? ""]
        case .searchPlaceDetails(let text, let location):
            var params = ["search": text, "publishableKey": FribeSDKConfiguration.shared.getPublishableKey() ?? ""]
            if let location = location {
                print("The location is here")
                params["location"] = location
            }
            return params
        case .distance(let originLatLng, let destinationLatLng, let annotations):
            
            var params = [
                "origin_latlng": originLatLng,
                "destination_latlg": destinationLatLng,
                "publishableKey": FribeSDKConfiguration.shared.getPublishableKey() ?? "",
              ]
            if !(annotations.isEmpty){
                params["annotations"] = annotations.joined(separator: ",")
            }
            return params
            
        case .distanceWithPolyline(let originLatLng, let destinationLatLng, let steps, let overview):
            return [
                "origin_latlng": originLatLng,
                "destination_latlg": destinationLatLng,
                "steps": steps ? "true" : "false",
                "publishableKey": FribeSDKConfiguration.shared.getPublishableKey() ?? "",
                "geometries": GeometryType.polyline.rawValue,
                "overview": overview.rawValue
            ]
    
        case .distanceWithGeoJSON(let originLatLng, let destinationLatLng, let steps, let overview):
            return [
                "origin_latlng": originLatLng,
                "destination_latlg": destinationLatLng,
                "steps": steps ? "true" : "false",
                "publishableKey": FribeSDKConfiguration.shared.getPublishableKey() ?? "",
                "geometries": GeometryType.geojson.rawValue,
                "overview": overview.rawValue
            ]
            
        case .nearbySearch(location: let location, radius: let radius, locationName: let locationName):
            var params = [
                "location": location,
                "publishableKey": FribeSDKConfiguration.shared.getPublishableKey() ?? "",
              ]
            if let radius = radius {
                params["radius"] = radius
            }
            if let locationName = locationName {
                params["name"] = locationName
            }
            return params
        }
    }
}

public enum GeometryType: String {
    case polyline
    case geojson
}


public enum GeometryOverview: String {
    case simplified
}
