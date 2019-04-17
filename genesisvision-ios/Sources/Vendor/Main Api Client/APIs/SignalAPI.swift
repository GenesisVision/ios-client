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
  "accounts" : [ {
    "freeMargin" : 1.4658129805029452,
    "balance" : 0.8008281904610115,
    "currency" : "Undefined",
    "currencyLogo" : "currencyLogo",
    "equity" : 6.027456183070403,
    "marginLevel" : 5.962133916683182
  }, {
    "freeMargin" : 1.4658129805029452,
    "balance" : 0.8008281904610115,
    "currency" : "Undefined",
    "currencyLogo" : "currencyLogo",
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
  "subscriptionFee" : 0.8008281904610115,
  "subscriptionFeeCurrency" : "Undefined",
  "minDeposit" : 6.027456183070403
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
     * enum for parameter mode
     */
    public enum Mode_v10SignalAttachByIdPost: String { 
        case byBalance = "ByBalance"
        case percent = "Percent"
        case fixed = "Fixed"
    }

    /**
     * enum for parameter fixedCurrency
     */
    public enum FixedCurrency_v10SignalAttachByIdPost: String { 
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
     * enum for parameter initialDepositCurrency
     */
    public enum InitialDepositCurrency_v10SignalAttachByIdPost: String { 
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
     Subscribe to programs signals
     
     - parameter id: (path) Program Id 
     - parameter authorization: (header) JWT access token 
     - parameter mode: (query)  (optional)
     - parameter percent: (query)  (optional)
     - parameter openTolerancePercent: (query)  (optional)
     - parameter fixedVolume: (query)  (optional)
     - parameter fixedCurrency: (query)  (optional)
     - parameter initialDepositCurrency: (query)  (optional)
     - parameter initialDepositAmount: (query)  (optional)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func v10SignalAttachByIdPost(id: UUID, authorization: String, mode: Mode_v10SignalAttachByIdPost? = nil, percent: Double? = nil, openTolerancePercent: Double? = nil, fixedVolume: Double? = nil, fixedCurrency: FixedCurrency_v10SignalAttachByIdPost? = nil, initialDepositCurrency: InitialDepositCurrency_v10SignalAttachByIdPost? = nil, initialDepositAmount: Double? = nil, completion: @escaping ((_ error: Error?) -> Void)) {
        v10SignalAttachByIdPostWithRequestBuilder(id: id, authorization: authorization, mode: mode, percent: percent, openTolerancePercent: openTolerancePercent, fixedVolume: fixedVolume, fixedCurrency: fixedCurrency, initialDepositCurrency: initialDepositCurrency, initialDepositAmount: initialDepositAmount).execute { (response, error) -> Void in
            completion(error);
        }
    }


    /**
     Subscribe to programs signals
     - POST /v1.0/signal/attach/{id}
     
     - parameter id: (path) Program Id 
     - parameter authorization: (header) JWT access token 
     - parameter mode: (query)  (optional)
     - parameter percent: (query)  (optional)
     - parameter openTolerancePercent: (query)  (optional)
     - parameter fixedVolume: (query)  (optional)
     - parameter fixedCurrency: (query)  (optional)
     - parameter initialDepositCurrency: (query)  (optional)
     - parameter initialDepositAmount: (query)  (optional)

     - returns: RequestBuilder<Void> 
     */
    open class func v10SignalAttachByIdPostWithRequestBuilder(id: UUID, authorization: String, mode: Mode_v10SignalAttachByIdPost? = nil, percent: Double? = nil, openTolerancePercent: Double? = nil, fixedVolume: Double? = nil, fixedCurrency: FixedCurrency_v10SignalAttachByIdPost? = nil, initialDepositCurrency: InitialDepositCurrency_v10SignalAttachByIdPost? = nil, initialDepositAmount: Double? = nil) -> RequestBuilder<Void> {
        var path = "/v1.0/signal/attach/{id}"
        path = path.replacingOccurrences(of: "{id}", with: "\(id)", options: .literal, range: nil)
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)
        url?.queryItems = APIHelper.mapValuesToQueryItems(values:[
            "Mode": mode?.rawValue, 
            "Percent": percent, 
            "OpenTolerancePercent": openTolerancePercent, 
            "FixedVolume": fixedVolume, 
            "FixedCurrency": fixedCurrency?.rawValue, 
            "InitialDepositCurrency": initialDepositCurrency?.rawValue, 
            "InitialDepositAmount": initialDepositAmount
        ])
        
        let nillableHeaders: [String: Any?] = [
            "Authorization": authorization
        ]
        let headerParameters = APIHelper.rejectNilHeaders(nillableHeaders)

        let requestBuilder: RequestBuilder<Void>.Type = SwaggerClientAPI.requestBuilderFactory.getNonDecodableBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false, headers: headerParameters)
    }

    /**
     * enum for parameter mode
     */
    public enum Mode_v10SignalByIdUpdatePost: String { 
        case byBalance = "ByBalance"
        case percent = "Percent"
        case fixed = "Fixed"
    }

    /**
     * enum for parameter fixedCurrency
     */
    public enum FixedCurrency_v10SignalByIdUpdatePost: String { 
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
     * enum for parameter initialDepositCurrency
     */
    public enum InitialDepositCurrency_v10SignalByIdUpdatePost: String { 
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
     Update signal subscription settings
     
     - parameter id: (path) Program id 
     - parameter authorization: (header) JWT access token 
     - parameter mode: (query)  (optional)
     - parameter percent: (query)  (optional)
     - parameter openTolerancePercent: (query)  (optional)
     - parameter fixedVolume: (query)  (optional)
     - parameter fixedCurrency: (query)  (optional)
     - parameter initialDepositCurrency: (query)  (optional)
     - parameter initialDepositAmount: (query)  (optional)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func v10SignalByIdUpdatePost(id: UUID, authorization: String, mode: Mode_v10SignalByIdUpdatePost? = nil, percent: Double? = nil, openTolerancePercent: Double? = nil, fixedVolume: Double? = nil, fixedCurrency: FixedCurrency_v10SignalByIdUpdatePost? = nil, initialDepositCurrency: InitialDepositCurrency_v10SignalByIdUpdatePost? = nil, initialDepositAmount: Double? = nil, completion: @escaping ((_ error: Error?) -> Void)) {
        v10SignalByIdUpdatePostWithRequestBuilder(id: id, authorization: authorization, mode: mode, percent: percent, openTolerancePercent: openTolerancePercent, fixedVolume: fixedVolume, fixedCurrency: fixedCurrency, initialDepositCurrency: initialDepositCurrency, initialDepositAmount: initialDepositAmount).execute { (response, error) -> Void in
            completion(error);
        }
    }


    /**
     Update signal subscription settings
     - POST /v1.0/signal/{id}/update
     
     - parameter id: (path) Program id 
     - parameter authorization: (header) JWT access token 
     - parameter mode: (query)  (optional)
     - parameter percent: (query)  (optional)
     - parameter openTolerancePercent: (query)  (optional)
     - parameter fixedVolume: (query)  (optional)
     - parameter fixedCurrency: (query)  (optional)
     - parameter initialDepositCurrency: (query)  (optional)
     - parameter initialDepositAmount: (query)  (optional)

     - returns: RequestBuilder<Void> 
     */
    open class func v10SignalByIdUpdatePostWithRequestBuilder(id: UUID, authorization: String, mode: Mode_v10SignalByIdUpdatePost? = nil, percent: Double? = nil, openTolerancePercent: Double? = nil, fixedVolume: Double? = nil, fixedCurrency: FixedCurrency_v10SignalByIdUpdatePost? = nil, initialDepositCurrency: InitialDepositCurrency_v10SignalByIdUpdatePost? = nil, initialDepositAmount: Double? = nil) -> RequestBuilder<Void> {
        var path = "/v1.0/signal/{id}/update"
        path = path.replacingOccurrences(of: "{id}", with: "\(id)", options: .literal, range: nil)
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)
        url?.queryItems = APIHelper.mapValuesToQueryItems(values:[
            "Mode": mode?.rawValue, 
            "Percent": percent, 
            "OpenTolerancePercent": openTolerancePercent, 
            "FixedVolume": fixedVolume, 
            "FixedCurrency": fixedCurrency?.rawValue, 
            "InitialDepositCurrency": initialDepositCurrency?.rawValue, 
            "InitialDepositAmount": initialDepositAmount
        ])
        
        let nillableHeaders: [String: Any?] = [
            "Authorization": authorization
        ]
        let headerParameters = APIHelper.rejectNilHeaders(nillableHeaders)

        let requestBuilder: RequestBuilder<Void>.Type = SwaggerClientAPI.requestBuilderFactory.getNonDecodableBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false, headers: headerParameters)
    }

    /**
     Unsubscribe from program signals
     
     - parameter id: (path) Program id 
     - parameter authorization: (header) JWT access token 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func v10SignalDetachByIdPost(id: UUID, authorization: String, completion: @escaping ((_ error: Error?) -> Void)) {
        v10SignalDetachByIdPostWithRequestBuilder(id: id, authorization: authorization).execute { (response, error) -> Void in
            completion(error);
        }
    }


    /**
     Unsubscribe from program signals
     - POST /v1.0/signal/detach/{id}
     
     - parameter id: (path) Program id 
     - parameter authorization: (header) JWT access token 

     - returns: RequestBuilder<Void> 
     */
    open class func v10SignalDetachByIdPostWithRequestBuilder(id: UUID, authorization: String) -> RequestBuilder<Void> {
        var path = "/v1.0/signal/detach/{id}"
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
     Close signal trade
     
     - parameter id: (path) Trade id 
     - parameter authorization: (header) JWT access token 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func v10SignalTradesByIdClosePost(id: UUID, authorization: String, completion: @escaping ((_ error: Error?) -> Void)) {
        v10SignalTradesByIdClosePostWithRequestBuilder(id: id, authorization: authorization).execute { (response, error) -> Void in
            completion(error);
        }
    }


    /**
     Close signal trade
     - POST /v1.0/signal/trades/{id}/close
     
     - parameter id: (path) Trade id 
     - parameter authorization: (header) JWT access token 

     - returns: RequestBuilder<Void> 
     */
    open class func v10SignalTradesByIdClosePostWithRequestBuilder(id: UUID, authorization: String) -> RequestBuilder<Void> {
        var path = "/v1.0/signal/trades/{id}/close"
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
    }

    /**
     Get investors signals trades history
     
     - parameter authorization: (header) JWT access token 
     - parameter dateFrom: (query)  (optional)
     - parameter dateTo: (query)  (optional)
     - parameter symbol: (query)  (optional)
     - parameter sorting: (query)  (optional)
     - parameter skip: (query)  (optional)
     - parameter take: (query)  (optional)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func v10SignalTradesGet(authorization: String, dateFrom: Date? = nil, dateTo: Date? = nil, symbol: String? = nil, sorting: Sorting_v10SignalTradesGet? = nil, skip: Int? = nil, take: Int? = nil, completion: @escaping ((_ data: TradesSignalViewModel?,_ error: Error?) -> Void)) {
        v10SignalTradesGetWithRequestBuilder(authorization: authorization, dateFrom: dateFrom, dateTo: dateTo, symbol: symbol, sorting: sorting, skip: skip, take: take).execute { (response, error) -> Void in
            completion(response?.body, error);
        }
    }


    /**
     Get investors signals trades history
     - GET /v1.0/signal/trades
     - examples: [{contentType=application/json, example={
  "total" : 3,
  "trades" : [ {
    "date" : "2000-01-23T04:56:07.000+00:00",
    "symbol" : "symbol",
    "ticket" : "ticket",
    "login" : "login",
    "volume" : 1.4658129805029452,
    "priceCurrent" : 2.3021358869347655,
    "entry" : "In",
    "price" : 5.637376656633329,
    "commission" : 9.301444243932576,
    "id" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
    "baseVolume" : 7.061401241503109,
    "masterLogin" : "masterLogin",
    "profit" : 5.962133916683182,
    "providers" : [ {
      "volume" : 6.027456183070403,
      "manager" : {
        "registrationDate" : "2000-01-23T04:56:07.000+00:00",
        "id" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
        "avatar" : "avatar",
        "url" : "url",
        "username" : "username"
      },
      "program" : {
        "color" : "color",
        "level" : 0,
        "logo" : "logo",
        "title" : "title",
        "url" : "url"
      },
      "programId" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91"
    }, {
      "volume" : 6.027456183070403,
      "manager" : {
        "registrationDate" : "2000-01-23T04:56:07.000+00:00",
        "id" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
        "avatar" : "avatar",
        "url" : "url",
        "username" : "username"
      },
      "program" : {
        "color" : "color",
        "level" : 0,
        "logo" : "logo",
        "title" : "title",
        "url" : "url"
      },
      "programId" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91"
    } ],
    "direction" : "Buy"
  }, {
    "date" : "2000-01-23T04:56:07.000+00:00",
    "symbol" : "symbol",
    "ticket" : "ticket",
    "login" : "login",
    "volume" : 1.4658129805029452,
    "priceCurrent" : 2.3021358869347655,
    "entry" : "In",
    "price" : 5.637376656633329,
    "commission" : 9.301444243932576,
    "id" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
    "baseVolume" : 7.061401241503109,
    "masterLogin" : "masterLogin",
    "profit" : 5.962133916683182,
    "providers" : [ {
      "volume" : 6.027456183070403,
      "manager" : {
        "registrationDate" : "2000-01-23T04:56:07.000+00:00",
        "id" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
        "avatar" : "avatar",
        "url" : "url",
        "username" : "username"
      },
      "program" : {
        "color" : "color",
        "level" : 0,
        "logo" : "logo",
        "title" : "title",
        "url" : "url"
      },
      "programId" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91"
    }, {
      "volume" : 6.027456183070403,
      "manager" : {
        "registrationDate" : "2000-01-23T04:56:07.000+00:00",
        "id" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
        "avatar" : "avatar",
        "url" : "url",
        "username" : "username"
      },
      "program" : {
        "color" : "color",
        "level" : 0,
        "logo" : "logo",
        "title" : "title",
        "url" : "url"
      },
      "programId" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91"
    } ],
    "direction" : "Buy"
  } ],
  "tradesType" : "Positions"
}}]
     
     - parameter authorization: (header) JWT access token 
     - parameter dateFrom: (query)  (optional)
     - parameter dateTo: (query)  (optional)
     - parameter symbol: (query)  (optional)
     - parameter sorting: (query)  (optional)
     - parameter skip: (query)  (optional)
     - parameter take: (query)  (optional)

     - returns: RequestBuilder<TradesSignalViewModel> 
     */
    open class func v10SignalTradesGetWithRequestBuilder(authorization: String, dateFrom: Date? = nil, dateTo: Date? = nil, symbol: String? = nil, sorting: Sorting_v10SignalTradesGet? = nil, skip: Int? = nil, take: Int? = nil) -> RequestBuilder<TradesSignalViewModel> {
        let path = "/v1.0/signal/trades"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)
        url?.queryItems = APIHelper.mapValuesToQueryItems(values:[
            "DateFrom": dateFrom?.encodeToJSON(), 
            "DateTo": dateTo?.encodeToJSON(), 
            "Symbol": symbol, 
            "Sorting": sorting?.rawValue, 
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
    }

    /**
     Get investors signals open trades
     
     - parameter authorization: (header) JWT access token 
     - parameter sorting: (query)  (optional)
     - parameter symbol: (query)  (optional)
     - parameter skip: (query)  (optional)
     - parameter take: (query)  (optional)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func v10SignalTradesOpenGet(authorization: String, sorting: Sorting_v10SignalTradesOpenGet? = nil, symbol: String? = nil, skip: Int? = nil, take: Int? = nil, completion: @escaping ((_ data: TradesSignalViewModel?,_ error: Error?) -> Void)) {
        v10SignalTradesOpenGetWithRequestBuilder(authorization: authorization, sorting: sorting, symbol: symbol, skip: skip, take: take).execute { (response, error) -> Void in
            completion(response?.body, error);
        }
    }


    /**
     Get investors signals open trades
     - GET /v1.0/signal/trades/open
     - examples: [{contentType=application/json, example={
  "total" : 3,
  "trades" : [ {
    "date" : "2000-01-23T04:56:07.000+00:00",
    "symbol" : "symbol",
    "ticket" : "ticket",
    "login" : "login",
    "volume" : 1.4658129805029452,
    "priceCurrent" : 2.3021358869347655,
    "entry" : "In",
    "price" : 5.637376656633329,
    "commission" : 9.301444243932576,
    "id" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
    "baseVolume" : 7.061401241503109,
    "masterLogin" : "masterLogin",
    "profit" : 5.962133916683182,
    "providers" : [ {
      "volume" : 6.027456183070403,
      "manager" : {
        "registrationDate" : "2000-01-23T04:56:07.000+00:00",
        "id" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
        "avatar" : "avatar",
        "url" : "url",
        "username" : "username"
      },
      "program" : {
        "color" : "color",
        "level" : 0,
        "logo" : "logo",
        "title" : "title",
        "url" : "url"
      },
      "programId" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91"
    }, {
      "volume" : 6.027456183070403,
      "manager" : {
        "registrationDate" : "2000-01-23T04:56:07.000+00:00",
        "id" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
        "avatar" : "avatar",
        "url" : "url",
        "username" : "username"
      },
      "program" : {
        "color" : "color",
        "level" : 0,
        "logo" : "logo",
        "title" : "title",
        "url" : "url"
      },
      "programId" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91"
    } ],
    "direction" : "Buy"
  }, {
    "date" : "2000-01-23T04:56:07.000+00:00",
    "symbol" : "symbol",
    "ticket" : "ticket",
    "login" : "login",
    "volume" : 1.4658129805029452,
    "priceCurrent" : 2.3021358869347655,
    "entry" : "In",
    "price" : 5.637376656633329,
    "commission" : 9.301444243932576,
    "id" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
    "baseVolume" : 7.061401241503109,
    "masterLogin" : "masterLogin",
    "profit" : 5.962133916683182,
    "providers" : [ {
      "volume" : 6.027456183070403,
      "manager" : {
        "registrationDate" : "2000-01-23T04:56:07.000+00:00",
        "id" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
        "avatar" : "avatar",
        "url" : "url",
        "username" : "username"
      },
      "program" : {
        "color" : "color",
        "level" : 0,
        "logo" : "logo",
        "title" : "title",
        "url" : "url"
      },
      "programId" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91"
    }, {
      "volume" : 6.027456183070403,
      "manager" : {
        "registrationDate" : "2000-01-23T04:56:07.000+00:00",
        "id" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
        "avatar" : "avatar",
        "url" : "url",
        "username" : "username"
      },
      "program" : {
        "color" : "color",
        "level" : 0,
        "logo" : "logo",
        "title" : "title",
        "url" : "url"
      },
      "programId" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91"
    } ],
    "direction" : "Buy"
  } ],
  "tradesType" : "Positions"
}}]
     
     - parameter authorization: (header) JWT access token 
     - parameter sorting: (query)  (optional)
     - parameter symbol: (query)  (optional)
     - parameter skip: (query)  (optional)
     - parameter take: (query)  (optional)

     - returns: RequestBuilder<TradesSignalViewModel> 
     */
    open class func v10SignalTradesOpenGetWithRequestBuilder(authorization: String, sorting: Sorting_v10SignalTradesOpenGet? = nil, symbol: String? = nil, skip: Int? = nil, take: Int? = nil) -> RequestBuilder<TradesSignalViewModel> {
        let path = "/v1.0/signal/trades/open"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)
        url?.queryItems = APIHelper.mapValuesToQueryItems(values:[
            "Sorting": sorting?.rawValue, 
            "Symbol": symbol, 
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