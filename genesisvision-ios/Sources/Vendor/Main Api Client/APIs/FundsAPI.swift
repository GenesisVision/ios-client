//
// FundsAPI.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation
import Alamofire



open class FundsAPI {
    /**
     Get all supported assets for funds
     
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func v10FundsAssetsGet(completion: @escaping ((_ data: PlatformAssets?,_ error: Error?) -> Void)) {
        v10FundsAssetsGetWithRequestBuilder().execute { (response, error) -> Void in
            completion(response?.body, error);
        }
    }


    /**
     Get all supported assets for funds
     - GET /v1.0/funds/assets
     - examples: [{contentType=application/json, example={
  "assets" : [ {
    "color" : "color",
    "name" : "name",
    "icon" : "icon",
    "description" : "description",
    "id" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
    "asset" : "asset"
  }, {
    "color" : "color",
    "name" : "name",
    "icon" : "icon",
    "description" : "description",
    "id" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
    "asset" : "asset"
  } ]
}}]

     - returns: RequestBuilder<PlatformAssets> 
     */
    open class func v10FundsAssetsGetWithRequestBuilder() -> RequestBuilder<PlatformAssets> {
        let path = "/v1.0/funds/assets"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)


        let requestBuilder: RequestBuilder<PlatformAssets>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**
     Fund assets info
     
     - parameter id: (path)  
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func v10FundsByIdAssetsGet(id: UUID, completion: @escaping ((_ data: FundAssetsListInfo?,_ error: Error?) -> Void)) {
        v10FundsByIdAssetsGetWithRequestBuilder(id: id).execute { (response, error) -> Void in
            completion(response?.body, error);
        }
    }


    /**
     Fund assets info
     - GET /v1.0/funds/{id}/assets
     - examples: [{contentType=application/json, example={
  "assets" : [ {
    "symbol" : "symbol",
    "current" : 6.027456183070403,
    "icon" : "icon",
    "asset" : "asset",
    "target" : 0.8008281904610115
  }, {
    "symbol" : "symbol",
    "current" : 6.027456183070403,
    "icon" : "icon",
    "asset" : "asset",
    "target" : 0.8008281904610115
  } ]
}}]
     
     - parameter id: (path)  

     - returns: RequestBuilder<FundAssetsListInfo> 
     */
    open class func v10FundsByIdAssetsGetWithRequestBuilder(id: UUID) -> RequestBuilder<FundAssetsListInfo> {
        var path = "/v1.0/funds/{id}/assets"
        path = path.replacingOccurrences(of: "{id}", with: "\(id)", options: .literal, range: nil)
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)


        let requestBuilder: RequestBuilder<FundAssetsListInfo>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**
     Fund balance chart
     
     - parameter id: (path)  
     - parameter dateFrom: (query)  (optional)
     - parameter dateTo: (query)  (optional)
     - parameter maxPointCount: (query)  (optional)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func v10FundsByIdChartsBalanceGet(id: UUID, dateFrom: Date? = nil, dateTo: Date? = nil, maxPointCount: Int? = nil, completion: @escaping ((_ data: FundBalanceChart?,_ error: Error?) -> Void)) {
        v10FundsByIdChartsBalanceGetWithRequestBuilder(id: id, dateFrom: dateFrom, dateTo: dateTo, maxPointCount: maxPointCount).execute { (response, error) -> Void in
            completion(response?.body, error);
        }
    }


    /**
     Fund balance chart
     - GET /v1.0/funds/{id}/charts/balance
     - examples: [{contentType=application/json, example={
  "usdBalance" : 0.8008281904610115,
  "balanceChart" : [ {
    "date" : "2000-01-23T04:56:07.000+00:00",
    "investorsFunds" : 1.4658129805029452,
    "managerFunds" : 6.027456183070403
  }, {
    "date" : "2000-01-23T04:56:07.000+00:00",
    "investorsFunds" : 1.4658129805029452,
    "managerFunds" : 6.027456183070403
  } ],
  "gvtBalance" : 5.962133916683182
}}]
     
     - parameter id: (path)  
     - parameter dateFrom: (query)  (optional)
     - parameter dateTo: (query)  (optional)
     - parameter maxPointCount: (query)  (optional)

     - returns: RequestBuilder<FundBalanceChart> 
     */
    open class func v10FundsByIdChartsBalanceGetWithRequestBuilder(id: UUID, dateFrom: Date? = nil, dateTo: Date? = nil, maxPointCount: Int? = nil) -> RequestBuilder<FundBalanceChart> {
        var path = "/v1.0/funds/{id}/charts/balance"
        path = path.replacingOccurrences(of: "{id}", with: "\(id)", options: .literal, range: nil)
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)
        url?.queryItems = APIHelper.mapValuesToQueryItems(values:[
            "DateFrom": dateFrom?.encodeToJSON(), 
            "DateTo": dateTo?.encodeToJSON(), 
            "MaxPointCount": maxPointCount?.encodeToJSON()
        ])
        

        let requestBuilder: RequestBuilder<FundBalanceChart>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**
     Fund profit chart
     
     - parameter id: (path)  
     - parameter dateFrom: (query)  (optional)
     - parameter dateTo: (query)  (optional)
     - parameter maxPointCount: (query)  (optional)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func v10FundsByIdChartsProfitGet(id: UUID, dateFrom: Date? = nil, dateTo: Date? = nil, maxPointCount: Int? = nil, completion: @escaping ((_ data: FundProfitChart?,_ error: Error?) -> Void)) {
        v10FundsByIdChartsProfitGetWithRequestBuilder(id: id, dateFrom: dateFrom, dateTo: dateTo, maxPointCount: maxPointCount).execute { (response, error) -> Void in
            completion(response?.body, error);
        }
    }


    /**
     Fund profit chart
     - GET /v1.0/funds/{id}/charts/profit
     - examples: [{contentType=application/json, example={
  "profitChangePercent" : 6.965117697638846,
  "calmarRatio" : 6.778324963048013,
  "timeframeGvtProfit" : 6.704019297950036,
  "timeframeUsdProfit" : 8.762042012749001,
  "maxDrawdown" : 6.878052220127876,
  "creationDate" : "2000-01-23T04:56:07.000+00:00",
  "equityChart" : [ {
    "date" : "2000-01-23T04:56:07.000+00:00",
    "value" : 3.616076749251911
  }, {
    "date" : "2000-01-23T04:56:07.000+00:00",
    "value" : 3.616076749251911
  } ],
  "investors" : 3,
  "totalGvtProfit" : 5.944895607614016,
  "sortinoRatio" : 2.8841621266687802,
  "rebalances" : 9,
  "balance" : 6.438423552598547,
  "rate" : 3.353193347011243,
  "totalUsdProfit" : 6.683562403749608,
  "sharpeRatio" : 1.284659006116532
}}]
     
     - parameter id: (path)  
     - parameter dateFrom: (query)  (optional)
     - parameter dateTo: (query)  (optional)
     - parameter maxPointCount: (query)  (optional)

     - returns: RequestBuilder<FundProfitChart> 
     */
    open class func v10FundsByIdChartsProfitGetWithRequestBuilder(id: UUID, dateFrom: Date? = nil, dateTo: Date? = nil, maxPointCount: Int? = nil) -> RequestBuilder<FundProfitChart> {
        var path = "/v1.0/funds/{id}/charts/profit"
        path = path.replacingOccurrences(of: "{id}", with: "\(id)", options: .literal, range: nil)
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)
        url?.queryItems = APIHelper.mapValuesToQueryItems(values:[
            "DateFrom": dateFrom?.encodeToJSON(), 
            "DateTo": dateTo?.encodeToJSON(), 
            "MaxPointCount": maxPointCount?.encodeToJSON()
        ])
        

        let requestBuilder: RequestBuilder<FundProfitChart>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**
     Add to favorites
     
     - parameter id: (path)  
     - parameter authorization: (header) JWT access token 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func v10FundsByIdFavoriteAddPost(id: UUID, authorization: String, completion: @escaping ((_ error: Error?) -> Void)) {
        v10FundsByIdFavoriteAddPostWithRequestBuilder(id: id, authorization: authorization).execute { (response, error) -> Void in
            completion(error);
        }
    }


    /**
     Add to favorites
     - POST /v1.0/funds/{id}/favorite/add
     
     - parameter id: (path)  
     - parameter authorization: (header) JWT access token 

     - returns: RequestBuilder<Void> 
     */
    open class func v10FundsByIdFavoriteAddPostWithRequestBuilder(id: UUID, authorization: String) -> RequestBuilder<Void> {
        var path = "/v1.0/funds/{id}/favorite/add"
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
     Remove from favorites
     
     - parameter id: (path)  
     - parameter authorization: (header) JWT access token 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func v10FundsByIdFavoriteRemovePost(id: UUID, authorization: String, completion: @escaping ((_ error: Error?) -> Void)) {
        v10FundsByIdFavoriteRemovePostWithRequestBuilder(id: id, authorization: authorization).execute { (response, error) -> Void in
            completion(error);
        }
    }


    /**
     Remove from favorites
     - POST /v1.0/funds/{id}/favorite/remove
     
     - parameter id: (path)  
     - parameter authorization: (header) JWT access token 

     - returns: RequestBuilder<Void> 
     */
    open class func v10FundsByIdFavoriteRemovePostWithRequestBuilder(id: UUID, authorization: String) -> RequestBuilder<Void> {
        var path = "/v1.0/funds/{id}/favorite/remove"
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
     * enum for parameter currencySecondary
     */
    public enum CurrencySecondary_v10FundsByIdGet: String { 
        case undefined = "Undefined"
        case gvt = "GVT"
        case eth = "ETH"
        case btc = "BTC"
        case ada = "ADA"
        case usdt = "USDT"
        case xrp = "XRP"
        case bch = "BCH"
        case ltc = "LTC"
        case doge = "DOGE"
        case usd = "USD"
        case eur = "EUR"
    }

    /**
     Funds details
     
     - parameter id: (path)  
     - parameter authorization: (header)  (optional)
     - parameter currencySecondary: (query)  (optional)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func v10FundsByIdGet(id: String, authorization: String? = nil, currencySecondary: CurrencySecondary_v10FundsByIdGet? = nil, completion: @escaping ((_ data: FundDetailsFull?,_ error: Error?) -> Void)) {
        v10FundsByIdGetWithRequestBuilder(id: id, authorization: authorization, currencySecondary: currencySecondary).execute { (response, error) -> Void in
            completion(response?.body, error);
        }
    }


    /**
     Funds details
     - GET /v1.0/funds/{id}
     - examples: [{contentType=application/json, example={
  "entryFee" : 0.8008281904610115,
  "statistic" : {
    "balanceGVT" : {
      "amount" : 5.962133916683182,
      "currency" : "Undefined"
    },
    "profitPercent" : 5.637376656633329,
    "rebalancingCount" : 2,
    "investedAmount" : 3.616076749251911,
    "drawdownPercent" : 2.3021358869347655,
    "startDate" : "2000-01-23T04:56:07.000+00:00",
    "startBalance" : 9.301444243932576,
    "balanceSecondary" : {
      "amount" : 5.962133916683182,
      "currency" : "Undefined"
    },
    "investorsCount" : 7
  },
  "color" : "color",
  "manager" : {
    "registrationDate" : "2000-01-23T04:56:07.000+00:00",
    "id" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
    "avatar" : "avatar",
    "url" : "url",
    "username" : "username"
  },
  "description" : "description",
  "title" : "title",
  "currentAssets" : [ {
    "color" : "color",
    "icon" : "icon",
    "name" : "name",
    "asset" : "asset",
    "percent" : 5.962133916683182
  }, {
    "color" : "color",
    "icon" : "icon",
    "name" : "name",
    "asset" : "asset",
    "percent" : 5.962133916683182
  } ],
  "personalFundDetails" : {
    "canCloseProgram" : true,
    "canWithdraw" : true,
    "canInvest" : true,
    "canClosePeriod" : true,
    "canReallocate" : true,
    "pendingOutput" : 1.284659006116532,
    "hasNotifications" : true,
    "pendingInput" : 6.965117697638846,
    "isOwnProgram" : true,
    "possibleReallocationTime" : "2000-01-23T04:56:07.000+00:00",
    "isFinishing" : true,
    "value" : 9.018348186070783,
    "profit" : 6.438423552598547,
    "withdrawPercent" : 8.762042012749001,
    "invested" : 3.5571952270680973,
    "isFavorite" : true,
    "isInvested" : true,
    "status" : "Pending"
  },
  "url" : "url",
  "exitFee" : 6.027456183070403,
  "managementFee" : 1.4658129805029452,
  "ipfsHash" : "ipfsHash",
  "logo" : "logo",
  "id" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
  "status" : "None"
}}]
     
     - parameter id: (path)  
     - parameter authorization: (header)  (optional)
     - parameter currencySecondary: (query)  (optional)

     - returns: RequestBuilder<FundDetailsFull> 
     */
    open class func v10FundsByIdGetWithRequestBuilder(id: String, authorization: String? = nil, currencySecondary: CurrencySecondary_v10FundsByIdGet? = nil) -> RequestBuilder<FundDetailsFull> {
        var path = "/v1.0/funds/{id}"
        path = path.replacingOccurrences(of: "{id}", with: "\(id)", options: .literal, range: nil)
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)
        url?.queryItems = APIHelper.mapValuesToQueryItems(values:[
            "currencySecondary": currencySecondary?.rawValue
        ])
        
        let nillableHeaders: [String: Any?] = [
            "Authorization": authorization
        ]
        let headerParameters = APIHelper.rejectNilHeaders(nillableHeaders)

        let requestBuilder: RequestBuilder<FundDetailsFull>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false, headers: headerParameters)
    }

    /**
     * enum for parameter sorting
     */
    public enum Sorting_v10FundsGet: String { 
        case byProfitAsc = "ByProfitAsc"
        case byProfitDesc = "ByProfitDesc"
        case byDrawdownAsc = "ByDrawdownAsc"
        case byDrawdownDesc = "ByDrawdownDesc"
        case byInvestorsAsc = "ByInvestorsAsc"
        case byInvestorsDesc = "ByInvestorsDesc"
        case byNewAsc = "ByNewAsc"
        case byNewDesc = "ByNewDesc"
        case byTitleAsc = "ByTitleAsc"
        case byTitleDesc = "ByTitleDesc"
        case byBalanceAsc = "ByBalanceAsc"
        case byBalanceDesc = "ByBalanceDesc"
    }

    /**
     * enum for parameter currencySecondary
     */
    public enum CurrencySecondary_v10FundsGet: String { 
        case undefined = "Undefined"
        case gvt = "GVT"
        case eth = "ETH"
        case btc = "BTC"
        case ada = "ADA"
        case usdt = "USDT"
        case xrp = "XRP"
        case bch = "BCH"
        case ltc = "LTC"
        case doge = "DOGE"
        case usd = "USD"
        case eur = "EUR"
    }

    /**
     Funds list
     
     - parameter authorization: (header)  (optional)
     - parameter sorting: (query)  (optional)
     - parameter currencySecondary: (query)  (optional)
     - parameter statisticDateFrom: (query)  (optional)
     - parameter statisticDateTo: (query)  (optional)
     - parameter chartPointsCount: (query)  (optional)
     - parameter mask: (query)  (optional)
     - parameter facetId: (query)  (optional)
     - parameter isFavorite: (query)  (optional)
     - parameter isEnabled: (query)  (optional)
     - parameter ids: (query)  (optional)
     - parameter managerId: (query)  (optional)
     - parameter programManagerId: (query)  (optional)
     - parameter skip: (query)  (optional)
     - parameter take: (query)  (optional)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func v10FundsGet(authorization: String? = nil, sorting: Sorting_v10FundsGet? = nil, currencySecondary: CurrencySecondary_v10FundsGet? = nil, statisticDateFrom: Date? = nil, statisticDateTo: Date? = nil, chartPointsCount: Int? = nil, mask: String? = nil, facetId: String? = nil, isFavorite: Bool? = nil, isEnabled: Bool? = nil, ids: [UUID]? = nil, managerId: String? = nil, programManagerId: UUID? = nil, skip: Int? = nil, take: Int? = nil, completion: @escaping ((_ data: FundsList?,_ error: Error?) -> Void)) {
        v10FundsGetWithRequestBuilder(authorization: authorization, sorting: sorting, currencySecondary: currencySecondary, statisticDateFrom: statisticDateFrom, statisticDateTo: statisticDateTo, chartPointsCount: chartPointsCount, mask: mask, facetId: facetId, isFavorite: isFavorite, isEnabled: isEnabled, ids: ids, managerId: managerId, programManagerId: programManagerId, skip: skip, take: take).execute { (response, error) -> Void in
            completion(response?.body, error);
        }
    }


    /**
     Funds list
     - GET /v1.0/funds
     - examples: [{contentType=application/json, example={
  "total" : 2,
  "funds" : [ {
    "totalAssetsCount" : 4,
    "statistic" : {
      "balanceGVT" : {
        "amount" : 5.962133916683182,
        "currency" : "Undefined"
      },
      "profitPercent" : 9.965781217890562,
      "drawdownPercent" : 9.369310271410669,
      "balanceSecondary" : {
        "amount" : 5.962133916683182,
        "currency" : "Undefined"
      },
      "investorsCount" : 6
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
      "percent" : 5.025004791520295
    }, {
      "name" : "name",
      "icon" : "icon",
      "asset" : "asset",
      "percent" : 5.025004791520295
    } ],
    "description" : "description",
    "title" : "title",
    "url" : "url",
    "dashboardAssetsDetails" : {
      "share" : 7.457744773683766
    },
    "personalDetails" : {
      "canCloseProgram" : true,
      "canWithdraw" : true,
      "canInvest" : true,
      "canClosePeriod" : true,
      "canReallocate" : true,
      "pendingOutput" : 1.284659006116532,
      "hasNotifications" : true,
      "pendingInput" : 6.965117697638846,
      "isOwnProgram" : true,
      "possibleReallocationTime" : "2000-01-23T04:56:07.000+00:00",
      "isFinishing" : true,
      "value" : 9.018348186070783,
      "profit" : 6.438423552598547,
      "withdrawPercent" : 8.762042012749001,
      "invested" : 3.5571952270680973,
      "isFavorite" : true,
      "isInvested" : true,
      "status" : "Pending"
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
    "totalAssetsCount" : 4,
    "statistic" : {
      "balanceGVT" : {
        "amount" : 5.962133916683182,
        "currency" : "Undefined"
      },
      "profitPercent" : 9.965781217890562,
      "drawdownPercent" : 9.369310271410669,
      "balanceSecondary" : {
        "amount" : 5.962133916683182,
        "currency" : "Undefined"
      },
      "investorsCount" : 6
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
      "percent" : 5.025004791520295
    }, {
      "name" : "name",
      "icon" : "icon",
      "asset" : "asset",
      "percent" : 5.025004791520295
    } ],
    "description" : "description",
    "title" : "title",
    "url" : "url",
    "dashboardAssetsDetails" : {
      "share" : 7.457744773683766
    },
    "personalDetails" : {
      "canCloseProgram" : true,
      "canWithdraw" : true,
      "canInvest" : true,
      "canClosePeriod" : true,
      "canReallocate" : true,
      "pendingOutput" : 1.284659006116532,
      "hasNotifications" : true,
      "pendingInput" : 6.965117697638846,
      "isOwnProgram" : true,
      "possibleReallocationTime" : "2000-01-23T04:56:07.000+00:00",
      "isFinishing" : true,
      "value" : 9.018348186070783,
      "profit" : 6.438423552598547,
      "withdrawPercent" : 8.762042012749001,
      "invested" : 3.5571952270680973,
      "isFavorite" : true,
      "isInvested" : true,
      "status" : "Pending"
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
}}]
     
     - parameter authorization: (header)  (optional)
     - parameter sorting: (query)  (optional)
     - parameter currencySecondary: (query)  (optional)
     - parameter statisticDateFrom: (query)  (optional)
     - parameter statisticDateTo: (query)  (optional)
     - parameter chartPointsCount: (query)  (optional)
     - parameter mask: (query)  (optional)
     - parameter facetId: (query)  (optional)
     - parameter isFavorite: (query)  (optional)
     - parameter isEnabled: (query)  (optional)
     - parameter ids: (query)  (optional)
     - parameter managerId: (query)  (optional)
     - parameter programManagerId: (query)  (optional)
     - parameter skip: (query)  (optional)
     - parameter take: (query)  (optional)

     - returns: RequestBuilder<FundsList> 
     */
    open class func v10FundsGetWithRequestBuilder(authorization: String? = nil, sorting: Sorting_v10FundsGet? = nil, currencySecondary: CurrencySecondary_v10FundsGet? = nil, statisticDateFrom: Date? = nil, statisticDateTo: Date? = nil, chartPointsCount: Int? = nil, mask: String? = nil, facetId: String? = nil, isFavorite: Bool? = nil, isEnabled: Bool? = nil, ids: [UUID]? = nil, managerId: String? = nil, programManagerId: UUID? = nil, skip: Int? = nil, take: Int? = nil) -> RequestBuilder<FundsList> {
        let path = "/v1.0/funds"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)
        url?.queryItems = APIHelper.mapValuesToQueryItems(values:[
            "Sorting": sorting?.rawValue, 
            "CurrencySecondary": currencySecondary?.rawValue, 
            "StatisticDateFrom": statisticDateFrom?.encodeToJSON(), 
            "StatisticDateTo": statisticDateTo?.encodeToJSON(), 
            "ChartPointsCount": chartPointsCount?.encodeToJSON(), 
            "Mask": mask, 
            "FacetId": facetId, 
            "IsFavorite": isFavorite, 
            "IsEnabled": isEnabled, 
            "Ids": ids, 
            "ManagerId": managerId, 
            "ProgramManagerId": programManagerId, 
            "Skip": skip?.encodeToJSON(), 
            "Take": take?.encodeToJSON()
        ])
        
        let nillableHeaders: [String: Any?] = [
            "Authorization": authorization
        ]
        let headerParameters = APIHelper.rejectNilHeaders(nillableHeaders)

        let requestBuilder: RequestBuilder<FundsList>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false, headers: headerParameters)
    }

    /**
     Fund sets
     
     - parameter authorization: (header) JWT access token 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func v10FundsSetsGet(authorization: String, completion: @escaping ((_ data: ProgramSets?,_ error: Error?) -> Void)) {
        v10FundsSetsGetWithRequestBuilder(authorization: authorization).execute { (response, error) -> Void in
            completion(response?.body, error);
        }
    }


    /**
     Fund sets
     - GET /v1.0/funds/sets
     - examples: [{contentType=application/json, example={
  "sets" : [ {
    "sortType" : "New",
    "description" : "description",
    "logo" : "logo",
    "id" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
    "title" : "title",
    "url" : "url"
  }, {
    "sortType" : "New",
    "description" : "description",
    "logo" : "logo",
    "id" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
    "title" : "title",
    "url" : "url"
  } ],
  "favoritesCount" : 0
}}]
     
     - parameter authorization: (header) JWT access token 

     - returns: RequestBuilder<ProgramSets> 
     */
    open class func v10FundsSetsGetWithRequestBuilder(authorization: String) -> RequestBuilder<ProgramSets> {
        let path = "/v1.0/funds/sets"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)

        let nillableHeaders: [String: Any?] = [
            "Authorization": authorization
        ]
        let headerParameters = APIHelper.rejectNilHeaders(nillableHeaders)

        let requestBuilder: RequestBuilder<ProgramSets>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false, headers: headerParameters)
    }

}
