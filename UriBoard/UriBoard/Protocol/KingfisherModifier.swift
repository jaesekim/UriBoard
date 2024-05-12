//
//  KingfisherModifier.swift
//  UriBoard
//
//  Created by 김재석 on 5/3/24.
//

import Foundation
import Kingfisher

protocol KingfisherModifier {
    var modifier: AnyModifier { get }
}

extension KingfisherModifier {
    
    func createImgURL(path: String?) -> String {
        
        guard let path = path else { return "" }
        return APIURL.baseURL + "/v1/" + path
    }

    var modifier: AnyModifier {
        return AnyModifier { request in
            var request = request
            request.setValue(
                HTTPHeader.json.rawValue,
                forHTTPHeaderField: HTTPHeader.contentType.rawValue
            )
            request.setValue(
                APIKey.key,
                forHTTPHeaderField: HTTPHeader.sesacKey.rawValue
            )
            request.setValue(
                UserDefaultsManager.accessToken,
                forHTTPHeaderField: HTTPHeader.auth.rawValue
            )
            return request
        }
    }
}
