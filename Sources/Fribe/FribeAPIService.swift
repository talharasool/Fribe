import Foundation

@available(macOS 10.15, *)
public class FribeService {
    
    // Base URL for the API
    private let baseUrl = "https://maps.fribe.io"
    
    // Delegates to handle responses and errors
    public weak var placeSearchDelegate: PlaceSearchDelegate?
    public weak var placeDetailsDelegate: PlaceDetailsDelegate?
    public weak var nearbySearchDelegate: NearbySearchDelegate?
    public weak var distanceDelegate: DistanceDelegate?
    public weak var distanceWithPolylineDelegate: DistanceWithPolylineDelegate?
    public weak var distanceWithGEOJSONDelegate: DistanceWithGEOJSONDelegate?
    public weak var errorDelegate: FribeServiceErrorDelegate?
    
    
    // Initializer
    public init(placeSearchDelegate: PlaceSearchDelegate? = nil, placeDetailsDelegate: PlaceDetailsDelegate? = nil, distanceDelegate: DistanceDelegate? = nil, distancePolylineDelegate: DistanceWithPolylineDelegate? = nil, nearbySearchDelegate : NearbySearchDelegate? = nil, distanceWithGEOJSONDelegate : DistanceWithGEOJSONDelegate? = nil, errorDelegate: FribeServiceErrorDelegate? = nil) {
        self.placeSearchDelegate = placeSearchDelegate
        self.placeDetailsDelegate = placeDetailsDelegate
        self.distanceDelegate = distanceDelegate
        self.distanceWithPolylineDelegate = distancePolylineDelegate
        self.nearbySearchDelegate = nearbySearchDelegate
        self.distanceWithGEOJSONDelegate = distanceWithGEOJSONDelegate
        self.errorDelegate = errorDelegate
    }
    
    // Function to handle API requests
    public func request(_ action: FribeActions, timeout: TimeInterval = 30.0) {
        Task {
            do {
                // Perform the request and notify delegate with the response
                switch action {
                case .searchPlaces:
                    let response: PlaceSearchResponse = try await performRequest(action: action, responseType: PlaceSearchResponse.self, timeout: timeout)
                    if response.statusCode == 200 {
                        placeSearchDelegate?.didReceivePlaceSearch(places: response.data, response.pagination)
                    } else {
                        placeSearchDelegate?.didFailReceivePlaceSearch(response.message)
                    }
                    
                case .searchPlaceDetails:
                    let response: PlaceDetailsResponse = try await performRequest(action: action, responseType: PlaceDetailsResponse.self, timeout: timeout)
                    if response.statusCode == 200 {
                        if let data = response.data {
                            placeDetailsDelegate?.didReceivePlaceDetailsResponse(place: data)
                        } else {
                            placeDetailsDelegate?.didFailReceivePlaceDetailsResponse("Sorry the details aren't available")
                        }
                    } else {
                        placeDetailsDelegate?.didFailReceivePlaceDetailsResponse("Sorry the details aren't available")
                    }
                
                case .distance:
                    let response: DistanceModel = try await performRequest(action: action, responseType: DistanceModel.self, timeout: timeout)
                    if response.statusCode == 200 {
                        if let data = response.data {
                            distanceDelegate?.didReceiveDistanceResponse(distance: data)
                        } else {
                         
                            distanceDelegate?.didFailReceiveDistanceResponse("Sorry, the distance data isn't available")
                        }
                    } else {
                        print("Invalid Params")
                        distanceDelegate?.didFailReceiveDistanceResponse(response.message)
                    }
                
                case .distanceWithPolyline:
                    let response: DistanceWithGeometryResponse = try await performRequest(action: action, responseType: DistanceWithGeometryResponse.self, timeout: timeout)
                    if response.statusCode == 200 {
                        if let data = response.data {
                            distanceWithPolylineDelegate?.didReceiveDistanceWithGeometryResponse(data)
                        } else {
                            distanceWithPolylineDelegate?.didFailReceiveDistanceWithGeometryResponse("Sorry, the distance with geometry data isn't available")
                        }
                    } else {
                        distanceWithPolylineDelegate?.didFailReceiveDistanceWithGeometryResponse(response.message)
                    }
                case .nearbySearch:
                    let response: NearbySearchResponse = try await performRequest(action: action, responseType: NearbySearchResponse.self, timeout: timeout)
                    if response.statusCode == 200 {
                        let nearByPlaces =  response.data
                        if(nearByPlaces.isEmpty){
                            nearbySearchDelegate?.didFailReceiveNearbySearch("Sorry, the location doesn't exist")
                        }else{
                            nearbySearchDelegate?.didReceiveNearbySearch(places: nearByPlaces)
                        }
                    } else {
                        placeSearchDelegate?.didFailReceivePlaceSearch(response.message)
                    }
                case .distanceWithGeoJSON:
                    print("API CALL FOR DISTANCE JSON")
                    
                    let response: GeoJSONResponse = try await performRequest(action: action, responseType: GeoJSONResponse.self, timeout: timeout)
                    
                    if response.statusCode == 200 {
                        let result = response.data
            
                        distanceWithGEOJSONDelegate?.didReceiveGEOJSON(result)
                        
    
                    } else {
                        distanceWithGEOJSONDelegate?.didFailReceiveDistanceWithGeometryResponse(response.message)
                    }
                    
                }
            } catch {
                // Notify delegate with the error
                if let networkError = error as? NetworkError, case .serverErrorWithResponse(let errorResponse) = networkError {
                    errorDelegate?.didFailWithError(error: NSError(domain: "", code: errorResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: errorResponse.message]))
                } else {
                    errorDelegate?.didFailWithError(error: error)
                }
            }
        }
    }
    
    // Generic function to perform an API request
    private func performRequest<T: APIResponse>(action: FribeActions, responseType: T.Type, timeout: TimeInterval) async throws -> T {
        return try await withCheckedThrowingContinuation { continuation in
            DispatchQueue.global(qos: .background).async {
                let url = action.url
                let parameters = action.parameters
                Task {
                    do {
                        // Perform the network request
                        let data = try await NetworkManager.shared.request(endpoint: url, parameters: parameters, timeout: timeout)
                        // Decode the response data
                        let response = try JSONDecoder().decode(responseType, from: data)
                        // Deliver the result on the main queue
                        DispatchQueue.main.async {
                            continuation.resume(returning: response)
                        }
                    } catch {
                        // Deliver the error on the main queue
                        DispatchQueue.main.async {
                            continuation.resume(throwing: error)
                        }
                    }
                }
            }
        }
    }
}
