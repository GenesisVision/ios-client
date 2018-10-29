//
// SearchAPI.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation
import Alamofire



open class SearchAPI {
    /**
     Program / fund / manager search
     
     - parameter mask: (query)  (optional)
     - parameter take: (query)  (optional)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func v10SearchGet(mask: String? = nil, take: Int? = nil, completion: @escaping ((_ data: SearchViewModel?,_ error: Error?) -> Void)) {
        v10SearchGetWithRequestBuilder(mask: mask, take: take).execute { (response, error) -> Void in
            completion(response?.body, error);
        }
    }


    /**
     Program / fund / manager search
     - GET /v1.0/search
     - examples: [{contentType=application/json, example={
  "funds" : {
    "total" : 6,
    "funds" : [ {
      "totalAssetsCount" : 1,
      "statistic" : {
        "balanceGVT" : {
          "amount" : 5.962133916683182,
          "currency" : "Undefined"
        },
        "profitPercent" : 5.025004791520295,
        "drawdownPercent" : 9.965781217890562,
        "balanceSecondary" : {
          "amount" : 5.962133916683182,
          "currency" : "Undefined"
        },
        "investorsCount" : 9
      },
      "color" : "color",
      "manager" : {
        "registrationDate" : "2000-01-23T04:56:07.000+00:00",
        "id" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
        "avatar" : "avatar",
        "url" : "url",
        "username" : "username"
      },
      "topFundAssets" : [ {
        "name" : "name",
        "icon" : "icon",
        "asset" : "asset",
        "percent" : 4.965218492984954
      }, {
        "name" : "name",
        "icon" : "icon",
        "asset" : "asset",
        "percent" : 4.965218492984954
      } ],
      "description" : "description",
      "title" : "title",
      "url" : "url",
      "dashboardAssetsDetails" : {
        "share" : 6.84685269835264
      },
      "personalDetails" : {
        "pendingOutput" : 3.5571952270680973,
        "hasNotifications" : true,
        "pendingInput" : 6.438423552598547,
        "isOwnProgram" : true,
        "canWithdraw" : true,
        "canInvest" : true,
        "value" : 6.683562403749608,
        "profit" : 8.762042012749001,
        "invested" : 9.018348186070783,
        "isFavorite" : true,
        "isInvested" : true,
        "status" : "Active"
      },
      "logo" : "logo",
      "id" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
      "chart" : [ {
        "date" : "2000-01-23T04:56:07.000+00:00",
        "value" : 3.616076749251911
      }, {
        "date" : "2000-01-23T04:56:07.000+00:00",
        "value" : 3.616076749251911
      } ],
      "status" : "None"
    }, {
      "totalAssetsCount" : 1,
      "statistic" : {
        "balanceGVT" : {
          "amount" : 5.962133916683182,
          "currency" : "Undefined"
        },
        "profitPercent" : 5.025004791520295,
        "drawdownPercent" : 9.965781217890562,
        "balanceSecondary" : {
          "amount" : 5.962133916683182,
          "currency" : "Undefined"
        },
        "investorsCount" : 9
      },
      "color" : "color",
      "manager" : {
        "registrationDate" : "2000-01-23T04:56:07.000+00:00",
        "id" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
        "avatar" : "avatar",
        "url" : "url",
        "username" : "username"
      },
      "topFundAssets" : [ {
        "name" : "name",
        "icon" : "icon",
        "asset" : "asset",
        "percent" : 4.965218492984954
      }, {
        "name" : "name",
        "icon" : "icon",
        "asset" : "asset",
        "percent" : 4.965218492984954
      } ],
      "description" : "description",
      "title" : "title",
      "url" : "url",
      "dashboardAssetsDetails" : {
        "share" : 6.84685269835264
      },
      "personalDetails" : {
        "pendingOutput" : 3.5571952270680973,
        "hasNotifications" : true,
        "pendingInput" : 6.438423552598547,
        "isOwnProgram" : true,
        "canWithdraw" : true,
        "canInvest" : true,
        "value" : 6.683562403749608,
        "profit" : 8.762042012749001,
        "invested" : 9.018348186070783,
        "isFavorite" : true,
        "isInvested" : true,
        "status" : "Active"
      },
      "logo" : "logo",
      "id" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
      "chart" : [ {
        "date" : "2000-01-23T04:56:07.000+00:00",
        "value" : 3.616076749251911
      }, {
        "date" : "2000-01-23T04:56:07.000+00:00",
        "value" : 3.616076749251911
      } ],
      "status" : "None"
    } ]
  },
  "programs" : {
    "total" : 7,
    "programs" : [ {
      "periodDuration" : 6,
      "statistic" : {
        "balanceBase" : {
          "amount" : 5.962133916683182,
          "currency" : "Undefined"
        },
        "tradesCount" : 2,
        "balanceGVT" : {
          "amount" : 5.962133916683182,
          "currency" : "Undefined"
        },
        "profitPercent" : 2.3021358869347655,
        "profitValue" : 7.061401241503109,
        "drawdownPercent" : 9.301444243932576,
        "currentValue" : 5.637376656633329,
        "balanceSecondary" : {
          "amount" : 5.962133916683182,
          "currency" : "Undefined"
        },
        "investorsCount" : 3
      },
      "color" : "color",
      "manager" : {
        "registrationDate" : "2000-01-23T04:56:07.000+00:00",
        "id" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
        "avatar" : "avatar",
        "url" : "url",
        "username" : "username"
      },
      "level" : 0,
      "availableInvestment" : 1.4658129805029452,
      "description" : "description",
      "title" : "title",
      "url" : "url",
      "periodStarts" : "2000-01-23T04:56:07.000+00:00",
      "dashboardAssetsDetails" : {
        "share" : 6.84685269835264
      },
      "periodEnds" : "2000-01-23T04:56:07.000+00:00",
      "personalDetails" : {
        "canWithdraw" : true,
        "canInvest" : true,
        "pendingOutput" : 1.4894159098541704,
        "hasNotifications" : true,
        "pendingInput" : 1.0246457001441578,
        "isOwnProgram" : true,
        "isReinvest" : true,
        "value" : 4.145608029883936,
        "profit" : 7.386281948385884,
        "invested" : 1.2315135367772556,
        "isFavorite" : true,
        "isInvested" : true,
        "status" : "Active"
      },
      "logo" : "logo",
      "currency" : "Undefined",
      "id" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
      "chart" : [ {
        "date" : "2000-01-23T04:56:07.000+00:00",
        "value" : 3.616076749251911
      }, {
        "date" : "2000-01-23T04:56:07.000+00:00",
        "value" : 3.616076749251911
      } ],
      "status" : "None"
    }, {
      "periodDuration" : 6,
      "statistic" : {
        "balanceBase" : {
          "amount" : 5.962133916683182,
          "currency" : "Undefined"
        },
        "tradesCount" : 2,
        "balanceGVT" : {
          "amount" : 5.962133916683182,
          "currency" : "Undefined"
        },
        "profitPercent" : 2.3021358869347655,
        "profitValue" : 7.061401241503109,
        "drawdownPercent" : 9.301444243932576,
        "currentValue" : 5.637376656633329,
        "balanceSecondary" : {
          "amount" : 5.962133916683182,
          "currency" : "Undefined"
        },
        "investorsCount" : 3
      },
      "color" : "color",
      "manager" : {
        "registrationDate" : "2000-01-23T04:56:07.000+00:00",
        "id" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
        "avatar" : "avatar",
        "url" : "url",
        "username" : "username"
      },
      "level" : 0,
      "availableInvestment" : 1.4658129805029452,
      "description" : "description",
      "title" : "title",
      "url" : "url",
      "periodStarts" : "2000-01-23T04:56:07.000+00:00",
      "dashboardAssetsDetails" : {
        "share" : 6.84685269835264
      },
      "periodEnds" : "2000-01-23T04:56:07.000+00:00",
      "personalDetails" : {
        "canWithdraw" : true,
        "canInvest" : true,
        "pendingOutput" : 1.4894159098541704,
        "hasNotifications" : true,
        "pendingInput" : 1.0246457001441578,
        "isOwnProgram" : true,
        "isReinvest" : true,
        "value" : 4.145608029883936,
        "profit" : 7.386281948385884,
        "invested" : 1.2315135367772556,
        "isFavorite" : true,
        "isInvested" : true,
        "status" : "Active"
      },
      "logo" : "logo",
      "currency" : "Undefined",
      "id" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
      "chart" : [ {
        "date" : "2000-01-23T04:56:07.000+00:00",
        "value" : 3.616076749251911
      }, {
        "date" : "2000-01-23T04:56:07.000+00:00",
        "value" : 3.616076749251911
      } ],
      "status" : "None"
    } ]
  },
  "managers" : {
    "total" : 1,
    "managers" : [ {
      "assets" : [ "assets", "assets" ],
      "about" : "about",
      "regDate" : "2000-01-23T04:56:07.000+00:00",
      "id" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
      "avatar" : "avatar",
      "url" : "url",
      "username" : "username"
    }, {
      "assets" : [ "assets", "assets" ],
      "about" : "about",
      "regDate" : "2000-01-23T04:56:07.000+00:00",
      "id" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
      "avatar" : "avatar",
      "url" : "url",
      "username" : "username"
    } ]
  }
}}]
     
     - parameter mask: (query)  (optional)
     - parameter take: (query)  (optional)

     - returns: RequestBuilder<SearchViewModel> 
     */
    open class func v10SearchGetWithRequestBuilder(mask: String? = nil, take: Int? = nil) -> RequestBuilder<SearchViewModel> {
        let path = "/v1.0/search"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)
        url?.queryItems = APIHelper.mapValuesToQueryItems(values:[
            "mask": mask, 
            "take": take?.encodeToJSON()
        ])
        

        let requestBuilder: RequestBuilder<SearchViewModel>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

}