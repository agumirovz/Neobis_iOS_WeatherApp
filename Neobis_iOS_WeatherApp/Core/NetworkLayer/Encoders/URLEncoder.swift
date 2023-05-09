//
//  URLEncoder.swift
//  Neobis_iOS_WeatherApp
//
//  Created by G G on 09.05.2023.
//

import Foundation

struct URLEncoder {
    
    static func encode(
        urlRequest: inout URLRequest,
        with parameters: Parameters
    ) throws {
        guard let url = urlRequest.url else { throw EncoderError.parametersNil }
        
        if var urlComponent = URLComponents(
            url: url,
            resolvingAgainstBaseURL: false
        ), !parameters.isEmpty {
            
            urlComponent.queryItems = [URLQueryItem]()
            
            for (key, value) in parameters {
                
                let queryItem = URLQueryItem(
                    name: key,
                    value: "\(value)"
                        .addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
                )
                
                urlComponent.queryItems?.append(queryItem)
            }
            
            urlRequest.url = urlComponent.url
        }
        
        if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
            urlRequest.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
        }
    }
}

public enum EncoderError : String, Error {
    case parametersNil = "Parameters were nil."
    case encodingFailed = "Parameter encoding failed."
    case missingURL = "URL is nil."
}
