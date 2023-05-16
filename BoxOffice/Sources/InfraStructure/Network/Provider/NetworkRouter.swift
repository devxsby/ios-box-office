//
//  NetworkRouter.swift
//  BoxOffice
//
//  Created by Mason Kim on 2023/04/27.
//

import Foundation

protocol NetworkRouterProtocol: AnyObject {
    func request<T: Decodable>(with endPoint: EndPointType,
                               completion: @escaping (Result<T, NetworkError>) -> Void)
    func request(with urlString: String,
                 completion: @escaping (Result<Data, NetworkError>) -> Void)
    func cancel(with endPoint: EndPointType)
    func cancel(with url: String)
}

final class NetworkRouter: NetworkRouterProtocol {
    
    // MARK: - Properties
    
    private var tasks: [URLRequest: URLSessionDataTask] = [:]
    private let session: URLSessionProtocol
    private let decoder = JSONDecoder()
    
    // MARK: - Initialization
    
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    // MARK: - Public Methods
    
    func request<T: Decodable>(with endPoint: EndPointType,
                               completion: @escaping (Result<T, NetworkError>) -> Void) {
        guard let urlRequest = buildRequest(from: endPoint) else {
            completion(.failure(.invalidURL))
            return
        }
        
        perform(request: urlRequest) { result in
            switch result {
            case .success(let data):
                do {
                    print("✨✨✨✨✨✨✨✨✨", endPoint, data)
                    let decodedData = try self.decoder.decode(T.self, from: data)
                    completion(.success(decodedData))
                } catch {
                    completion(.failure(.parseError))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func request(with urlString: String,
                 completion: @escaping (Result<Data, NetworkError>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }
        let urlRequest = URLRequest(url: url)
        
        return perform(request: urlRequest, completion: completion)
    }
    
    func cancel(with endPoint: EndPointType) {
        guard let request = buildRequest(from: endPoint) else { return }
        tasks[request]?.cancel()
    }
    
    func cancel(with url: String) {
        guard let url = URL(string: url) else { return }
        let request = URLRequest(url: url)
        tasks[request]?.cancel()
    }
    
    // MARK: - Private Methods
    
    private func perform(request: URLRequest,
                         completion: @escaping (Result<Data, NetworkError>) -> Void) {
        let task = session.dataTask(with: request, completionHandler: { [weak self] data, response, error in
            self?.tasks.removeValue(forKey: request)
            
            if let error = error {
                completion(.failure(.transportError(error)))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse,
               !(200..<300).contains(httpResponse.statusCode) {
                completion(.failure(.responseError(statusCode: httpResponse.statusCode)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            completion(.success(data))
        })
        
        task.resume()
        
        tasks.updateValue(task, forKey: request)
    }
    
    private func buildRequest(from endPoint: EndPointType) -> URLRequest? {
        
        var urlComponents = URLComponents(string: endPoint.baseURL)
        urlComponents?.path += endPoint.path
        
        switch endPoint.task {
        case .request:
            break
        case .requestWithQueryParameters(let queryParameters):
            let queryItems = queryParameters.map { key, value in
                URLQueryItem(name: key, value: value)
            }
            urlComponents?.queryItems = queryItems
        }
        
        guard let url = urlComponents?.url else { return nil }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = endPoint.httpMethod.rawValue
        
        endPoint.headers.forEach { key, value in
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }
        
        return urlRequest
    }
}
