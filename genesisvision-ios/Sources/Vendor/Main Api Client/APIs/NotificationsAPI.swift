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
     Read notification
     
     - parameter id: (path)  
     - parameter authorization: (header) JWT access token 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func v10NotificationsByIdReadPost(id: UUID, authorization: String, completion: @escaping ((_ error: Error?) -> Void)) {
        v10NotificationsByIdReadPostWithRequestBuilder(id: id, authorization: authorization).execute { (response, error) -> Void in
            completion(error);
        }
    }


    /**
     Read notification
     - POST /v1.0/notifications/{id}/read
     
     - parameter id: (path)  
     - parameter authorization: (header) JWT access token 

     - returns: RequestBuilder<Void> 
     */
    open class func v10NotificationsByIdReadPostWithRequestBuilder(id: UUID, authorization: String) -> RequestBuilder<Void> {
        var path = "/v1.0/notifications/{id}/read"
        path = path.replacingOccurrences(of: "{id}", with: "\(id)", options: .literal, range: nil)
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)

        let nillableHeaders: [String: Any?] = [
            "Authorization": authorization
        ]
        let headerParameters = APIHelper.rejectNilHeaders(nillableHeaders)

        let requestBuilder: RequestBuilder<Void>.Type = SwaggerClientAPI.requestBuilderFactory.getNonDecodableBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false, headers: headerParameters)
    }

    /**
     User notifications
     
     - parameter authorization: (header) JWT access token 
     - parameter skip: (query)  (optional)
     - parameter take: (query)  (optional)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func v10NotificationsGet(authorization: String, skip: Int? = nil, take: Int? = nil, completion: @escaping ((_ data: NotificationList?,_ error: Error?) -> Void)) {
        v10NotificationsGetWithRequestBuilder(authorization: authorization, skip: skip, take: take).execute { (response, error) -> Void in
            completion(response?.body, error);
        }
    }


    /**
     User notifications
     - GET /v1.0/notifications
     - examples: [{contentType=application/json, example={
  "total" : 0,
  "notifications" : [ {
    "date" : "2000-01-23T04:56:07.000+00:00",
    "color" : "color",
    "assetId" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
    "logo" : "logo",
    "id" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
    "text" : "text",
    "managerId" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
    "type" : "PlatformNewsAndUpdates",
    "url" : "url",
    "isUnread" : true,
    "assetType" : "Program"
  }, {
    "date" : "2000-01-23T04:56:07.000+00:00",
    "color" : "color",
    "assetId" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
    "logo" : "logo",
    "id" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
    "text" : "text",
    "managerId" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
    "type" : "PlatformNewsAndUpdates",
    "url" : "url",
    "isUnread" : true,
    "assetType" : "Program"
  } ]
}}]
     
     - parameter authorization: (header) JWT access token 
     - parameter skip: (query)  (optional)
     - parameter take: (query)  (optional)

     - returns: RequestBuilder<NotificationList> 
     */
    open class func v10NotificationsGetWithRequestBuilder(authorization: String, skip: Int? = nil, take: Int? = nil) -> RequestBuilder<NotificationList> {
        let path = "/v1.0/notifications"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)
        url?.queryItems = APIHelper.mapValuesToQueryItems(values:[
            "skip": skip?.encodeToJSON(), 
            "take": take?.encodeToJSON()
        ])
        
        let nillableHeaders: [String: Any?] = [
            "Authorization": authorization
        ]
        let headerParameters = APIHelper.rejectNilHeaders(nillableHeaders)

        let requestBuilder: RequestBuilder<NotificationList>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false, headers: headerParameters)
    }

    /**
     Unread notifications count
     
     - parameter authorization: (header) JWT access token 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func v10NotificationsNewGet(authorization: String, completion: @escaping ((_ data: Int?,_ error: Error?) -> Void)) {
        v10NotificationsNewGetWithRequestBuilder(authorization: authorization).execute { (response, error) -> Void in
            completion(response?.body, error);
        }
    }


    /**
     Unread notifications count
     - GET /v1.0/notifications/new
     - examples: [{contentType=application/json, example=0}]
     
     - parameter authorization: (header) JWT access token 

     - returns: RequestBuilder<Int> 
     */
    open class func v10NotificationsNewGetWithRequestBuilder(authorization: String) -> RequestBuilder<Int> {
        let path = "/v1.0/notifications/new"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)

        let nillableHeaders: [String: Any?] = [
            "Authorization": authorization
        ]
        let headerParameters = APIHelper.rejectNilHeaders(nillableHeaders)

        let requestBuilder: RequestBuilder<Int>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false, headers: headerParameters)
    }

    /**
     * enum for parameter type
     */
    public enum ModelType_v10NotificationsSettingsAddPost: String { 
        case platformNewsAndUpdates = "PlatformNewsAndUpdates"
        case platformEmergency = "PlatformEmergency"
        case platformOther = "PlatformOther"
        case profileUpdated = "ProfileUpdated"
        case profilePwdUpdated = "ProfilePwdUpdated"
        case profileVerification = "ProfileVerification"
        case profile2FA = "Profile2FA"
        case profileSecurity = "ProfileSecurity"
        case tradingAccountPwdUpdated = "TradingAccountPwdUpdated"
        case programNewsAndUpdates = "ProgramNewsAndUpdates"
        case programEndOfPeriod = "ProgramEndOfPeriod"
        case programCondition = "ProgramCondition"
        case fundNewsAndUpdates = "FundNewsAndUpdates"
        case fundEndOfPeriod = "FundEndOfPeriod"
        case fundRebalancing = "FundRebalancing"
        case managerNewProgram = "ManagerNewProgram"
        case signals = "Signals"
    }

    /**
     * enum for parameter conditionType
     */
    public enum ConditionType_v10NotificationsSettingsAddPost: String { 
        case empty = "Empty"
        case profit = "Profit"
        case level = "Level"
    }

    /**
     Add new setting
     
     - parameter authorization: (header) JWT access token 
     - parameter assetId: (query)  (optional)
     - parameter managerId: (query)  (optional)
     - parameter type: (query)  (optional)
     - parameter conditionType: (query)  (optional)
     - parameter conditionAmount: (query)  (optional)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func v10NotificationsSettingsAddPost(authorization: String, assetId: UUID? = nil, managerId: UUID? = nil, type: ModelType_v10NotificationsSettingsAddPost? = nil, conditionType: ConditionType_v10NotificationsSettingsAddPost? = nil, conditionAmount: Double? = nil, completion: @escaping ((_ data: UUID?,_ error: Error?) -> Void)) {
        v10NotificationsSettingsAddPostWithRequestBuilder(authorization: authorization, assetId: assetId, managerId: managerId, type: type, conditionType: conditionType, conditionAmount: conditionAmount).execute { (response, error) -> Void in
            completion(response?.body, error);
        }
    }


    /**
     Add new setting
     - POST /v1.0/notifications/settings/add
     - examples: [{contentType=application/json, example="046b6c7f-0b8a-43b9-b35d-6489e6daee91"}]
     
     - parameter authorization: (header) JWT access token 
     - parameter assetId: (query)  (optional)
     - parameter managerId: (query)  (optional)
     - parameter type: (query)  (optional)
     - parameter conditionType: (query)  (optional)
     - parameter conditionAmount: (query)  (optional)

     - returns: RequestBuilder<UUID> 
     */
    open class func v10NotificationsSettingsAddPostWithRequestBuilder(authorization: String, assetId: UUID? = nil, managerId: UUID? = nil, type: ModelType_v10NotificationsSettingsAddPost? = nil, conditionType: ConditionType_v10NotificationsSettingsAddPost? = nil, conditionAmount: Double? = nil) -> RequestBuilder<UUID> {
        let path = "/v1.0/notifications/settings/add"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)
        url?.queryItems = APIHelper.mapValuesToQueryItems(values:[
            "AssetId": assetId, 
            "ManagerId": managerId, 
            "Type": type?.rawValue, 
            "ConditionType": conditionType?.rawValue, 
            "ConditionAmount": conditionAmount
        ])
        
        let nillableHeaders: [String: Any?] = [
            "Authorization": authorization
        ]
        let headerParameters = APIHelper.rejectNilHeaders(nillableHeaders)

        let requestBuilder: RequestBuilder<UUID>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false, headers: headerParameters)
    }

    /**
     Enable/disable setting
     
     - parameter id: (path)  
     - parameter enable: (path)  
     - parameter authorization: (header) JWT access token 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func v10NotificationsSettingsByIdByEnablePost(id: UUID, enable: Bool, authorization: String, completion: @escaping ((_ data: UUID?,_ error: Error?) -> Void)) {
        v10NotificationsSettingsByIdByEnablePostWithRequestBuilder(id: id, enable: enable, authorization: authorization).execute { (response, error) -> Void in
            completion(response?.body, error);
        }
    }


    /**
     Enable/disable setting
     - POST /v1.0/notifications/settings/{id}/{enable}
     - examples: [{contentType=application/json, example="046b6c7f-0b8a-43b9-b35d-6489e6daee91"}]
     
     - parameter id: (path)  
     - parameter enable: (path)  
     - parameter authorization: (header) JWT access token 

     - returns: RequestBuilder<UUID> 
     */
    open class func v10NotificationsSettingsByIdByEnablePostWithRequestBuilder(id: UUID, enable: Bool, authorization: String) -> RequestBuilder<UUID> {
        var path = "/v1.0/notifications/settings/{id}/{enable}"
        path = path.replacingOccurrences(of: "{id}", with: "\(id)", options: .literal, range: nil)
        path = path.replacingOccurrences(of: "{enable}", with: "\(enable)", options: .literal, range: nil)
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)

        let nillableHeaders: [String: Any?] = [
            "Authorization": authorization
        ]
        let headerParameters = APIHelper.rejectNilHeaders(nillableHeaders)

        let requestBuilder: RequestBuilder<UUID>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false, headers: headerParameters)
    }

    /**
     User settings for fund
     
     - parameter id: (path)  
     - parameter authorization: (header) JWT access token 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func v10NotificationsSettingsFundsByIdGet(id: String, authorization: String, completion: @escaping ((_ data: FundNotificationSettingList?,_ error: Error?) -> Void)) {
        v10NotificationsSettingsFundsByIdGetWithRequestBuilder(id: id, authorization: authorization).execute { (response, error) -> Void in
            completion(response?.body, error);
        }
    }


    /**
     User settings for fund
     - GET /v1.0/notifications/settings/funds/{id}
     - examples: [{contentType=application/json, example={
  "color" : "color",
  "assetId" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
  "logo" : "logo",
  "settingsGeneral" : [ {
    "assetId" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
    "isEnabled" : true,
    "conditionAmount" : 0.8008281904610115,
    "conditionType" : "Empty",
    "id" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
    "managerId" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
    "type" : "PlatformNewsAndUpdates"
  }, {
    "assetId" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
    "isEnabled" : true,
    "conditionAmount" : 0.8008281904610115,
    "conditionType" : "Empty",
    "id" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
    "managerId" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
    "type" : "PlatformNewsAndUpdates"
  } ],
  "title" : "title",
  "url" : "url"
}}]
     
     - parameter id: (path)  
     - parameter authorization: (header) JWT access token 

     - returns: RequestBuilder<FundNotificationSettingList> 
     */
    open class func v10NotificationsSettingsFundsByIdGetWithRequestBuilder(id: String, authorization: String) -> RequestBuilder<FundNotificationSettingList> {
        var path = "/v1.0/notifications/settings/funds/{id}"
        path = path.replacingOccurrences(of: "{id}", with: "\(id)", options: .literal, range: nil)
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)

        let nillableHeaders: [String: Any?] = [
            "Authorization": authorization
        ]
        let headerParameters = APIHelper.rejectNilHeaders(nillableHeaders)

        let requestBuilder: RequestBuilder<FundNotificationSettingList>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false, headers: headerParameters)
    }

    /**
     User settings
     
     - parameter authorization: (header) JWT access token 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func v10NotificationsSettingsGet(authorization: String, completion: @escaping ((_ data: NotificationSettingList?,_ error: Error?) -> Void)) {
        v10NotificationsSettingsGetWithRequestBuilder(authorization: authorization).execute { (response, error) -> Void in
            completion(response?.body, error);
        }
    }


    /**
     User settings
     - GET /v1.0/notifications/settings
     - examples: [{contentType=application/json, example={
  "settingsProgram" : [ {
    "color" : "color",
    "level" : 6,
    "assetId" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
    "logo" : "logo",
    "settingsGeneral" : [ {
      "assetId" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
      "isEnabled" : true,
      "conditionAmount" : 0.8008281904610115,
      "conditionType" : "Empty",
      "id" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
      "managerId" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
      "type" : "PlatformNewsAndUpdates"
    }, {
      "assetId" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
      "isEnabled" : true,
      "conditionAmount" : 0.8008281904610115,
      "conditionType" : "Empty",
      "id" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
      "managerId" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
      "type" : "PlatformNewsAndUpdates"
    } ],
    "title" : "title",
    "url" : "url",
    "settingsCustom" : [ {
      "assetId" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
      "isEnabled" : true,
      "conditionAmount" : 0.8008281904610115,
      "conditionType" : "Empty",
      "id" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
      "managerId" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
      "type" : "PlatformNewsAndUpdates"
    }, {
      "assetId" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
      "isEnabled" : true,
      "conditionAmount" : 0.8008281904610115,
      "conditionType" : "Empty",
      "id" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
      "managerId" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
      "type" : "PlatformNewsAndUpdates"
    } ]
  }, {
    "color" : "color",
    "level" : 6,
    "assetId" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
    "logo" : "logo",
    "settingsGeneral" : [ {
      "assetId" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
      "isEnabled" : true,
      "conditionAmount" : 0.8008281904610115,
      "conditionType" : "Empty",
      "id" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
      "managerId" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
      "type" : "PlatformNewsAndUpdates"
    }, {
      "assetId" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
      "isEnabled" : true,
      "conditionAmount" : 0.8008281904610115,
      "conditionType" : "Empty",
      "id" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
      "managerId" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
      "type" : "PlatformNewsAndUpdates"
    } ],
    "title" : "title",
    "url" : "url",
    "settingsCustom" : [ {
      "assetId" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
      "isEnabled" : true,
      "conditionAmount" : 0.8008281904610115,
      "conditionType" : "Empty",
      "id" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
      "managerId" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
      "type" : "PlatformNewsAndUpdates"
    }, {
      "assetId" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
      "isEnabled" : true,
      "conditionAmount" : 0.8008281904610115,
      "conditionType" : "Empty",
      "id" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
      "managerId" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
      "type" : "PlatformNewsAndUpdates"
    } ]
  } ],
  "settingsManager" : [ {
    "about" : "about",
    "settingsGeneral" : [ {
      "assetId" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
      "isEnabled" : true,
      "conditionAmount" : 0.8008281904610115,
      "conditionType" : "Empty",
      "id" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
      "managerId" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
      "type" : "PlatformNewsAndUpdates"
    }, {
      "assetId" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
      "isEnabled" : true,
      "conditionAmount" : 0.8008281904610115,
      "conditionType" : "Empty",
      "id" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
      "managerId" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
      "type" : "PlatformNewsAndUpdates"
    } ],
    "managerId" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
    "avatar" : "avatar",
    "url" : "url",
    "username" : "username"
  }, {
    "about" : "about",
    "settingsGeneral" : [ {
      "assetId" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
      "isEnabled" : true,
      "conditionAmount" : 0.8008281904610115,
      "conditionType" : "Empty",
      "id" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
      "managerId" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
      "type" : "PlatformNewsAndUpdates"
    }, {
      "assetId" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
      "isEnabled" : true,
      "conditionAmount" : 0.8008281904610115,
      "conditionType" : "Empty",
      "id" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
      "managerId" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
      "type" : "PlatformNewsAndUpdates"
    } ],
    "managerId" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
    "avatar" : "avatar",
    "url" : "url",
    "username" : "username"
  } ],
  "settingsGeneral" : [ {
    "assetId" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
    "isEnabled" : true,
    "conditionAmount" : 0.8008281904610115,
    "conditionType" : "Empty",
    "id" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
    "managerId" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
    "type" : "PlatformNewsAndUpdates"
  }, {
    "assetId" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
    "isEnabled" : true,
    "conditionAmount" : 0.8008281904610115,
    "conditionType" : "Empty",
    "id" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
    "managerId" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
    "type" : "PlatformNewsAndUpdates"
  } ],
  "settingsFund" : [ {
    "color" : "color",
    "assetId" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
    "logo" : "logo",
    "settingsGeneral" : [ {
      "assetId" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
      "isEnabled" : true,
      "conditionAmount" : 0.8008281904610115,
      "conditionType" : "Empty",
      "id" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
      "managerId" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
      "type" : "PlatformNewsAndUpdates"
    }, {
      "assetId" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
      "isEnabled" : true,
      "conditionAmount" : 0.8008281904610115,
      "conditionType" : "Empty",
      "id" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
      "managerId" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
      "type" : "PlatformNewsAndUpdates"
    } ],
    "title" : "title",
    "url" : "url"
  }, {
    "color" : "color",
    "assetId" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
    "logo" : "logo",
    "settingsGeneral" : [ {
      "assetId" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
      "isEnabled" : true,
      "conditionAmount" : 0.8008281904610115,
      "conditionType" : "Empty",
      "id" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
      "managerId" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
      "type" : "PlatformNewsAndUpdates"
    }, {
      "assetId" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
      "isEnabled" : true,
      "conditionAmount" : 0.8008281904610115,
      "conditionType" : "Empty",
      "id" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
      "managerId" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
      "type" : "PlatformNewsAndUpdates"
    } ],
    "title" : "title",
    "url" : "url"
  } ]
}}]
     
     - parameter authorization: (header) JWT access token 

     - returns: RequestBuilder<NotificationSettingList> 
     */
    open class func v10NotificationsSettingsGetWithRequestBuilder(authorization: String) -> RequestBuilder<NotificationSettingList> {
        let path = "/v1.0/notifications/settings"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)

        let nillableHeaders: [String: Any?] = [
            "Authorization": authorization
        ]
        let headerParameters = APIHelper.rejectNilHeaders(nillableHeaders)

        let requestBuilder: RequestBuilder<NotificationSettingList>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false, headers: headerParameters)
    }

    /**
     User settings for manager
     
     - parameter id: (path)  
     - parameter authorization: (header) JWT access token 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func v10NotificationsSettingsManagersByIdGet(id: String, authorization: String, completion: @escaping ((_ data: ManagerNotificationSettingList?,_ error: Error?) -> Void)) {
        v10NotificationsSettingsManagersByIdGetWithRequestBuilder(id: id, authorization: authorization).execute { (response, error) -> Void in
            completion(response?.body, error);
        }
    }


    /**
     User settings for manager
     - GET /v1.0/notifications/settings/managers/{id}
     - examples: [{contentType=application/json, example={
  "about" : "about",
  "settingsGeneral" : [ {
    "assetId" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
    "isEnabled" : true,
    "conditionAmount" : 0.8008281904610115,
    "conditionType" : "Empty",
    "id" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
    "managerId" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
    "type" : "PlatformNewsAndUpdates"
  }, {
    "assetId" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
    "isEnabled" : true,
    "conditionAmount" : 0.8008281904610115,
    "conditionType" : "Empty",
    "id" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
    "managerId" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
    "type" : "PlatformNewsAndUpdates"
  } ],
  "managerId" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
  "avatar" : "avatar",
  "url" : "url",
  "username" : "username"
}}]
     
     - parameter id: (path)  
     - parameter authorization: (header) JWT access token 

     - returns: RequestBuilder<ManagerNotificationSettingList> 
     */
    open class func v10NotificationsSettingsManagersByIdGetWithRequestBuilder(id: String, authorization: String) -> RequestBuilder<ManagerNotificationSettingList> {
        var path = "/v1.0/notifications/settings/managers/{id}"
        path = path.replacingOccurrences(of: "{id}", with: "\(id)", options: .literal, range: nil)
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)

        let nillableHeaders: [String: Any?] = [
            "Authorization": authorization
        ]
        let headerParameters = APIHelper.rejectNilHeaders(nillableHeaders)

        let requestBuilder: RequestBuilder<ManagerNotificationSettingList>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false, headers: headerParameters)
    }

    /**
     User settings for program
     
     - parameter id: (path)  
     - parameter authorization: (header) JWT access token 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func v10NotificationsSettingsProgramsByIdGet(id: String, authorization: String, completion: @escaping ((_ data: ProgramNotificationSettingList?,_ error: Error?) -> Void)) {
        v10NotificationsSettingsProgramsByIdGetWithRequestBuilder(id: id, authorization: authorization).execute { (response, error) -> Void in
            completion(response?.body, error);
        }
    }


    /**
     User settings for program
     - GET /v1.0/notifications/settings/programs/{id}
     - examples: [{contentType=application/json, example={
  "color" : "color",
  "level" : 6,
  "assetId" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
  "logo" : "logo",
  "settingsGeneral" : [ {
    "assetId" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
    "isEnabled" : true,
    "conditionAmount" : 0.8008281904610115,
    "conditionType" : "Empty",
    "id" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
    "managerId" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
    "type" : "PlatformNewsAndUpdates"
  }, {
    "assetId" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
    "isEnabled" : true,
    "conditionAmount" : 0.8008281904610115,
    "conditionType" : "Empty",
    "id" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
    "managerId" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
    "type" : "PlatformNewsAndUpdates"
  } ],
  "title" : "title",
  "url" : "url",
  "settingsCustom" : [ {
    "assetId" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
    "isEnabled" : true,
    "conditionAmount" : 0.8008281904610115,
    "conditionType" : "Empty",
    "id" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
    "managerId" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
    "type" : "PlatformNewsAndUpdates"
  }, {
    "assetId" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
    "isEnabled" : true,
    "conditionAmount" : 0.8008281904610115,
    "conditionType" : "Empty",
    "id" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
    "managerId" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
    "type" : "PlatformNewsAndUpdates"
  } ]
}}]
     
     - parameter id: (path)  
     - parameter authorization: (header) JWT access token 

     - returns: RequestBuilder<ProgramNotificationSettingList> 
     */
    open class func v10NotificationsSettingsProgramsByIdGetWithRequestBuilder(id: String, authorization: String) -> RequestBuilder<ProgramNotificationSettingList> {
        var path = "/v1.0/notifications/settings/programs/{id}"
        path = path.replacingOccurrences(of: "{id}", with: "\(id)", options: .literal, range: nil)
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)

        let nillableHeaders: [String: Any?] = [
            "Authorization": authorization
        ]
        let headerParameters = APIHelper.rejectNilHeaders(nillableHeaders)

        let requestBuilder: RequestBuilder<ProgramNotificationSettingList>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false, headers: headerParameters)
    }

    /**
     Remove setting
     
     - parameter id: (path)  
     - parameter authorization: (header) JWT access token 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func v10NotificationsSettingsRemoveByIdPost(id: UUID, authorization: String, completion: @escaping ((_ error: Error?) -> Void)) {
        v10NotificationsSettingsRemoveByIdPostWithRequestBuilder(id: id, authorization: authorization).execute { (response, error) -> Void in
            completion(error);
        }
    }


    /**
     Remove setting
     - POST /v1.0/notifications/settings/remove/{id}
     
     - parameter id: (path)  
     - parameter authorization: (header) JWT access token 

     - returns: RequestBuilder<Void> 
     */
    open class func v10NotificationsSettingsRemoveByIdPostWithRequestBuilder(id: UUID, authorization: String) -> RequestBuilder<Void> {
        var path = "/v1.0/notifications/settings/remove/{id}"
        path = path.replacingOccurrences(of: "{id}", with: "\(id)", options: .literal, range: nil)
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)

        let nillableHeaders: [String: Any?] = [
            "Authorization": authorization
        ]
        let headerParameters = APIHelper.rejectNilHeaders(nillableHeaders)

        let requestBuilder: RequestBuilder<Void>.Type = SwaggerClientAPI.requestBuilderFactory.getNonDecodableBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false, headers: headerParameters)
    }

}