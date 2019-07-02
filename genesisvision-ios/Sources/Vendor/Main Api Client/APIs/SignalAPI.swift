//
// SignalAPI.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation
import Alamofire



open class SignalAPI {
    /**
     Get copytrading accounts
     
     - parameter authorization: (header) JWT access token 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func v10SignalAccountsGet(authorization: String, completion: @escaping ((_ data: CopyTradingAccountsList?,_ error: Error?) -> Void)) {
        v10SignalAccountsGetWithRequestBuilder(authorization: authorization).execute { (response, error) -> Void in
            completion(response?.body, error);
        }
    }


    /**
     Get copytrading accounts
     - GET /v1.0/signal/accounts
     - examples: [{contentType=application/json, example={
  "total" : 2,
  "accounts" : [ {
    "freeMargin" : 1.4658129805029452,
    "balance" : 0.8008281904610115,
    "available" : 5.637376656633329,
    "logo" : "logo",
    "currency" : "Undefined",
    "id" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
    "title" : "title",
    "equity" : 6.027456183070403,
    "marginLevel" : 5.962133916683182
  }, {
    "freeMargin" : 1.4658129805029452,
    "balance" : 0.8008281904610115,
    "available" : 5.637376656633329,
    "logo" : "logo",
    "currency" : "Undefined",
    "id" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
    "title" : "title",
    "equity" : 6.027456183070403,
    "marginLevel" : 5.962133916683182
  } ]
}}]
     
     - parameter authorization: (header) JWT access token 

     - returns: RequestBuilder<CopyTradingAccountsList> 
     */
    open class func v10SignalAccountsGetWithRequestBuilder(authorization: String) -> RequestBuilder<CopyTradingAccountsList> {
        let path = "/v1.0/signal/accounts"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)

        let nillableHeaders: [String: Any?] = [
            "Authorization": authorization
        ]
        let headerParameters = APIHelper.rejectNilHeaders(nillableHeaders)

        let requestBuilder: RequestBuilder<CopyTradingAccountsList>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false, headers: headerParameters)
    }

    /**
     Get subscribe to programs signals info
     
     - parameter id: (path)  
     - parameter authorization: (header) JWT access token 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func v10SignalAttachByIdInfoGet(id: UUID, authorization: String, completion: @escaping ((_ data: AttachToSignalProviderInfo?,_ error: Error?) -> Void)) {
        v10SignalAttachByIdInfoGetWithRequestBuilder(id: id, authorization: authorization).execute { (response, error) -> Void in
            completion(response?.body, error);
        }
    }


    /**
     Get subscribe to programs signals info
     - GET /v1.0/signal/attach/{id}/info
     - examples: [{contentType=application/json, example={
  "minDepositCurrency" : "Undefined",
  "hasSignalAccount" : true,
  "volumeFee" : 0.8008281904610115,
  "minDeposit" : 6.027456183070403,
  "hasActiveSubscription" : true
}}]
     
     - parameter id: (path)  
     - parameter authorization: (header) JWT access token 

     - returns: RequestBuilder<AttachToSignalProviderInfo> 
     */
    open class func v10SignalAttachByIdInfoGetWithRequestBuilder(id: UUID, authorization: String) -> RequestBuilder<AttachToSignalProviderInfo> {
        var path = "/v1.0/signal/attach/{id}/info"
        path = path.replacingOccurrences(of: "{id}", with: "\(id)", options: .literal, range: nil)
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)

        let nillableHeaders: [String: Any?] = [
            "Authorization": authorization
        ]
        let headerParameters = APIHelper.rejectNilHeaders(nillableHeaders)

        let requestBuilder: RequestBuilder<AttachToSignalProviderInfo>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false, headers: headerParameters)
    }

    /**
     Subscribe to programs signals
     
     - parameter id: (path) Program Id 
     - parameter authorization: (header) JWT access token 
     - parameter model: (body) Subscription settings (optional)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func v10SignalAttachByIdPost(id: UUID, authorization: String, model: AttachToSignalProvider? = nil, completion: @escaping ((_ error: Error?) -> Void)) {
        v10SignalAttachByIdPostWithRequestBuilder(id: id, authorization: authorization, model: model).execute { (response, error) -> Void in
            completion(error);
        }
    }


    /**
     Subscribe to programs signals
     - POST /v1.0/signal/attach/{id}
     
     - parameter id: (path) Program Id 
     - parameter authorization: (header) JWT access token 
     - parameter model: (body) Subscription settings (optional)

     - returns: RequestBuilder<Void> 
     */
    open class func v10SignalAttachByIdPostWithRequestBuilder(id: UUID, authorization: String, model: AttachToSignalProvider? = nil) -> RequestBuilder<Void> {
        var path = "/v1.0/signal/attach/{id}"
        path = path.replacingOccurrences(of: "{id}", with: "\(id)", options: .literal, range: nil)
        let URLString = SwaggerClientAPI.basePath + path
        let parameters = JSONEncodingHelper.encodingParameters(forEncodableObject: model)

        let url = NSURLComponents(string: URLString)

        let nillableHeaders: [String: Any?] = [
            "Authorization": authorization
        ]
        let headerParameters = APIHelper.rejectNilHeaders(nillableHeaders)

        let requestBuilder: RequestBuilder<Void>.Type = SwaggerClientAPI.requestBuilderFactory.getNonDecodableBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true, headers: headerParameters)
    }

    /**
     Update signal subscription settings
     
     - parameter id: (path) Program id 
     - parameter authorization: (header) JWT access token 
     - parameter model: (body) Subscription settings (optional)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func v10SignalByIdUpdatePost(id: UUID, authorization: String, model: AttachToSignalProvider? = nil, completion: @escaping ((_ error: Error?) -> Void)) {
        v10SignalByIdUpdatePostWithRequestBuilder(id: id, authorization: authorization, model: model).execute { (response, error) -> Void in
            completion(error);
        }
    }


    /**
     Update signal subscription settings
     - POST /v1.0/signal/{id}/update
     
     - parameter id: (path) Program id 
     - parameter authorization: (header) JWT access token 
     - parameter model: (body) Subscription settings (optional)

     - returns: RequestBuilder<Void> 
     */
    open class func v10SignalByIdUpdatePostWithRequestBuilder(id: UUID, authorization: String, model: AttachToSignalProvider? = nil) -> RequestBuilder<Void> {
        var path = "/v1.0/signal/{id}/update"
        path = path.replacingOccurrences(of: "{id}", with: "\(id)", options: .literal, range: nil)
        let URLString = SwaggerClientAPI.basePath + path
        let parameters = JSONEncodingHelper.encodingParameters(forEncodableObject: model)

        let url = NSURLComponents(string: URLString)

        let nillableHeaders: [String: Any?] = [
            "Authorization": authorization
        ]
        let headerParameters = APIHelper.rejectNilHeaders(nillableHeaders)

        let requestBuilder: RequestBuilder<Void>.Type = SwaggerClientAPI.requestBuilderFactory.getNonDecodableBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true, headers: headerParameters)
    }

    /**
     Unsubscribe from program signals
     
     - parameter id: (path)  
     - parameter authorization: (header) JWT access token 
     - parameter model: (body)  (optional)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func v10SignalDetachByIdPost(id: UUID, authorization: String, model: DetachFromSignalProvider? = nil, completion: @escaping ((_ error: Error?) -> Void)) {
        v10SignalDetachByIdPostWithRequestBuilder(id: id, authorization: authorization, model: model).execute { (response, error) -> Void in
            completion(error);
        }
    }


    /**
     Unsubscribe from program signals
     - POST /v1.0/signal/detach/{id}
     
     - parameter id: (path)  
     - parameter authorization: (header) JWT access token 
     - parameter model: (body)  (optional)

     - returns: RequestBuilder<Void> 
     */
    open class func v10SignalDetachByIdPostWithRequestBuilder(id: UUID, authorization: String, model: DetachFromSignalProvider? = nil) -> RequestBuilder<Void> {
        var path = "/v1.0/signal/detach/{id}"
        path = path.replacingOccurrences(of: "{id}", with: "\(id)", options: .literal, range: nil)
        let URLString = SwaggerClientAPI.basePath + path
        let parameters = JSONEncodingHelper.encodingParameters(forEncodableObject: model)

        let url = NSURLComponents(string: URLString)

        let nillableHeaders: [String: Any?] = [
            "Authorization": authorization
        ]
        let headerParameters = APIHelper.rejectNilHeaders(nillableHeaders)

        let requestBuilder: RequestBuilder<Void>.Type = SwaggerClientAPI.requestBuilderFactory.getNonDecodableBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true, headers: headerParameters)
    }

    /**
     Close signal trade
     
     - parameter id: (path) Trade id 
     - parameter authorization: (header) JWT access token 
     - parameter programId: (query) Provider program id (optional)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func v10SignalTradesByIdClosePost(id: UUID, authorization: String, programId: UUID? = nil, completion: @escaping ((_ error: Error?) -> Void)) {
        v10SignalTradesByIdClosePostWithRequestBuilder(id: id, authorization: authorization, programId: programId).execute { (response, error) -> Void in
            completion(error);
        }
    }


    /**
     Close signal trade
     - POST /v1.0/signal/trades/{id}/close
     
     - parameter id: (path) Trade id 
     - parameter authorization: (header) JWT access token 
     - parameter programId: (query) Provider program id (optional)

     - returns: RequestBuilder<Void> 
     */
    open class func v10SignalTradesByIdClosePostWithRequestBuilder(id: UUID, authorization: String, programId: UUID? = nil) -> RequestBuilder<Void> {
        var path = "/v1.0/signal/trades/{id}/close"
        path = path.replacingOccurrences(of: "{id}", with: "\(id)", options: .literal, range: nil)
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)
        url?.queryItems = APIHelper.mapValuesToQueryItems(values:[
            "programId": programId
        ])
        
        let nillableHeaders: [String: Any?] = [
            "Authorization": authorization
        ]
        let headerParameters = APIHelper.rejectNilHeaders(nillableHeaders)

        let requestBuilder: RequestBuilder<Void>.Type = SwaggerClientAPI.requestBuilderFactory.getNonDecodableBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false, headers: headerParameters)
    }

    /**
     * enum for parameter sorting
     */
    public enum Sorting_v10SignalTradesGet: String { 
        case byDateAsc = "ByDateAsc"
        case byDateDesc = "ByDateDesc"
        case byTicketAsc = "ByTicketAsc"
        case byTicketDesc = "ByTicketDesc"
        case bySymbolAsc = "BySymbolAsc"
        case bySymbolDesc = "BySymbolDesc"
        case byDirectionAsc = "ByDirectionAsc"
        case byDirectionDesc = "ByDirectionDesc"
        case byVolumeAsc = "ByVolumeAsc"
        case byVolumeDesc = "ByVolumeDesc"
        case byPriceAsc = "ByPriceAsc"
        case byPriceDesc = "ByPriceDesc"
        case byPriceCurrentAsc = "ByPriceCurrentAsc"
        case byPriceCurrentDesc = "ByPriceCurrentDesc"
        case byProfitAsc = "ByProfitAsc"
        case byProfitDesc = "ByProfitDesc"
        case byCommissionAsc = "ByCommissionAsc"
        case byCommissionDesc = "ByCommissionDesc"
        case bySwapAsc = "BySwapAsc"
        case bySwapDesc = "BySwapDesc"
    }

    /**
     * enum for parameter accountCurrency
     */
    public enum AccountCurrency_v10SignalTradesGet: String { 
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
        case bnb = "BNB"
        case usd = "USD"
        case eur = "EUR"
    }

    /**
     Get investors signals trades history
     
     - parameter authorization: (header) JWT access token 
     - parameter dateFrom: (query)  (optional)
     - parameter dateTo: (query)  (optional)
     - parameter symbol: (query)  (optional)
     - parameter sorting: (query)  (optional)
     - parameter accountId: (query)  (optional)
     - parameter accountCurrency: (query)  (optional)
     - parameter skip: (query)  (optional)
     - parameter take: (query)  (optional)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func v10SignalTradesGet(authorization: String, dateFrom: Date? = nil, dateTo: Date? = nil, symbol: String? = nil, sorting: Sorting_v10SignalTradesGet? = nil, accountId: UUID? = nil, accountCurrency: AccountCurrency_v10SignalTradesGet? = nil, skip: Int? = nil, take: Int? = nil, completion: @escaping ((_ data: TradesSignalViewModel?,_ error: Error?) -> Void)) {
        v10SignalTradesGetWithRequestBuilder(authorization: authorization, dateFrom: dateFrom, dateTo: dateTo, symbol: symbol, sorting: sorting, accountId: accountId, accountCurrency: accountCurrency, skip: skip, take: take).execute { (response, error) -> Void in
            completion(response?.body, error);
        }
    }


    /**
     Get investors signals trades history
     - GET /v1.0/signal/trades
     - examples: [{contentType=application/json, example={
  "total" : 1,
  "showSwaps" : true,
  "trades" : [ {
    "date" : "2000-01-23T04:56:07.000+00:00",
    "originalCommissionCurrency" : "originalCommissionCurrency",
    "symbol" : "symbol",
    "ticket" : "ticket",
    "swap" : 6.84685269835264,
    "originalCommission" : 1.0246457001441578,
    "totalCommission" : 7.061401241503109,
    "login" : "login",
    "volume" : 3.616076749251911,
    "totalCommissionByType" : [ {
      "amount" : 9.301444243932576,
      "currency" : "Undefined",
      "type" : "Undefined"
    }, {
      "amount" : 9.301444243932576,
      "currency" : "Undefined",
      "type" : "Undefined"
    } ],
    "priceCurrent" : 7.386281948385884,
    "entry" : "In",
    "price" : 4.145608029883936,
    "showOriginalCommission" : true,
    "tradingAccountId" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
    "currency" : "Undefined",
    "commission" : 1.4894159098541704,
    "id" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
    "baseVolume" : 1.2315135367772556,
    "signalData" : {
      "masters" : [ {
        "share" : 7.457744773683766,
        "login" : "login"
      }, {
        "share" : 7.457744773683766,
        "login" : "login"
      } ]
    },
    "profit" : 2.027123023002322,
    "providers" : [ {
      "volume" : 1.4658129805029452,
      "firstOrderDate" : "2000-01-23T04:56:07.000+00:00",
      "fees" : [ {
        "amount" : 2.3021358869347655,
        "currency" : "Undefined",
        "type" : "Undefined"
      }, {
        "amount" : 2.3021358869347655,
        "currency" : "Undefined",
        "type" : "Undefined"
      } ],
      "manager" : {
        "socialLinks" : [ {
          "name" : "name",
          "logo" : "logo",
          "type" : "Undefined",
          "value" : "value",
          "url" : "url"
        }, {
          "name" : "name",
          "logo" : "logo",
          "type" : "Undefined",
          "value" : "value",
          "url" : "url"
        } ],
        "registrationDate" : "2000-01-23T04:56:07.000+00:00",
        "id" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
        "avatar" : "avatar",
        "url" : "url",
        "username" : "username"
      },
      "priceOpenAvg" : 5.962133916683182,
      "program" : {
        "color" : "color",
        "level" : 0,
        "logo" : "logo",
        "title" : "title",
        "url" : "url",
        "levelProgress" : 6.027456183070403
      },
      "profit" : 5.637376656633329,
      "programId" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91"
    }, {
      "volume" : 1.4658129805029452,
      "firstOrderDate" : "2000-01-23T04:56:07.000+00:00",
      "fees" : [ {
        "amount" : 2.3021358869347655,
        "currency" : "Undefined",
        "type" : "Undefined"
      }, {
        "amount" : 2.3021358869347655,
        "currency" : "Undefined",
        "type" : "Undefined"
      } ],
      "manager" : {
        "socialLinks" : [ {
          "name" : "name",
          "logo" : "logo",
          "type" : "Undefined",
          "value" : "value",
          "url" : "url"
        }, {
          "name" : "name",
          "logo" : "logo",
          "type" : "Undefined",
          "value" : "value",
          "url" : "url"
        } ],
        "registrationDate" : "2000-01-23T04:56:07.000+00:00",
        "id" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
        "avatar" : "avatar",
        "url" : "url",
        "username" : "username"
      },
      "priceOpenAvg" : 5.962133916683182,
      "program" : {
        "color" : "color",
        "level" : 0,
        "logo" : "logo",
        "title" : "title",
        "url" : "url",
        "levelProgress" : 6.027456183070403
      },
      "profit" : 5.637376656633329,
      "programId" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91"
    } ],
    "direction" : "Buy"
  }, {
    "date" : "2000-01-23T04:56:07.000+00:00",
    "originalCommissionCurrency" : "originalCommissionCurrency",
    "symbol" : "symbol",
    "ticket" : "ticket",
    "swap" : 6.84685269835264,
    "originalCommission" : 1.0246457001441578,
    "totalCommission" : 7.061401241503109,
    "login" : "login",
    "volume" : 3.616076749251911,
    "totalCommissionByType" : [ {
      "amount" : 9.301444243932576,
      "currency" : "Undefined",
      "type" : "Undefined"
    }, {
      "amount" : 9.301444243932576,
      "currency" : "Undefined",
      "type" : "Undefined"
    } ],
    "priceCurrent" : 7.386281948385884,
    "entry" : "In",
    "price" : 4.145608029883936,
    "showOriginalCommission" : true,
    "tradingAccountId" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
    "currency" : "Undefined",
    "commission" : 1.4894159098541704,
    "id" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
    "baseVolume" : 1.2315135367772556,
    "signalData" : {
      "masters" : [ {
        "share" : 7.457744773683766,
        "login" : "login"
      }, {
        "share" : 7.457744773683766,
        "login" : "login"
      } ]
    },
    "profit" : 2.027123023002322,
    "providers" : [ {
      "volume" : 1.4658129805029452,
      "firstOrderDate" : "2000-01-23T04:56:07.000+00:00",
      "fees" : [ {
        "amount" : 2.3021358869347655,
        "currency" : "Undefined",
        "type" : "Undefined"
      }, {
        "amount" : 2.3021358869347655,
        "currency" : "Undefined",
        "type" : "Undefined"
      } ],
      "manager" : {
        "socialLinks" : [ {
          "name" : "name",
          "logo" : "logo",
          "type" : "Undefined",
          "value" : "value",
          "url" : "url"
        }, {
          "name" : "name",
          "logo" : "logo",
          "type" : "Undefined",
          "value" : "value",
          "url" : "url"
        } ],
        "registrationDate" : "2000-01-23T04:56:07.000+00:00",
        "id" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
        "avatar" : "avatar",
        "url" : "url",
        "username" : "username"
      },
      "priceOpenAvg" : 5.962133916683182,
      "program" : {
        "color" : "color",
        "level" : 0,
        "logo" : "logo",
        "title" : "title",
        "url" : "url",
        "levelProgress" : 6.027456183070403
      },
      "profit" : 5.637376656633329,
      "programId" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91"
    }, {
      "volume" : 1.4658129805029452,
      "firstOrderDate" : "2000-01-23T04:56:07.000+00:00",
      "fees" : [ {
        "amount" : 2.3021358869347655,
        "currency" : "Undefined",
        "type" : "Undefined"
      }, {
        "amount" : 2.3021358869347655,
        "currency" : "Undefined",
        "type" : "Undefined"
      } ],
      "manager" : {
        "socialLinks" : [ {
          "name" : "name",
          "logo" : "logo",
          "type" : "Undefined",
          "value" : "value",
          "url" : "url"
        }, {
          "name" : "name",
          "logo" : "logo",
          "type" : "Undefined",
          "value" : "value",
          "url" : "url"
        } ],
        "registrationDate" : "2000-01-23T04:56:07.000+00:00",
        "id" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
        "avatar" : "avatar",
        "url" : "url",
        "username" : "username"
      },
      "priceOpenAvg" : 5.962133916683182,
      "program" : {
        "color" : "color",
        "level" : 0,
        "logo" : "logo",
        "title" : "title",
        "url" : "url",
        "levelProgress" : 6.027456183070403
      },
      "profit" : 5.637376656633329,
      "programId" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91"
    } ],
    "direction" : "Buy"
  } ],
  "showTickets" : true
}}]
     
     - parameter authorization: (header) JWT access token 
     - parameter dateFrom: (query)  (optional)
     - parameter dateTo: (query)  (optional)
     - parameter symbol: (query)  (optional)
     - parameter sorting: (query)  (optional)
     - parameter accountId: (query)  (optional)
     - parameter accountCurrency: (query)  (optional)
     - parameter skip: (query)  (optional)
     - parameter take: (query)  (optional)

     - returns: RequestBuilder<TradesSignalViewModel> 
     */
    open class func v10SignalTradesGetWithRequestBuilder(authorization: String, dateFrom: Date? = nil, dateTo: Date? = nil, symbol: String? = nil, sorting: Sorting_v10SignalTradesGet? = nil, accountId: UUID? = nil, accountCurrency: AccountCurrency_v10SignalTradesGet? = nil, skip: Int? = nil, take: Int? = nil) -> RequestBuilder<TradesSignalViewModel> {
        let path = "/v1.0/signal/trades"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)
        url?.queryItems = APIHelper.mapValuesToQueryItems(values:[
            "DateFrom": dateFrom?.encodeToJSON(), 
            "DateTo": dateTo?.encodeToJSON(), 
            "Symbol": symbol, 
            "Sorting": sorting?.rawValue, 
            "AccountId": accountId, 
            "AccountCurrency": accountCurrency?.rawValue, 
            "Skip": skip?.encodeToJSON(), 
            "Take": take?.encodeToJSON()
        ])
        
        let nillableHeaders: [String: Any?] = [
            "Authorization": authorization
        ]
        let headerParameters = APIHelper.rejectNilHeaders(nillableHeaders)

        let requestBuilder: RequestBuilder<TradesSignalViewModel>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false, headers: headerParameters)
    }

    /**
     * enum for parameter accountCurrency
     */
    public enum AccountCurrency_v10SignalTradesLogGet: String { 
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
        case bnb = "BNB"
        case usd = "USD"
        case eur = "EUR"
    }

    /**
     Get investors signals trading log
     
     - parameter authorization: (header) JWT access token 
     - parameter accountId: (query)  (optional)
     - parameter accountCurrency: (query)  (optional)
     - parameter skip: (query)  (optional)
     - parameter take: (query)  (optional)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func v10SignalTradesLogGet(authorization: String, accountId: UUID? = nil, accountCurrency: AccountCurrency_v10SignalTradesLogGet? = nil, skip: Int? = nil, take: Int? = nil, completion: @escaping ((_ data: SignalTradingEvents?,_ error: Error?) -> Void)) {
        v10SignalTradesLogGetWithRequestBuilder(authorization: authorization, accountId: accountId, accountCurrency: accountCurrency, skip: skip, take: take).execute { (response, error) -> Void in
            completion(response?.body, error);
        }
    }


    /**
     Get investors signals trading log
     - GET /v1.0/signal/trades/log
     - examples: [{contentType=application/json, example={
  "total" : 0,
  "events" : [ {
    "date" : "2000-01-23T04:56:07.000+00:00",
    "message" : "message"
  }, {
    "date" : "2000-01-23T04:56:07.000+00:00",
    "message" : "message"
  } ]
}}]
     
     - parameter authorization: (header) JWT access token 
     - parameter accountId: (query)  (optional)
     - parameter accountCurrency: (query)  (optional)
     - parameter skip: (query)  (optional)
     - parameter take: (query)  (optional)

     - returns: RequestBuilder<SignalTradingEvents> 
     */
    open class func v10SignalTradesLogGetWithRequestBuilder(authorization: String, accountId: UUID? = nil, accountCurrency: AccountCurrency_v10SignalTradesLogGet? = nil, skip: Int? = nil, take: Int? = nil) -> RequestBuilder<SignalTradingEvents> {
        let path = "/v1.0/signal/trades/log"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)
        url?.queryItems = APIHelper.mapValuesToQueryItems(values:[
            "AccountId": accountId, 
            "AccountCurrency": accountCurrency?.rawValue, 
            "Skip": skip?.encodeToJSON(), 
            "Take": take?.encodeToJSON()
        ])
        
        let nillableHeaders: [String: Any?] = [
            "Authorization": authorization
        ]
        let headerParameters = APIHelper.rejectNilHeaders(nillableHeaders)

        let requestBuilder: RequestBuilder<SignalTradingEvents>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false, headers: headerParameters)
    }

    /**
     * enum for parameter sorting
     */
    public enum Sorting_v10SignalTradesOpenGet: String { 
        case byDateAsc = "ByDateAsc"
        case byDateDesc = "ByDateDesc"
        case byTicketAsc = "ByTicketAsc"
        case byTicketDesc = "ByTicketDesc"
        case bySymbolAsc = "BySymbolAsc"
        case bySymbolDesc = "BySymbolDesc"
        case byDirectionAsc = "ByDirectionAsc"
        case byDirectionDesc = "ByDirectionDesc"
        case byVolumeAsc = "ByVolumeAsc"
        case byVolumeDesc = "ByVolumeDesc"
        case byPriceAsc = "ByPriceAsc"
        case byPriceDesc = "ByPriceDesc"
        case byPriceCurrentAsc = "ByPriceCurrentAsc"
        case byPriceCurrentDesc = "ByPriceCurrentDesc"
        case byProfitAsc = "ByProfitAsc"
        case byProfitDesc = "ByProfitDesc"
        case byCommissionAsc = "ByCommissionAsc"
        case byCommissionDesc = "ByCommissionDesc"
        case bySwapAsc = "BySwapAsc"
        case bySwapDesc = "BySwapDesc"
    }

    /**
     * enum for parameter accountCurrency
     */
    public enum AccountCurrency_v10SignalTradesOpenGet: String { 
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
        case bnb = "BNB"
        case usd = "USD"
        case eur = "EUR"
    }

    /**
     Get investors signals open trades
     
     - parameter authorization: (header) JWT access token 
     - parameter sorting: (query)  (optional)
     - parameter symbol: (query)  (optional)
     - parameter accountId: (query)  (optional)
     - parameter accountCurrency: (query)  (optional)
     - parameter skip: (query)  (optional)
     - parameter take: (query)  (optional)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func v10SignalTradesOpenGet(authorization: String, sorting: Sorting_v10SignalTradesOpenGet? = nil, symbol: String? = nil, accountId: UUID? = nil, accountCurrency: AccountCurrency_v10SignalTradesOpenGet? = nil, skip: Int? = nil, take: Int? = nil, completion: @escaping ((_ data: TradesSignalViewModel?,_ error: Error?) -> Void)) {
        v10SignalTradesOpenGetWithRequestBuilder(authorization: authorization, sorting: sorting, symbol: symbol, accountId: accountId, accountCurrency: accountCurrency, skip: skip, take: take).execute { (response, error) -> Void in
            completion(response?.body, error);
        }
    }


    /**
     Get investors signals open trades
     - GET /v1.0/signal/trades/open
     - examples: [{contentType=application/json, example={
  "total" : 1,
  "showSwaps" : true,
  "trades" : [ {
    "date" : "2000-01-23T04:56:07.000+00:00",
    "originalCommissionCurrency" : "originalCommissionCurrency",
    "symbol" : "symbol",
    "ticket" : "ticket",
    "swap" : 6.84685269835264,
    "originalCommission" : 1.0246457001441578,
    "totalCommission" : 7.061401241503109,
    "login" : "login",
    "volume" : 3.616076749251911,
    "totalCommissionByType" : [ {
      "amount" : 9.301444243932576,
      "currency" : "Undefined",
      "type" : "Undefined"
    }, {
      "amount" : 9.301444243932576,
      "currency" : "Undefined",
      "type" : "Undefined"
    } ],
    "priceCurrent" : 7.386281948385884,
    "entry" : "In",
    "price" : 4.145608029883936,
    "showOriginalCommission" : true,
    "tradingAccountId" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
    "currency" : "Undefined",
    "commission" : 1.4894159098541704,
    "id" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
    "baseVolume" : 1.2315135367772556,
    "signalData" : {
      "masters" : [ {
        "share" : 7.457744773683766,
        "login" : "login"
      }, {
        "share" : 7.457744773683766,
        "login" : "login"
      } ]
    },
    "profit" : 2.027123023002322,
    "providers" : [ {
      "volume" : 1.4658129805029452,
      "firstOrderDate" : "2000-01-23T04:56:07.000+00:00",
      "fees" : [ {
        "amount" : 2.3021358869347655,
        "currency" : "Undefined",
        "type" : "Undefined"
      }, {
        "amount" : 2.3021358869347655,
        "currency" : "Undefined",
        "type" : "Undefined"
      } ],
      "manager" : {
        "socialLinks" : [ {
          "name" : "name",
          "logo" : "logo",
          "type" : "Undefined",
          "value" : "value",
          "url" : "url"
        }, {
          "name" : "name",
          "logo" : "logo",
          "type" : "Undefined",
          "value" : "value",
          "url" : "url"
        } ],
        "registrationDate" : "2000-01-23T04:56:07.000+00:00",
        "id" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
        "avatar" : "avatar",
        "url" : "url",
        "username" : "username"
      },
      "priceOpenAvg" : 5.962133916683182,
      "program" : {
        "color" : "color",
        "level" : 0,
        "logo" : "logo",
        "title" : "title",
        "url" : "url",
        "levelProgress" : 6.027456183070403
      },
      "profit" : 5.637376656633329,
      "programId" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91"
    }, {
      "volume" : 1.4658129805029452,
      "firstOrderDate" : "2000-01-23T04:56:07.000+00:00",
      "fees" : [ {
        "amount" : 2.3021358869347655,
        "currency" : "Undefined",
        "type" : "Undefined"
      }, {
        "amount" : 2.3021358869347655,
        "currency" : "Undefined",
        "type" : "Undefined"
      } ],
      "manager" : {
        "socialLinks" : [ {
          "name" : "name",
          "logo" : "logo",
          "type" : "Undefined",
          "value" : "value",
          "url" : "url"
        }, {
          "name" : "name",
          "logo" : "logo",
          "type" : "Undefined",
          "value" : "value",
          "url" : "url"
        } ],
        "registrationDate" : "2000-01-23T04:56:07.000+00:00",
        "id" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
        "avatar" : "avatar",
        "url" : "url",
        "username" : "username"
      },
      "priceOpenAvg" : 5.962133916683182,
      "program" : {
        "color" : "color",
        "level" : 0,
        "logo" : "logo",
        "title" : "title",
        "url" : "url",
        "levelProgress" : 6.027456183070403
      },
      "profit" : 5.637376656633329,
      "programId" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91"
    } ],
    "direction" : "Buy"
  }, {
    "date" : "2000-01-23T04:56:07.000+00:00",
    "originalCommissionCurrency" : "originalCommissionCurrency",
    "symbol" : "symbol",
    "ticket" : "ticket",
    "swap" : 6.84685269835264,
    "originalCommission" : 1.0246457001441578,
    "totalCommission" : 7.061401241503109,
    "login" : "login",
    "volume" : 3.616076749251911,
    "totalCommissionByType" : [ {
      "amount" : 9.301444243932576,
      "currency" : "Undefined",
      "type" : "Undefined"
    }, {
      "amount" : 9.301444243932576,
      "currency" : "Undefined",
      "type" : "Undefined"
    } ],
    "priceCurrent" : 7.386281948385884,
    "entry" : "In",
    "price" : 4.145608029883936,
    "showOriginalCommission" : true,
    "tradingAccountId" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
    "currency" : "Undefined",
    "commission" : 1.4894159098541704,
    "id" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
    "baseVolume" : 1.2315135367772556,
    "signalData" : {
      "masters" : [ {
        "share" : 7.457744773683766,
        "login" : "login"
      }, {
        "share" : 7.457744773683766,
        "login" : "login"
      } ]
    },
    "profit" : 2.027123023002322,
    "providers" : [ {
      "volume" : 1.4658129805029452,
      "firstOrderDate" : "2000-01-23T04:56:07.000+00:00",
      "fees" : [ {
        "amount" : 2.3021358869347655,
        "currency" : "Undefined",
        "type" : "Undefined"
      }, {
        "amount" : 2.3021358869347655,
        "currency" : "Undefined",
        "type" : "Undefined"
      } ],
      "manager" : {
        "socialLinks" : [ {
          "name" : "name",
          "logo" : "logo",
          "type" : "Undefined",
          "value" : "value",
          "url" : "url"
        }, {
          "name" : "name",
          "logo" : "logo",
          "type" : "Undefined",
          "value" : "value",
          "url" : "url"
        } ],
        "registrationDate" : "2000-01-23T04:56:07.000+00:00",
        "id" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
        "avatar" : "avatar",
        "url" : "url",
        "username" : "username"
      },
      "priceOpenAvg" : 5.962133916683182,
      "program" : {
        "color" : "color",
        "level" : 0,
        "logo" : "logo",
        "title" : "title",
        "url" : "url",
        "levelProgress" : 6.027456183070403
      },
      "profit" : 5.637376656633329,
      "programId" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91"
    }, {
      "volume" : 1.4658129805029452,
      "firstOrderDate" : "2000-01-23T04:56:07.000+00:00",
      "fees" : [ {
        "amount" : 2.3021358869347655,
        "currency" : "Undefined",
        "type" : "Undefined"
      }, {
        "amount" : 2.3021358869347655,
        "currency" : "Undefined",
        "type" : "Undefined"
      } ],
      "manager" : {
        "socialLinks" : [ {
          "name" : "name",
          "logo" : "logo",
          "type" : "Undefined",
          "value" : "value",
          "url" : "url"
        }, {
          "name" : "name",
          "logo" : "logo",
          "type" : "Undefined",
          "value" : "value",
          "url" : "url"
        } ],
        "registrationDate" : "2000-01-23T04:56:07.000+00:00",
        "id" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
        "avatar" : "avatar",
        "url" : "url",
        "username" : "username"
      },
      "priceOpenAvg" : 5.962133916683182,
      "program" : {
        "color" : "color",
        "level" : 0,
        "logo" : "logo",
        "title" : "title",
        "url" : "url",
        "levelProgress" : 6.027456183070403
      },
      "profit" : 5.637376656633329,
      "programId" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91"
    } ],
    "direction" : "Buy"
  } ],
  "showTickets" : true
}}]
     
     - parameter authorization: (header) JWT access token 
     - parameter sorting: (query)  (optional)
     - parameter symbol: (query)  (optional)
     - parameter accountId: (query)  (optional)
     - parameter accountCurrency: (query)  (optional)
     - parameter skip: (query)  (optional)
     - parameter take: (query)  (optional)

     - returns: RequestBuilder<TradesSignalViewModel> 
     */
    open class func v10SignalTradesOpenGetWithRequestBuilder(authorization: String, sorting: Sorting_v10SignalTradesOpenGet? = nil, symbol: String? = nil, accountId: UUID? = nil, accountCurrency: AccountCurrency_v10SignalTradesOpenGet? = nil, skip: Int? = nil, take: Int? = nil) -> RequestBuilder<TradesSignalViewModel> {
        let path = "/v1.0/signal/trades/open"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)
        url?.queryItems = APIHelper.mapValuesToQueryItems(values:[
            "Sorting": sorting?.rawValue, 
            "Symbol": symbol, 
            "AccountId": accountId, 
            "AccountCurrency": accountCurrency?.rawValue, 
            "Skip": skip?.encodeToJSON(), 
            "Take": take?.encodeToJSON()
        ])
        
        let nillableHeaders: [String: Any?] = [
            "Authorization": authorization
        ]
        let headerParameters = APIHelper.rejectNilHeaders(nillableHeaders)

        let requestBuilder: RequestBuilder<TradesSignalViewModel>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false, headers: headerParameters)
    }

}
