//
//  Codable+Extensions.swift
//  der Bus
//
//  Created by Shantanu Dutta on 08/02/19.
//  Copyright © 2019 Shantanu Dutta. All rights reserved.
//

import Foundation

enum JsonEncodeDecodeError: Error {
    case dataConversionFail
    case stringConverionFail
    var localizedDescription: String{
        switch self {
        case .dataConversionFail:
            return "<JsonEncodeDecodeError> : Failure in converting string to utf8 encoded data"
        case .stringConverionFail:
            return "<JsonEncodeDecodeError> : Failure in converting data to utf8 encoded string"
        }
    }
}
extension Data {
    func decode<O: Decodable>() throws -> O {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
        return try decoder.decode(O.self, from: self)
    }
}

extension String{
    func decode<O: Decodable>() throws -> O {
        guard let data = self.data(using: .utf8) else {
            throw JsonEncodeDecodeError.dataConversionFail
        }
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
        return try decoder.decode(O.self, from: data)
    }
}

extension DateFormatter {
    static let iso8601Full: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy h:mm:ss a"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
    
    static let iso8601_24HTime: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
}
// "dt":"01/12/2017 11:58:00 PM"
