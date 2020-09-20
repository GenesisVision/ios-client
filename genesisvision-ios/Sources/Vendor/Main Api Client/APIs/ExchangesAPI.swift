//
// ExchangesAPI.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation
import Alamofire



open class ExchangesAPI {
    /**
     Get exchanges for creating trading accounts

     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func getExchanges(completion: @escaping ((_ data: ExchangeInfoItemsViewModel?,_ error: Error?) -> Void)) {
        getExchangesWithRequestBuilder().execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Get exchanges for creating trading accounts
     - GET /v2.0/exchanges
     - API Key:
       - type: apiKey Authorization 
       - name: Bearer
     - examples: [{contentType=application/json, example={
  "total" : 1,
  "items" : [ {
    "assets" : "assets",
    "terms" : "terms",
    "fee" : 0.8008281904610115,
    "name" : "name",
    "description" : "description",
    "accountTypes" : [ {
      "name" : "name",
      "description" : "description",
      "id" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
      "isSignalsAvailable" : true,
      "type" : "Undefined",
      "minimumDepositsAmount" : {
        "key" : 6.027456183070403
      },
      "isCountryNotUSRequired" : true,
      "isDepositRequired" : true,
      "isKycRequired" : true,
      "currencies" : [ "currencies", "currencies" ]
    }, {
      "name" : "name",
      "description" : "description",
      "id" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
      "isSignalsAvailable" : true,
      "type" : "Undefined",
      "minimumDepositsAmount" : {
        "key" : 6.027456183070403
      },
      "isCountryNotUSRequired" : true,
      "isDepositRequired" : true,
      "isKycRequired" : true,
      "currencies" : [ "currencies", "currencies" ]
    } ],
    "logoUrl" : "logoUrl",
    "isKycRequired" : true,
    "tags" : [ {
      "color" : "color",
      "name" : "name"
    }, {
      "color" : "color",
      "name" : "name"
    } ]
  }, {
    "assets" : "assets",
    "terms" : "terms",
    "fee" : 0.8008281904610115,
    "name" : "name",
    "description" : "description",
    "accountTypes" : [ {
      "name" : "name",
      "description" : "description",
      "id" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
      "isSignalsAvailable" : true,
      "type" : "Undefined",
      "minimumDepositsAmount" : {
        "key" : 6.027456183070403
      },
      "isCountryNotUSRequired" : true,
      "isDepositRequired" : true,
      "isKycRequired" : true,
      "currencies" : [ "currencies", "currencies" ]
    }, {
      "name" : "name",
      "description" : "description",
      "id" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
      "isSignalsAvailable" : true,
      "type" : "Undefined",
      "minimumDepositsAmount" : {
        "key" : 6.027456183070403
      },
      "isCountryNotUSRequired" : true,
      "isDepositRequired" : true,
      "isKycRequired" : true,
      "currencies" : [ "currencies", "currencies" ]
    } ],
    "logoUrl" : "logoUrl",
    "isKycRequired" : true,
    "tags" : [ {
      "color" : "color",
      "name" : "name"
    }, {
      "color" : "color",
      "name" : "name"
    } ]
  } ]
}}]

     - returns: RequestBuilder<ExchangeInfoItemsViewModel> 
     */
    open class func getExchangesWithRequestBuilder() -> RequestBuilder<ExchangeInfoItemsViewModel> {
        let path = "/v2.0/exchanges"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<ExchangeInfoItemsViewModel>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

}