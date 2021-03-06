//
// UsersAPI.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation
import Alamofire



open class UsersAPI {
    /**
     Public profile
     - parameter _id: (path)       - parameter logoQuality: (query)  (optional)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func getUserProfile(_id: String, logoQuality: ImageQuality? = nil, completion: @escaping ((_ data: PublicProfile?,_ error: Error?) -> Void)) {
        getUserProfileWithRequestBuilder(_id: _id, logoQuality: logoQuality).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Public profile
     - GET /v2.0/users/{id}
     - API Key:
       - type: apiKey Authorization 
       - name: Bearer
     - examples: [{contentType=application/json, example={
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
  "assets" : [ "assets", "assets" ],
  "followers" : 9,
  "following" : 9,
  "about" : "about",
  "regDate" : "2000-01-23T04:56:07.000+00:00",
  "personalDetails" : {
    "isFollow" : true,
    "allowFollow" : true,
    "canCommentPosts" : true,
    "canWritePost" : true
  },
  "id" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
  "logoUrl" : "logoUrl",
  "url" : "url",
  "username" : "username"
}}]
     - parameter _id: (path)       - parameter logoQuality: (query)  (optional)

     - returns: RequestBuilder<PublicProfile> 
     */
    open class func getUserProfileWithRequestBuilder(_id: String, logoQuality: ImageQuality? = nil) -> RequestBuilder<PublicProfile> {
        var path = "/v2.0/users/{id}"
        let _idPreEscape = "\(_id)"
        let _idPostEscape = _idPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{id}", with: _idPostEscape, options: .literal, range: nil)
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil
        var url = URLComponents(string: URLString)
        url?.queryItems = APIHelper.mapValuesToQueryItems(values: [
                        "logoQuality": logoQuality
        ])

        let requestBuilder: RequestBuilder<PublicProfile>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**
     Public profile follow details
     - parameter _id: (path)  
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func getUserProfileFollowDetails(_id: String, completion: @escaping ((_ data: PublicProfileFollow?,_ error: Error?) -> Void)) {
        getUserProfileFollowDetailsWithRequestBuilder(_id: _id).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Public profile follow details
     - GET /v2.0/users/{id}/follow
     - API Key:
       - type: apiKey Authorization 
       - name: Bearer
     - examples: [{contentType=application/json, example={
  "followers" : [ {
    "personalDetails" : {
      "isFollow" : true,
      "allowFollow" : true,
      "canCommentPosts" : true,
      "canWritePost" : true
    },
    "id" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
    "url" : "url",
    "logoUrl" : "logoUrl",
    "username" : "username"
  }, {
    "personalDetails" : {
      "isFollow" : true,
      "allowFollow" : true,
      "canCommentPosts" : true,
      "canWritePost" : true
    },
    "id" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
    "url" : "url",
    "logoUrl" : "logoUrl",
    "username" : "username"
  } ],
  "following" : [ null, null ]
}}]
     - parameter _id: (path)  

     - returns: RequestBuilder<PublicProfileFollow> 
     */
    open class func getUserProfileFollowDetailsWithRequestBuilder(_id: String) -> RequestBuilder<PublicProfileFollow> {
        var path = "/v2.0/users/{id}/follow"
        let _idPreEscape = "\(_id)"
        let _idPostEscape = _idPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{id}", with: _idPostEscape, options: .literal, range: nil)
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<PublicProfileFollow>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**
     Get users list
     - parameter sorting: (query)  (optional)     - parameter timeframe: (query)  (optional)     - parameter tags: (query)  (optional)     - parameter skip: (query)  (optional)     - parameter take: (query)  (optional)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func getUsersList(sorting: UsersFilterSorting? = nil, timeframe: UsersFilterTimeframe? = nil, tags: [String]? = nil, skip: Int? = nil, take: Int? = nil, completion: @escaping ((_ data: UserDetailsListItemsViewModel?,_ error: Error?) -> Void)) {
        getUsersListWithRequestBuilder(sorting: sorting, timeframe: timeframe, tags: tags, skip: skip, take: take).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Get users list
     - GET /v2.0/users
     - API Key:
       - type: apiKey Authorization 
       - name: Bearer
     - examples: [{contentType=application/json, example={
  "total" : 5,
  "items" : [ {
    "totalProfit" : 5.962133916683182,
    "about" : "about",
    "regDate" : "2000-01-23T04:56:07.000+00:00",
    "userId" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
    "logoUrl" : "logoUrl",
    "url" : "url",
    "tags" : [ {
      "color" : "color",
      "name" : "name"
    }, {
      "color" : "color",
      "name" : "name"
    } ],
    "assetsUnderManagement" : 0.8008281904610115,
    "followers" : [ {
      "personalDetails" : {
        "isFollow" : true,
        "allowFollow" : true,
        "canCommentPosts" : true,
        "canWritePost" : true
      },
      "id" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
      "url" : "url",
      "logoUrl" : "logoUrl",
      "username" : "username"
    }, {
      "personalDetails" : {
        "isFollow" : true,
        "allowFollow" : true,
        "canCommentPosts" : true,
        "canWritePost" : true
      },
      "id" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
      "url" : "url",
      "logoUrl" : "logoUrl",
      "username" : "username"
    } ],
    "personalDetails" : {
      "isFollow" : true,
      "allowFollow" : true,
      "canCommentPosts" : true,
      "canWritePost" : true
    },
    "followersCount" : 1,
    "username" : "username",
    "investorsCount" : 6
  }, {
    "totalProfit" : 5.962133916683182,
    "about" : "about",
    "regDate" : "2000-01-23T04:56:07.000+00:00",
    "userId" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
    "logoUrl" : "logoUrl",
    "url" : "url",
    "tags" : [ {
      "color" : "color",
      "name" : "name"
    }, {
      "color" : "color",
      "name" : "name"
    } ],
    "assetsUnderManagement" : 0.8008281904610115,
    "followers" : [ {
      "personalDetails" : {
        "isFollow" : true,
        "allowFollow" : true,
        "canCommentPosts" : true,
        "canWritePost" : true
      },
      "id" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
      "url" : "url",
      "logoUrl" : "logoUrl",
      "username" : "username"
    }, {
      "personalDetails" : {
        "isFollow" : true,
        "allowFollow" : true,
        "canCommentPosts" : true,
        "canWritePost" : true
      },
      "id" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
      "url" : "url",
      "logoUrl" : "logoUrl",
      "username" : "username"
    } ],
    "personalDetails" : {
      "isFollow" : true,
      "allowFollow" : true,
      "canCommentPosts" : true,
      "canWritePost" : true
    },
    "followersCount" : 1,
    "username" : "username",
    "investorsCount" : 6
  } ]
}}]
     - parameter sorting: (query)  (optional)     - parameter timeframe: (query)  (optional)     - parameter tags: (query)  (optional)     - parameter skip: (query)  (optional)     - parameter take: (query)  (optional)

     - returns: RequestBuilder<UserDetailsListItemsViewModel> 
     */
    open class func getUsersListWithRequestBuilder(sorting: UsersFilterSorting? = nil, timeframe: UsersFilterTimeframe? = nil, tags: [String]? = nil, skip: Int? = nil, take: Int? = nil) -> RequestBuilder<UserDetailsListItemsViewModel> {
        let path = "/v2.0/users"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil
        var url = URLComponents(string: URLString)
        url?.queryItems = APIHelper.mapValuesToQueryItems(values: [
                        "Sorting": sorting, 
                        "Timeframe": timeframe, 
                        "Tags": tags, 
                        "Skip": skip?.encodeToJSON(), 
                        "Take": take?.encodeToJSON()
        ])

        let requestBuilder: RequestBuilder<UserDetailsListItemsViewModel>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

}
