//
// EventsAPI.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation
import Alamofire



open class EventsAPI {
    /**
     Events
     - parameter eventLocation: (query)  (optional)     - parameter assetId: (query)  (optional)     - parameter from: (query)  (optional)     - parameter to: (query)  (optional)     - parameter dateFrom: (query)  (optional)     - parameter dateTo: (query)  (optional)     - parameter eventType: (query)  (optional)     - parameter assetType: (query)  (optional)     - parameter assetsIds: (query)  (optional)     - parameter forceFilterByIds: (query)  (optional)     - parameter eventGroup: (query)  (optional)     - parameter skip: (query)  (optional)     - parameter take: (query)  (optional)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func getEvents(eventLocation: InvestmentEventLocation? = nil, assetId: UUID? = nil, from: Date? = nil, to: Date? = nil, dateFrom: Date? = nil, dateTo: Date? = nil, eventType: InvestmentEventType? = nil, assetType: AssetFilterType? = nil, assetsIds: [UUID]? = nil, forceFilterByIds: Bool? = nil, eventGroup: EventGroupType? = nil, skip: Int? = nil, take: Int? = nil, completion: @escaping ((_ data: InvestmentEventViewModels?,_ error: Error?) -> Void)) {
        getEventsWithRequestBuilder(eventLocation: eventLocation, assetId: assetId, from: from, to: to, dateFrom: dateFrom, dateTo: dateTo, eventType: eventType, assetType: assetType, assetsIds: assetsIds, forceFilterByIds: forceFilterByIds, eventGroup: eventGroup, skip: skip, take: take).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Events
     - GET /v2.0/events
     - API Key:
       - type: apiKey Authorization 
       - name: Bearer
     - examples: [{contentType=application/json, example={
  "total" : 0,
  "events" : [ {
    "date" : "2000-01-23T04:56:07.000+00:00",
    "assetDetails" : {
      "programDetails" : {
        "level" : 0,
        "levelProgress" : 6.027456183070403
      },
      "color" : "color",
      "id" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
      "title" : "title",
      "logoUrl" : "logoUrl",
      "url" : "url",
      "assetType" : "None"
    },
    "amount" : 2.3021358869347655,
    "feesInfo" : [ {
      "amount" : 9.301444243932576,
      "description" : "description",
      "title" : "title",
      "type" : "Undefined"
    }, {
      "amount" : 9.301444243932576,
      "description" : "description",
      "title" : "title",
      "type" : "Undefined"
    } ],
    "changeState" : "NotChanged",
    "extendedInfo" : [ {
      "amount" : 7.061401241503109,
      "title" : "title"
    }, {
      "amount" : 7.061401241503109,
      "title" : "title"
    } ],
    "currency" : "Undefined",
    "title" : "title",
    "logoUrl" : "logoUrl",
    "totalFeesAmount" : 3.616076749251911
  }, {
    "date" : "2000-01-23T04:56:07.000+00:00",
    "assetDetails" : {
      "programDetails" : {
        "level" : 0,
        "levelProgress" : 6.027456183070403
      },
      "color" : "color",
      "id" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
      "title" : "title",
      "logoUrl" : "logoUrl",
      "url" : "url",
      "assetType" : "None"
    },
    "amount" : 2.3021358869347655,
    "feesInfo" : [ {
      "amount" : 9.301444243932576,
      "description" : "description",
      "title" : "title",
      "type" : "Undefined"
    }, {
      "amount" : 9.301444243932576,
      "description" : "description",
      "title" : "title",
      "type" : "Undefined"
    } ],
    "changeState" : "NotChanged",
    "extendedInfo" : [ {
      "amount" : 7.061401241503109,
      "title" : "title"
    }, {
      "amount" : 7.061401241503109,
      "title" : "title"
    } ],
    "currency" : "Undefined",
    "title" : "title",
    "logoUrl" : "logoUrl",
    "totalFeesAmount" : 3.616076749251911
  } ]
}}]
     - parameter eventLocation: (query)  (optional)     - parameter assetId: (query)  (optional)     - parameter from: (query)  (optional)     - parameter to: (query)  (optional)     - parameter dateFrom: (query)  (optional)     - parameter dateTo: (query)  (optional)     - parameter eventType: (query)  (optional)     - parameter assetType: (query)  (optional)     - parameter assetsIds: (query)  (optional)     - parameter forceFilterByIds: (query)  (optional)     - parameter eventGroup: (query)  (optional)     - parameter skip: (query)  (optional)     - parameter take: (query)  (optional)

     - returns: RequestBuilder<InvestmentEventViewModels> 
     */
    open class func getEventsWithRequestBuilder(eventLocation: InvestmentEventLocation? = nil, assetId: UUID? = nil, from: Date? = nil, to: Date? = nil, dateFrom: Date? = nil, dateTo: Date? = nil, eventType: InvestmentEventType? = nil, assetType: AssetFilterType? = nil, assetsIds: [UUID]? = nil, forceFilterByIds: Bool? = nil, eventGroup: EventGroupType? = nil, skip: Int? = nil, take: Int? = nil) -> RequestBuilder<InvestmentEventViewModels> {
        let path = "/v2.0/events"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil
        var url = URLComponents(string: URLString)
        url?.queryItems = APIHelper.mapValuesToQueryItems(values: [
                        "EventLocation": eventLocation, 
                        "AssetId": assetId, 
                        "From": from?.encodeToJSON(), 
                        "To": to?.encodeToJSON(), 
                        "DateFrom": dateFrom?.encodeToJSON(), 
                        "DateTo": dateTo?.encodeToJSON(), 
                        "EventType": eventType, 
                        "AssetType": assetType, 
                        "AssetsIds": assetsIds, 
                        "ForceFilterByIds": forceFilterByIds, 
                        "EventGroup": eventGroup, 
                        "Skip": skip?.encodeToJSON(), 
                        "Take": take?.encodeToJSON()
        ])

        let requestBuilder: RequestBuilder<InvestmentEventViewModels>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

}