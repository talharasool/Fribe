import Foundation

@available(macOS 10.15, *)
public class NetworkManager {
    
    // Singleton instance of NetworkManager
    public static let shared = NetworkManager()
    
    // Private initializer to prevent instantiation
    private init() {}
    
    // Asynchronous function to make a network request with given endpoint and parameters
    public func request(endpoint: String, parameters: [String: String], timeout: TimeInterval = 30.0) async throws -> Data {
        // Construct URL components from endpoint
        guard var urlComponents = URLComponents(string: endpoint) else {
            throw NetworkError.invalidURL
        }
        
        // Add query items from parameters
        urlComponents.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        
        // Construct URL from components
        guard let url = urlComponents.url else {
            throw NetworkError.invalidURL
        }
        
        // Create a URL request with timeout interval
        var request = URLRequest(url: url)
        request.timeoutInterval = timeout
        
        // Add headers to the request
        if let clientId = FribeSDKConfiguration.shared.getClientId() {
            request.addValue(clientId, forHTTPHeaderField: "Client-ID")
        }
        
        if let secretKey = FribeSDKConfiguration.shared.getSecretKey() {
            request.addValue(secretKey, forHTTPHeaderField: "Secret-Key")
        }
        
        if let publishableKey = FribeSDKConfiguration.shared.getPublishableKey() {
            request.addValue(publishableKey, forHTTPHeaderField: "Publishable-Key")
        }
        
        // Perform the network request and return the data
        return try await fetchData(for: request)
    }
    
    // Helper function to fetch data using URLSession with continuation
    private func fetchData(for request: URLRequest) async throws -> Data {
        return try await withCheckedThrowingContinuation { continuation in
            // Create a data task with the request
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    // Handle network errors
                    if let urlError = error as? URLError, urlError.code == .timedOut {
                        continuation.resume(throwing: NetworkError.timeout)
                    } else {
                        continuation.resume(throwing: NetworkError.networkError(error))
                    }
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    // Resume with an error if no response is received
                    continuation.resume(throwing: NetworkError.invalidResponse)
                    return
                }
                
                if !(200..<300 ~= httpResponse.statusCode) {
                    // Handle error response
                    if let data = data, httpResponse.statusCode >= 400 {
                        do {
                            let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: data)
                            continuation.resume(throwing: NetworkError.serverErrorWithResponse(errorResponse))
                        } catch {
                            continuation.resume(throwing: NetworkError.serverError)
                        }
                    } else {
                        continuation.resume(throwing: NetworkError.serverError)
                    }
                    return
                }
                
                guard let data = data else {
                    // Resume with an error if no data is returned
                    continuation.resume(throwing: NetworkError.invalidResponse)
                    return
                }
                
                // Resume with the returned data
                continuation.resume(returning: data)
            }.resume() // Start the data task
        }
    }
}

// Define possible network errors
public enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case timeout
    case networkError(Error)
    case serverError
    case serverErrorWithResponse(ErrorResponse)
}

// Error response struct
