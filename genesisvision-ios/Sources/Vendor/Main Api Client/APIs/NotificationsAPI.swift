//
// NotificationsAPI.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation
import Alamofire



open class NotificationsAPI {
    /**
     Add new setting
     - parameter assetId: (query)  (optional)     - parameter managerId: (query)  (optional)     - parameter type: (query)  (optional)     - parameter conditionType: (query)  (optional)     - parameter conditionAmount: (query)  (optional)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func addNotificationsSettings(assetId: UUID? = nil, managerId: UUID? = nil, type: NotificationType? = nil, conditionType: NotificationSettingConditionType? = nil, conditionAmount: Double? = nil, completion: @escaping ((_ data: UUID?,_ error: Error?) -> Void)) {
        addNotificationsSettingsWithRequestBuilder(assetId: assetId, managerId: managerId, type: type, conditionType: conditionType, conditionAmount: conditionAmount).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Add new setting
     - POST /v2.0/notifications/settings/add
     - API Key:
       - type: apiKey Authorization 
       - name: Bearer
     - examples: [{contentType=application/json, example="046b6c7f-0b8a-43b9-b35d-6489e6daee91"}]
     - parameter assetId: (query)  (optional)     - parameter managerId: (query)  (optional)     - parameter type: (query)  (optional)     - parameter conditionType: (query)  (optional)     - parameter conditionAmount: (query)  (optional)

     - returns: RequestBuilder<UUID> 
     */
    open class func addNotificationsSettingsWithRequestBuilder(assetId: UUID? = nil, managerId: UUID? = nil, type: NotificationType? = nil, conditionType: NotificationSettingConditionType? = nil, conditionAmount: Double? = nil) -> RequestBuilder<UUID> {
        let path = "/v2.0/notifications/settings/add"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil
        var url = URLComponents(string: URLString)
        url?.queryItems = APIHelper.mapValuesToQueryItems([
                        "AssetId": assetId, 
                        "ManagerId": managerId, 
                        "Type": type, 
                        "ConditionType": conditionType, 
                        "ConditionAmount": conditionAmount
        ])

        let requestBuilder: RequestBuilder<UUID>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**
     Unread notifications count

     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func getNewNotificationsCount(completion: @escaping ((_ data: Int?,_ error: Error?) -> Void)) {
        getNewNotificationsCountWithRequestBuilder().execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Unread notifications count
     - GET /v2.0/notifications/new
     - API Key:
       - type: apiKey Authorization 
       - name: Bearer
     - examples: [{contentType=application/json, example=0}]

     - returns: RequestBuilder<Int> 
     */
    open class func getNewNotificationsCountWithRequestBuilder() -> RequestBuilder<Int> {
        let path = "/v2.0/notifications/new"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<Int>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**
     User notifications
     - parameter skip: (query)  (optional)     - parameter take: (query)  (optional)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func getNotifications(skip: Int? = nil, take: Int? = nil, completion: @escaping ((_ data: NotificationViewModelItemsViewModel?,_ error: Error?) -> Void)) {
        getNotificationsWithRequestBuilder(skip: skip, take: take).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     User notifications
     - GET /v2.1/notifications
     - API Key:
       - type: apiKey Authorization 
       - name: Bearer
     - examples: [{contentType=application/json, example={
  "total" : 0,
  "items" : [ {
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
    "imageUrl" : "imageUrl",
    "platformAssetDetails" : {
      "color" : "color",
      "provider" : "Undefined",
      "name" : "name",
      "description" : "description",
      "id" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
      "asset" : "asset",
      "logoUrl" : "logoUrl",
      "url" : "url"
    },
    "location" : {
      "externalUrl" : "externalUrl",
      "location" : "location",
      "id" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91"
    },
    "id" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
    "text" : "text",
    "type" : "type",
    "userDetails" : {
      "socialLinks" : [ {
        "name" : "name",
        "type" : "Undefined",
        "value" : "value",
        "url" : "url",
        "logoUrl" : "logoUrl"
      }, {
        "name" : "name",
        "type" : "Undefined",
        "value" : "value",
        "url" : "url",
        "logoUrl" : "logoUrl"
      } ],
      "registrationDate" : "2000-01-23T04:56:07.000+00:00",
      "id" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
      "logoUrl" : "logoUrl",
      "url" : "url",
      "username" : "username"
    },
    "isUnread" : true
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
    "imageUrl" : "imageUrl",
    "platformAssetDetails" : {
      "color" : "color",
      "provider" : "Undefined",
      "name" : "name",
      "description" : "description",
      "id" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
      "asset" : "asset",
      "logoUrl" : "logoUrl",
      "url" : "url"
    },
    "location" : {
      "externalUrl" : "externalUrl",
      "location" : "location",
      "id" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91"
    },
    "id" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
    "text" : "text",
    "type" : "type",
    "userDetails" : {
      "socialLinks" : [ {
        "name" : "name",
        "type" : "Undefined",
        "value" : "value",
        "url" : "url",
        "logoUrl" : "logoUrl"
      }, {
        "name" : "name",
        "type" : "Undefined",
        "value" : "value",
        "url" : "url",
        "logoUrl" : "logoUrl"
      } ],
      "registrationDate" : "2000-01-23T04:56:07.000+00:00",
      "id" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
      "logoUrl" : "logoUrl",
      "url" : "url",
      "username" : "username"
    },
    "isUnread" : true
  } ]
}}]
     - parameter skip: (query)  (optional)     - parameter take: (query)  (optional)

     - returns: RequestBuilder<NotificationViewModelItemsViewModel> 
     */
    open class func getNotificationsWithRequestBuilder(skip: Int? = nil, take: Int? = nil) -> RequestBuilder<NotificationViewModelItemsViewModel> {
        let path = "/v2.1/notifications"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil
        var url = URLComponents(string: URLString)
        url?.queryItems = APIHelper.mapValuesToQueryItems([
                        "Skip": skip?.encodeToJSON(), 
                        "Take": take?.encodeToJSON()
        ])

        let requestBuilder: RequestBuilder<NotificationViewModelItemsViewModel>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**
     User settings for follow
     - parameter _id: (path)  
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func getNotificationsFollowSettings(_id: String, completion: @escaping ((_ data: FollowNotificationSettingList?,_ error: Error?) -> Void)) {
        getNotificationsFollowSettingsWithRequestBuilder(_id: _id).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     User settings for follow
     - GET /v2.0/notifications/settings/follow/{id}
     - API Key:
       - type: apiKey Authorization 
       - name: Bearer
     - examples: [{contentType=application/json, example={
  "color" : "color",
  "assetId" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
  "settingsGeneral" : [ null, null ],
  "title" : "title",
  "url" : "url",
  "logoUrl" : "logoUrl"
}}]
     - parameter _id: (path)  

     - returns: RequestBuilder<FollowNotificationSettingList> 
     */
    open class func getNotificationsFollowSettingsWithRequestBuilder(_id: String) -> RequestBuilder<FollowNotificationSettingList> {
        var path = "/v2.0/notifications/settings/follow/{id}"
        let _idPreEscape = "\(_id)"
        let _idPostEscape = _idPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{id}", with: _idPostEscape, options: .literal, range: nil)
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<FollowNotificationSettingList>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**
     User settings for fund
     - parameter _id: (path)  
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func getNotificationsFundSettings(_id: String, completion: @escaping ((_ data: FundNotificationSettingList?,_ error: Error?) -> Void)) {
        getNotificationsFundSettingsWithRequestBuilder(_id: _id).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     User settings for fund
     - GET /v2.0/notifications/settings/funds/{id}
     - API Key:
       - type: apiKey Authorization 
       - name: Bearer
     - examples: [{contentType=application/json, example={
  "color" : "color",
  "assetId" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
  "settingsGeneral" : [ null, null ],
  "title" : "title",
  "url" : "url",
  "logoUrl" : "logoUrl"
}}]
     - parameter _id: (path)  

     - returns: RequestBuilder<FundNotificationSettingList> 
     */
    open class func getNotificationsFundSettingsWithRequestBuilder(_id: String) -> RequestBuilder<FundNotificationSettingList> {
        var path = "/v2.0/notifications/settings/funds/{id}"
        let _idPreEscape = "\(_id)"
        let _idPostEscape = _idPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{id}", with: _idPostEscape, options: .literal, range: nil)
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<FundNotificationSettingList>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**
     User settings for manager
     - parameter _id: (path)  
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func getNotificationsManagerSettings(_id: String, completion: @escaping ((_ data: ManagerNotificationSettingList?,_ error: Error?) -> Void)) {
        getNotificationsManagerSettingsWithRequestBuilder(_id: _id).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     User settings for manager
     - GET /v2.0/notifications/settings/managers/{id}
     - API Key:
       - type: apiKey Authorization 
       - name: Bearer
     - examples: [{contentType=application/json, example={
  "about" : "about",
  "settingsGeneral" : [ null, null ],
  "managerId" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
  "url" : "url",
  "logoUrl" : "logoUrl",
  "username" : "username"
}}]
     - parameter _id: (path)  

     - returns: RequestBuilder<ManagerNotificationSettingList> 
     */
    open class func getNotificationsManagerSettingsWithRequestBuilder(_id: String) -> RequestBuilder<ManagerNotificationSettingList> {
        var path = "/v2.0/notifications/settings/managers/{id}"
        let _idPreEscape = "\(_id)"
        let _idPostEscape = _idPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{id}", with: _idPostEscape, options: .literal, range: nil)
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<ManagerNotificationSettingList>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**
     User settings for program
     - parameter _id: (path)  
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func getNotificationsProgramSettings(_id: String, completion: @escaping ((_ data: ProgramNotificationSettingList?,_ error: Error?) -> Void)) {
        getNotificationsProgramSettingsWithRequestBuilder(_id: _id).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     User settings for program
     - GET /v2.0/notifications/settings/programs/{id}
     - API Key:
       - type: apiKey Authorization 
       - name: Bearer
     - examples: [{contentType=application/json, example={
  "color" : "color",
  "level" : 6,
  "assetId" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
  "settingsGeneral" : [ null, null ],
  "title" : "title",
  "url" : "url",
  "logoUrl" : "logoUrl",
  "levelProgress" : 1.4658129805029452,
  "settingsCustom" : [ null, null ]
}}]
     - parameter _id: (path)  

     - returns: RequestBuilder<ProgramNotificationSettingList> 
     */
    open class func getNotificationsProgramSettingsWithRequestBuilder(_id: String) -> RequestBuilder<ProgramNotificationSettingList> {
        var path = "/v2.0/notifications/settings/programs/{id}"
        let _idPreEscape = "\(_id)"
        let _idPostEscape = _idPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{id}", with: _idPostEscape, options: .literal, range: nil)
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<ProgramNotificationSettingList>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**
     User settings

     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func getNotificationsSettings(completion: @escaping ((_ data: NotificationSettingList?,_ error: Error?) -> Void)) {
        getNotificationsSettingsWithRequestBuilder().execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     User settings
     - GET /v2.0/notifications/settings
     - API Key:
       - type: apiKey Authorization 
       - name: Bearer
     - examples: [{contentType=application/json, example={
  "settingsProgram" : [ {
    "color" : "color",
    "level" : 6,
    "assetId" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
    "settingsGeneral" : [ null, null ],
    "title" : "title",
    "url" : "url",
    "logoUrl" : "logoUrl",
    "levelProgress" : 1.4658129805029452,
    "settingsCustom" : [ null, null ]
  }, {
    "color" : "color",
    "level" : 6,
    "assetId" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
    "settingsGeneral" : [ null, null ],
    "title" : "title",
    "url" : "url",
    "logoUrl" : "logoUrl",
    "levelProgress" : 1.4658129805029452,
    "settingsCustom" : [ null, null ]
  } ],
  "settingsFollow" : [ {
    "color" : "color",
    "assetId" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
    "settingsGeneral" : [ null, null ],
    "title" : "title",
    "url" : "url",
    "logoUrl" : "logoUrl"
  }, {
    "color" : "color",
    "assetId" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
    "settingsGeneral" : [ null, null ],
    "title" : "title",
    "url" : "url",
    "logoUrl" : "logoUrl"
  } ],
  "settingsManager" : [ {
    "about" : "about",
    "settingsGeneral" : [ null, null ],
    "managerId" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
    "url" : "url",
    "logoUrl" : "logoUrl",
    "username" : "username"
  }, {
    "about" : "about",
    "settingsGeneral" : [ null, null ],
    "managerId" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
    "url" : "url",
    "logoUrl" : "logoUrl",
    "username" : "username"
  } ],
  "settingsGeneral" : [ {
    "assetId" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
    "isEnabled" : true,
    "conditionAmount" : 0.8008281904610115,
    "conditionType" : "Empty",
    "managerId" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
    "id" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
    "type" : "PlatformNewsAndUpdates"
  }, {
    "assetId" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
    "isEnabled" : true,
    "conditionAmount" : 0.8008281904610115,
    "conditionType" : "Empty",
    "managerId" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
    "id" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
    "type" : "PlatformNewsAndUpdates"
  } ],
  "settingsFund" : [ {
    "color" : "color",
    "assetId" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
    "settingsGeneral" : [ null, null ],
    "title" : "title",
    "url" : "url",
    "logoUrl" : "logoUrl"
  }, {
    "color" : "color",
    "assetId" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
    "settingsGeneral" : [ null, null ],
    "title" : "title",
    "url" : "url",
    "logoUrl" : "logoUrl"
  } ]
}}]

     - returns: RequestBuilder<NotificationSettingList> 
     */
    open class func getNotificationsSettingsWithRequestBuilder() -> RequestBuilder<NotificationSettingList> {
        let path = "/v2.0/notifications/settings"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<NotificationSettingList>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**
     Read all notification

     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func readAllNotification(completion: @escaping ((_ data: Void?,_ error: Error?) -> Void)) {
        readAllNotificationWithRequestBuilder().execute { (response, error) -> Void in
            if error == nil {
                completion((), error)
            } else {
                completion(nil, error)
            }
        }
    }


    /**
     Read all notification
     - POST /v2.0/notifications/all/read
     - API Key:
       - type: apiKey Authorization 
       - name: Bearer

     - returns: RequestBuilder<Void> 
     */
    open class func readAllNotificationWithRequestBuilder() -> RequestBuilder<Void> {
        let path = "/v2.0/notifications/all/read"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<Void>.Type = SwaggerClientAPI.requestBuilderFactory.getNonDecodableBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**
     Read notification
     - parameter _id: (path)  
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func readNotification(_id: UUID, completion: @escaping ((_ data: Void?,_ error: Error?) -> Void)) {
        readNotificationWithRequestBuilder(_id: _id).execute { (response, error) -> Void in
            if error == nil {
                completion((), error)
            } else {
                completion(nil, error)
            }
        }
    }


    /**
     Read notification
     - POST /v2.0/notifications/{id}/read
     - API Key:
       - type: apiKey Authorization 
       - name: Bearer
     - parameter _id: (path)  

     - returns: RequestBuilder<Void> 
     */
    open class func readNotificationWithRequestBuilder(_id: UUID) -> RequestBuilder<Void> {
        var path = "/v2.0/notifications/{id}/read"
        let _idPreEscape = "\(_id)"
        let _idPostEscape = _idPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{id}", with: _idPostEscape, options: .literal, range: nil)
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<Void>.Type = SwaggerClientAPI.requestBuilderFactory.getNonDecodableBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**
     Remove setting
     - parameter _id: (path)  
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func removeNotificationsSettings(_id: UUID, completion: @escaping ((_ data: Void?,_ error: Error?) -> Void)) {
        removeNotificationsSettingsWithRequestBuilder(_id: _id).execute { (response, error) -> Void in
            if error == nil {
                completion((), error)
            } else {
                completion(nil, error)
            }
        }
    }


    /**
     Remove setting
     - POST /v2.0/notifications/settings/remove/{id}
     - API Key:
       - type: apiKey Authorization 
       - name: Bearer
     - parameter _id: (path)  

     - returns: RequestBuilder<Void> 
     */
    open class func removeNotificationsSettingsWithRequestBuilder(_id: UUID) -> RequestBuilder<Void> {
        var path = "/v2.0/notifications/settings/remove/{id}"
        let _idPreEscape = "\(_id)"
        let _idPostEscape = _idPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{id}", with: _idPostEscape, options: .literal, range: nil)
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<Void>.Type = SwaggerClientAPI.requestBuilderFactory.getNonDecodableBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**
     Enable/disable setting
     - parameter _id: (path)       - parameter enable: (path)  
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func toggleNotificationSettings(_id: UUID, enable: Bool, completion: @escaping ((_ data: UUID?,_ error: Error?) -> Void)) {
        toggleNotificationSettingsWithRequestBuilder(_id: _id, enable: enable).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Enable/disable setting
     - POST /v2.0/notifications/settings/{id}/{enable}
     - API Key:
       - type: apiKey Authorization 
       - name: Bearer
     - examples: [{contentType=application/json, example="046b6c7f-0b8a-43b9-b35d-6489e6daee91"}]
     - parameter _id: (path)       - parameter enable: (path)  

     - returns: RequestBuilder<UUID> 
     */
    open class func toggleNotificationSettingsWithRequestBuilder(_id: UUID, enable: Bool) -> RequestBuilder<UUID> {
        var path = "/v2.0/notifications/settings/{id}/{enable}"
        let _idPreEscape = "\(_id)"
        let _idPostEscape = _idPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{id}", with: _idPostEscape, options: .literal, range: nil)
        let enablePreEscape = "\(enable)"
        let enablePostEscape = enablePreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{enable}", with: enablePostEscape, options: .literal, range: nil)
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<UUID>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

}
