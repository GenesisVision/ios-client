//
// KycAPI.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation
import Alamofire



open class KycAPI {
    /**

     - parameter model: (body)  (optional)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func v10KycCallbackPost(model: KycCallback? = nil, completion: @escaping ((_ data: String?,_ error: Error?) -> Void)) {
        v10KycCallbackPostWithRequestBuilder(model: model).execute { (response, error) -> Void in
            completion(response?.body, error);
        }
    }


    /**
     - POST /v1.0/kyc/callback
     - examples: [{contentType=application/json, example=""}]
     
     - parameter model: (body)  (optional)

     - returns: RequestBuilder<String> 
     */
    open class func v10KycCallbackPostWithRequestBuilder(model: KycCallback? = nil) -> RequestBuilder<String> {
        let path = "/v1.0/kyc/callback"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters = JSONEncodingHelper.encodingParameters(forEncodableObject: model)

        let url = NSURLComponents(string: URLString)


        let requestBuilder: RequestBuilder<String>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }

}