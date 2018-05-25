//
// BrokerAPI.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation
import Alamofire



open class BrokerAPI {
    /**
     Create manager
     
     - parameter authorization: (header) JWT access token 
     - parameter request: (body)  (optional)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func apiBrokerAccountCreatePost(authorization: String, request: NewManager? = nil, completion: @escaping ((_ data: UUID?,_ error: Error?) -> Void)) {
        apiBrokerAccountCreatePostWithRequestBuilder(authorization: authorization, request: request).execute { (response, error) -> Void in
            completion(response?.body, error);
        }
    }


    /**
     Create manager
     - POST /api/broker/account/create
     - examples: [{contentType=application/json, example="046b6c7f-0b8a-43b9-b35d-6489e6daee91"}]
     
     - parameter authorization: (header) JWT access token 
     - parameter request: (body)  (optional)

     - returns: RequestBuilder<UUID> 
     */
    open class func apiBrokerAccountCreatePostWithRequestBuilder(authorization: String, request: NewManager? = nil) -> RequestBuilder<UUID> {
        let path = "/api/broker/account/create"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters = JSONEncodingHelper.encodingParameters(forEncodableObject: request)

        let url = NSURLComponents(string: URLString)

        let nillableHeaders: [String: Any?] = [
            "Authorization": authorization
        ]
        let headerParameters = APIHelper.rejectNilHeaders(nillableHeaders)

        let requestBuilder: RequestBuilder<UUID>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true, headers: headerParameters)
    }

    /**
     Change password
     
     - parameter authorization: (header) JWT access token 
     - parameter model: (body)  (optional)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func apiBrokerAuthChangePasswordPost(authorization: String, model: ChangePasswordViewModel? = nil, completion: @escaping ((_ error: Error?) -> Void)) {
        apiBrokerAuthChangePasswordPostWithRequestBuilder(authorization: authorization, model: model).execute { (response, error) -> Void in
            completion(error);
        }
    }


    /**
     Change password
     - POST /api/broker/auth/changePassword
     
     - parameter authorization: (header) JWT access token 
     - parameter model: (body)  (optional)

     - returns: RequestBuilder<Void> 
     */
    open class func apiBrokerAuthChangePasswordPostWithRequestBuilder(authorization: String, model: ChangePasswordViewModel? = nil) -> RequestBuilder<Void> {
        let path = "/api/broker/auth/changePassword"
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
     Confirm email after registration
     
     - parameter userId: (query)  (optional)
     - parameter code: (query)  (optional)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func apiBrokerAuthConfirmEmailPost(userId: String? = nil, code: String? = nil, completion: @escaping ((_ data: String?,_ error: Error?) -> Void)) {
        apiBrokerAuthConfirmEmailPostWithRequestBuilder(userId: userId, code: code).execute { (response, error) -> Void in
            completion(response?.body, error);
        }
    }


    /**
     Confirm email after registration
     - POST /api/broker/auth/confirmEmail
     - examples: [{contentType=application/json, example=""}]
     
     - parameter userId: (query)  (optional)
     - parameter code: (query)  (optional)

     - returns: RequestBuilder<String> 
     */
    open class func apiBrokerAuthConfirmEmailPostWithRequestBuilder(userId: String? = nil, code: String? = nil) -> RequestBuilder<String> {
        let path = "/api/broker/auth/confirmEmail"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)
        url?.queryItems = APIHelper.mapValuesToQueryItems(values:[
            "userId": userId, 
            "code": code
        ])
        

        let requestBuilder: RequestBuilder<String>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**
     Authorize
     
     - parameter model: (body)  (optional)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func apiBrokerAuthSignInPost(model: LoginViewModel? = nil, completion: @escaping ((_ data: String?,_ error: Error?) -> Void)) {
        apiBrokerAuthSignInPostWithRequestBuilder(model: model).execute { (response, error) -> Void in
            completion(response?.body, error);
        }
    }


    /**
     Authorize
     - POST /api/broker/auth/signIn
     - examples: [{contentType=application/json, example=""}]
     
     - parameter model: (body)  (optional)

     - returns: RequestBuilder<String> 
     */
    open class func apiBrokerAuthSignInPostWithRequestBuilder(model: LoginViewModel? = nil) -> RequestBuilder<String> {
        let path = "/api/broker/auth/signIn"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters = JSONEncodingHelper.encodingParameters(forEncodableObject: model)

        let url = NSURLComponents(string: URLString)


        let requestBuilder: RequestBuilder<String>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }

    /**
     Update auth token
     
     - parameter authorization: (header) JWT access token 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func apiBrokerAuthUpdateTokenGet(authorization: String, completion: @escaping ((_ data: String?,_ error: Error?) -> Void)) {
        apiBrokerAuthUpdateTokenGetWithRequestBuilder(authorization: authorization).execute { (response, error) -> Void in
            completion(response?.body, error);
        }
    }


    /**
     Update auth token
     - GET /api/broker/auth/updateToken
     - examples: [{contentType=application/json, example=""}]
     
     - parameter authorization: (header) JWT access token 

     - returns: RequestBuilder<String> 
     */
    open class func apiBrokerAuthUpdateTokenGetWithRequestBuilder(authorization: String) -> RequestBuilder<String> {
        let path = "/api/broker/auth/updateToken"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)

        let nillableHeaders: [String: Any?] = [
            "Authorization": authorization
        ]
        let headerParameters = APIHelper.rejectNilHeaders(nillableHeaders)

        let requestBuilder: RequestBuilder<String>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false, headers: headerParameters)
    }

    /**
     Get broker initial data
     
     - parameter brokerTradeServerId: (query)  
     - parameter authorization: (header) JWT access token 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func apiBrokerInitDataGet(brokerTradeServerId: UUID, authorization: String, completion: @escaping ((_ data: BrokerInitData?,_ error: Error?) -> Void)) {
        apiBrokerInitDataGetWithRequestBuilder(brokerTradeServerId: brokerTradeServerId, authorization: authorization).execute { (response, error) -> Void in
            completion(response?.body, error);
        }
    }


    /**
     Get broker initial data
     - GET /api/broker/initData
     - examples: [{contentType=application/json, example={
  "hoursOffset" : 1,
  "newManagerRequest" : [ {
    "depositAmount" : 0.8008281904610115,
    "leverage" : 6,
    "password" : "password",
    "programDateFrom" : "2000-01-23T04:56:07.000+00:00",
    "requestId" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
    "name" : "name",
    "currency" : "Undefined",
    "userId" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
    "email" : "email"
  }, {
    "depositAmount" : 0.8008281904610115,
    "leverage" : 6,
    "password" : "password",
    "programDateFrom" : "2000-01-23T04:56:07.000+00:00",
    "requestId" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
    "name" : "name",
    "currency" : "Undefined",
    "userId" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
    "email" : "email"
  } ],
  "investments" : [ {
    "feeEntrance" : 2.3021358869347655,
    "tradeIpfsHash" : "tradeIpfsHash",
    "period" : 1,
    "feeManagement" : 5.637376656633329,
    "description" : "description",
    "dateFrom" : "2000-01-23T04:56:07.000+00:00",
    "login" : "login",
    "investMinAmount" : 7.061401241503109,
    "balance" : 1.0246457001441578,
    "isEnabled" : true,
    "dateTo" : "2000-01-23T04:56:07.000+00:00",
    "ipfsHash" : "ipfsHash",
    "feeSuccess" : 5.962133916683182,
    "id" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
    "investMaxAmount" : 9.301444243932576,
    "lastPeriod" : {
      "number" : 3,
      "managerStartBalance" : 4.145608029883936,
      "managerStartShare" : 7.386281948385884,
      "processStatus" : "None",
      "investmentRequest" : [ {
        "date" : "2000-01-23T04:56:07.000+00:00",
        "canCancelRequest" : true,
        "amount" : 1.2315135367772556,
        "id" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
        "type" : "Invest",
        "status" : "New"
      }, {
        "date" : "2000-01-23T04:56:07.000+00:00",
        "canCancelRequest" : true,
        "amount" : 1.2315135367772556,
        "id" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
        "type" : "Invest",
        "status" : "New"
      } ],
      "dateTo" : "2000-01-23T04:56:07.000+00:00",
      "id" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
      "dateFrom" : "2000-01-23T04:56:07.000+00:00",
      "startBalance" : 2.027123023002322,
      "status" : "Planned"
    },
    "managerAccountId" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
    "isTournamentAccount" : true,
    "status" : "None"
  }, {
    "feeEntrance" : 2.3021358869347655,
    "tradeIpfsHash" : "tradeIpfsHash",
    "period" : 1,
    "feeManagement" : 5.637376656633329,
    "description" : "description",
    "dateFrom" : "2000-01-23T04:56:07.000+00:00",
    "login" : "login",
    "investMinAmount" : 7.061401241503109,
    "balance" : 1.0246457001441578,
    "isEnabled" : true,
    "dateTo" : "2000-01-23T04:56:07.000+00:00",
    "ipfsHash" : "ipfsHash",
    "feeSuccess" : 5.962133916683182,
    "id" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
    "investMaxAmount" : 9.301444243932576,
    "lastPeriod" : {
      "number" : 3,
      "managerStartBalance" : 4.145608029883936,
      "managerStartShare" : 7.386281948385884,
      "processStatus" : "None",
      "investmentRequest" : [ {
        "date" : "2000-01-23T04:56:07.000+00:00",
        "canCancelRequest" : true,
        "amount" : 1.2315135367772556,
        "id" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
        "type" : "Invest",
        "status" : "New"
      }, {
        "date" : "2000-01-23T04:56:07.000+00:00",
        "canCancelRequest" : true,
        "amount" : 1.2315135367772556,
        "id" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
        "type" : "Invest",
        "status" : "New"
      } ],
      "dateTo" : "2000-01-23T04:56:07.000+00:00",
      "id" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
      "dateFrom" : "2000-01-23T04:56:07.000+00:00",
      "startBalance" : 2.027123023002322,
      "status" : "Planned"
    },
    "managerAccountId" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
    "isTournamentAccount" : true,
    "status" : "None"
  } ]
}}]
     
     - parameter brokerTradeServerId: (query)  
     - parameter authorization: (header) JWT access token 

     - returns: RequestBuilder<BrokerInitData> 
     */
    open class func apiBrokerInitDataGetWithRequestBuilder(brokerTradeServerId: UUID, authorization: String) -> RequestBuilder<BrokerInitData> {
        let path = "/api/broker/initData"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)
        url?.queryItems = APIHelper.mapValuesToQueryItems(values:[
            "brokerTradeServerId": brokerTradeServerId
        ])
        
        let nillableHeaders: [String: Any?] = [
            "Authorization": authorization
        ]
        let headerParameters = APIHelper.rejectNilHeaders(nillableHeaders)

        let requestBuilder: RequestBuilder<BrokerInitData>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false, headers: headerParameters)
    }

    /**
     Upload accounts online info
     
     - parameter authorization: (header) JWT access token 
     - parameter accounts: (body)  (optional)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func apiBrokerManagersAccountsOnlineInfoUpdatePost(authorization: String, accounts: [ManagerAccountOnlineInfo]? = nil, completion: @escaping ((_ error: Error?) -> Void)) {
        apiBrokerManagersAccountsOnlineInfoUpdatePostWithRequestBuilder(authorization: authorization, accounts: accounts).execute { (response, error) -> Void in
            completion(error);
        }
    }


    /**
     Upload accounts online info
     - POST /api/broker/managersAccounts/onlineInfo/update
     
     - parameter authorization: (header) JWT access token 
     - parameter accounts: (body)  (optional)

     - returns: RequestBuilder<Void> 
     */
    open class func apiBrokerManagersAccountsOnlineInfoUpdatePostWithRequestBuilder(authorization: String, accounts: [ManagerAccountOnlineInfo]? = nil) -> RequestBuilder<Void> {
        let path = "/api/broker/managersAccounts/onlineInfo/update"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters = JSONEncodingHelper.encodingParameters(forEncodableObject: accounts)

        let url = NSURLComponents(string: URLString)

        let nillableHeaders: [String: Any?] = [
            "Authorization": authorization
        ]
        let headerParameters = APIHelper.rejectNilHeaders(nillableHeaders)

        let requestBuilder: RequestBuilder<Void>.Type = SwaggerClientAPI.requestBuilderFactory.getNonDecodableBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true, headers: headerParameters)
    }

    /**
     Accrue investors' profits
     
     - parameter authorization: (header) JWT access token 
     - parameter accrual: (body)  (optional)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func apiBrokerPeriodAccrueProfitsPost(authorization: String, accrual: InvestmentProgramAccrual? = nil, completion: @escaping ((_ error: Error?) -> Void)) {
        apiBrokerPeriodAccrueProfitsPostWithRequestBuilder(authorization: authorization, accrual: accrual).execute { (response, error) -> Void in
            completion(error);
        }
    }


    /**
     Accrue investors' profits
     - POST /api/broker/period/accrueProfits
     
     - parameter authorization: (header) JWT access token 
     - parameter accrual: (body)  (optional)

     - returns: RequestBuilder<Void> 
     */
    open class func apiBrokerPeriodAccrueProfitsPostWithRequestBuilder(authorization: String, accrual: InvestmentProgramAccrual? = nil) -> RequestBuilder<Void> {
        let path = "/api/broker/period/accrueProfits"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters = JSONEncodingHelper.encodingParameters(forEncodableObject: accrual)

        let url = NSURLComponents(string: URLString)

        let nillableHeaders: [String: Any?] = [
            "Authorization": authorization
        ]
        let headerParameters = APIHelper.rejectNilHeaders(nillableHeaders)

        let requestBuilder: RequestBuilder<Void>.Type = SwaggerClientAPI.requestBuilderFactory.getNonDecodableBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true, headers: headerParameters)
    }

    /**
     Close investment period
     
     - parameter investmentProgramId: (query)  
     - parameter currentBalance: (query)  
     - parameter authorization: (header) JWT access token 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func apiBrokerPeriodClosePost(investmentProgramId: UUID, currentBalance: Double, authorization: String, completion: @escaping ((_ error: Error?) -> Void)) {
        apiBrokerPeriodClosePostWithRequestBuilder(investmentProgramId: investmentProgramId, currentBalance: currentBalance, authorization: authorization).execute { (response, error) -> Void in
            completion(error);
        }
    }


    /**
     Close investment period
     - POST /api/broker/period/close
     
     - parameter investmentProgramId: (query)  
     - parameter currentBalance: (query)  
     - parameter authorization: (header) JWT access token 

     - returns: RequestBuilder<Void> 
     */
    open class func apiBrokerPeriodClosePostWithRequestBuilder(investmentProgramId: UUID, currentBalance: Double, authorization: String) -> RequestBuilder<Void> {
        let path = "/api/broker/period/close"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)
        url?.queryItems = APIHelper.mapValuesToQueryItems(values:[
            "investmentProgramId": investmentProgramId, 
            "currentBalance": currentBalance
        ])
        
        let nillableHeaders: [String: Any?] = [
            "Authorization": authorization
        ]
        let headerParameters = APIHelper.rejectNilHeaders(nillableHeaders)

        let requestBuilder: RequestBuilder<Void>.Type = SwaggerClientAPI.requestBuilderFactory.getNonDecodableBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false, headers: headerParameters)
    }

    /**
     Close investment program
     
     - parameter investmentProgramId: (query)  
     - parameter managerBalance: (query)  
     - parameter authorization: (header) JWT access token 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func apiBrokerPeriodProcessClosingProgramPost(investmentProgramId: UUID, managerBalance: Double, authorization: String, completion: @escaping ((_ error: Error?) -> Void)) {
        apiBrokerPeriodProcessClosingProgramPostWithRequestBuilder(investmentProgramId: investmentProgramId, managerBalance: managerBalance, authorization: authorization).execute { (response, error) -> Void in
            completion(error);
        }
    }


    /**
     Close investment program
     - POST /api/broker/period/processClosingProgram
     
     - parameter investmentProgramId: (query)  
     - parameter managerBalance: (query)  
     - parameter authorization: (header) JWT access token 

     - returns: RequestBuilder<Void> 
     */
    open class func apiBrokerPeriodProcessClosingProgramPostWithRequestBuilder(investmentProgramId: UUID, managerBalance: Double, authorization: String) -> RequestBuilder<Void> {
        let path = "/api/broker/period/processClosingProgram"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)
        url?.queryItems = APIHelper.mapValuesToQueryItems(values:[
            "investmentProgramId": investmentProgramId, 
            "managerBalance": managerBalance
        ])
        
        let nillableHeaders: [String: Any?] = [
            "Authorization": authorization
        ]
        let headerParameters = APIHelper.rejectNilHeaders(nillableHeaders)

        let requestBuilder: RequestBuilder<Void>.Type = SwaggerClientAPI.requestBuilderFactory.getNonDecodableBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false, headers: headerParameters)
    }

    /**
     Process investment requests
     
     - parameter investmentProgramId: (query)  
     - parameter authorization: (header) JWT access token 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func apiBrokerPeriodProcessInvestmentRequestsPost(investmentProgramId: UUID, authorization: String, completion: @escaping ((_ data: UUID?,_ error: Error?) -> Void)) {
        apiBrokerPeriodProcessInvestmentRequestsPostWithRequestBuilder(investmentProgramId: investmentProgramId, authorization: authorization).execute { (response, error) -> Void in
            completion(response?.body, error);
        }
    }


    /**
     Process investment requests
     - POST /api/broker/period/processInvestmentRequests
     - examples: [{contentType=application/json, example="046b6c7f-0b8a-43b9-b35d-6489e6daee91"}]
     
     - parameter investmentProgramId: (query)  
     - parameter authorization: (header) JWT access token 

     - returns: RequestBuilder<UUID> 
     */
    open class func apiBrokerPeriodProcessInvestmentRequestsPostWithRequestBuilder(investmentProgramId: UUID, authorization: String) -> RequestBuilder<UUID> {
        let path = "/api/broker/period/processInvestmentRequests"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)
        url?.queryItems = APIHelper.mapValuesToQueryItems(values:[
            "investmentProgramId": investmentProgramId
        ])
        
        let nillableHeaders: [String: Any?] = [
            "Authorization": authorization
        ]
        let headerParameters = APIHelper.rejectNilHeaders(nillableHeaders)

        let requestBuilder: RequestBuilder<UUID>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false, headers: headerParameters)
    }

    /**
     Update manager token initial price/total supply after loss
     
     - parameter investmentProgramId: (query)  
     - parameter investorLossShare: (query)  
     - parameter authorization: (header) JWT access token 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func apiBrokerPeriodReevaluateManagerTokenPost(investmentProgramId: UUID, investorLossShare: Double, authorization: String, completion: @escaping ((_ error: Error?) -> Void)) {
        apiBrokerPeriodReevaluateManagerTokenPostWithRequestBuilder(investmentProgramId: investmentProgramId, investorLossShare: investorLossShare, authorization: authorization).execute { (response, error) -> Void in
            completion(error);
        }
    }


    /**
     Update manager token initial price/total supply after loss
     - POST /api/broker/period/reevaluateManagerToken
     
     - parameter investmentProgramId: (query)  
     - parameter investorLossShare: (query)  
     - parameter authorization: (header) JWT access token 

     - returns: RequestBuilder<Void> 
     */
    open class func apiBrokerPeriodReevaluateManagerTokenPostWithRequestBuilder(investmentProgramId: UUID, investorLossShare: Double, authorization: String) -> RequestBuilder<Void> {
        let path = "/api/broker/period/reevaluateManagerToken"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)
        url?.queryItems = APIHelper.mapValuesToQueryItems(values:[
            "investmentProgramId": investmentProgramId, 
            "investorLossShare": investorLossShare
        ])
        
        let nillableHeaders: [String: Any?] = [
            "Authorization": authorization
        ]
        let headerParameters = APIHelper.rejectNilHeaders(nillableHeaders)

        let requestBuilder: RequestBuilder<Void>.Type = SwaggerClientAPI.requestBuilderFactory.getNonDecodableBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false, headers: headerParameters)
    }

    /**
     Set investment period start balance, manager share, manager balance
     
     - parameter authorization: (header) JWT access token 
     - parameter model: (body)  (optional)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func apiBrokerPeriodSetStartValuesPost(authorization: String, model: StartValues? = nil, completion: @escaping ((_ error: Error?) -> Void)) {
        apiBrokerPeriodSetStartValuesPostWithRequestBuilder(authorization: authorization, model: model).execute { (response, error) -> Void in
            completion(error);
        }
    }


    /**
     Set investment period start balance, manager share, manager balance
     - POST /api/broker/period/setStartValues
     
     - parameter authorization: (header) JWT access token 
     - parameter model: (body)  (optional)

     - returns: RequestBuilder<Void> 
     */
    open class func apiBrokerPeriodSetStartValuesPostWithRequestBuilder(authorization: String, model: StartValues? = nil) -> RequestBuilder<Void> {
        let path = "/api/broker/period/setStartValues"
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
     Terminate program
     
     - parameter investmentProgramId: (query)  
     - parameter authorization: (header) JWT access token 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func apiBrokerPeriodTerminatePost(investmentProgramId: UUID, authorization: String, completion: @escaping ((_ error: Error?) -> Void)) {
        apiBrokerPeriodTerminatePostWithRequestBuilder(investmentProgramId: investmentProgramId, authorization: authorization).execute { (response, error) -> Void in
            completion(error);
        }
    }


    /**
     Terminate program
     - POST /api/broker/period/terminate
     
     - parameter investmentProgramId: (query)  
     - parameter authorization: (header) JWT access token 

     - returns: RequestBuilder<Void> 
     */
    open class func apiBrokerPeriodTerminatePostWithRequestBuilder(investmentProgramId: UUID, authorization: String) -> RequestBuilder<Void> {
        let path = "/api/broker/period/terminate"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)
        url?.queryItems = APIHelper.mapValuesToQueryItems(values:[
            "investmentProgramId": investmentProgramId
        ])
        
        let nillableHeaders: [String: Any?] = [
            "Authorization": authorization
        ]
        let headerParameters = APIHelper.rejectNilHeaders(nillableHeaders)

        let requestBuilder: RequestBuilder<Void>.Type = SwaggerClientAPI.requestBuilderFactory.getNonDecodableBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false, headers: headerParameters)
    }

    /**
     Get data for closing investment period
     
     - parameter investmentProgramId: (query)  
     - parameter authorization: (header) JWT access token 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func apiBrokerPeriodlosingDataGet(investmentProgramId: UUID, authorization: String, completion: @escaping ((_ data: ClosePeriodData?,_ error: Error?) -> Void)) {
        apiBrokerPeriodlosingDataGetWithRequestBuilder(investmentProgramId: investmentProgramId, authorization: authorization).execute { (response, error) -> Void in
            completion(response?.body, error);
        }
    }


    /**
     Get data for closing investment period
     - GET /api/broker/period/сlosingData
     - examples: [{contentType=application/json, example={
  "tokenHolders" : [ {
    "amount" : 0.8008281904610115,
    "investorId" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91"
  }, {
    "amount" : 0.8008281904610115,
    "investorId" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91"
  } ],
  "canCloseCurrentPeriod" : true,
  "currentPeriod" : {
    "number" : 3,
    "managerStartBalance" : 4.145608029883936,
    "managerStartShare" : 7.386281948385884,
    "processStatus" : "None",
    "investmentRequest" : [ {
      "date" : "2000-01-23T04:56:07.000+00:00",
      "canCancelRequest" : true,
      "amount" : 1.2315135367772556,
      "id" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
      "type" : "Invest",
      "status" : "New"
    }, {
      "date" : "2000-01-23T04:56:07.000+00:00",
      "canCancelRequest" : true,
      "amount" : 1.2315135367772556,
      "id" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
      "type" : "Invest",
      "status" : "New"
    } ],
    "dateTo" : "2000-01-23T04:56:07.000+00:00",
    "id" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
    "dateFrom" : "2000-01-23T04:56:07.000+00:00",
    "startBalance" : 2.027123023002322,
    "status" : "Planned"
  },
  "investmentProgramStatus" : "None"
}}]
     
     - parameter investmentProgramId: (query)  
     - parameter authorization: (header) JWT access token 

     - returns: RequestBuilder<ClosePeriodData> 
     */
    open class func apiBrokerPeriodlosingDataGetWithRequestBuilder(investmentProgramId: UUID, authorization: String) -> RequestBuilder<ClosePeriodData> {
        let path = "/api/broker/period/сlosingData"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)
        url?.queryItems = APIHelper.mapValuesToQueryItems(values:[
            "investmentProgramId": investmentProgramId
        ])
        
        let nillableHeaders: [String: Any?] = [
            "Authorization": authorization
        ]
        let headerParameters = APIHelper.rejectNilHeaders(nillableHeaders)

        let requestBuilder: RequestBuilder<ClosePeriodData>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false, headers: headerParameters)
    }

    /**
     Update manager history ipfs hash
     
     - parameter authorization: (header) JWT access token 
     - parameter data: (body)  (optional)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func apiBrokerTradesIpfsHashUpdatePost(authorization: String, data: ManagerHistoryIpfsHash? = nil, completion: @escaping ((_ error: Error?) -> Void)) {
        apiBrokerTradesIpfsHashUpdatePostWithRequestBuilder(authorization: authorization, data: data).execute { (response, error) -> Void in
            completion(error);
        }
    }


    /**
     Update manager history ipfs hash
     - POST /api/broker/trades/ipfsHash/update
     
     - parameter authorization: (header) JWT access token 
     - parameter data: (body)  (optional)

     - returns: RequestBuilder<Void> 
     */
    open class func apiBrokerTradesIpfsHashUpdatePostWithRequestBuilder(authorization: String, data: ManagerHistoryIpfsHash? = nil) -> RequestBuilder<Void> {
        let path = "/api/broker/trades/ipfsHash/update"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters = JSONEncodingHelper.encodingParameters(forEncodableObject: data)

        let url = NSURLComponents(string: URLString)

        let nillableHeaders: [String: Any?] = [
            "Authorization": authorization
        ]
        let headerParameters = APIHelper.rejectNilHeaders(nillableHeaders)

        let requestBuilder: RequestBuilder<Void>.Type = SwaggerClientAPI.requestBuilderFactory.getNonDecodableBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true, headers: headerParameters)
    }

    /**
     New trade event
     
     - parameter authorization: (header) JWT access token 
     - parameter tradeEvent: (body)  (optional)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func apiBrokerTradesNewPost(authorization: String, tradeEvent: NewTradeEvent? = nil, completion: @escaping ((_ error: Error?) -> Void)) {
        apiBrokerTradesNewPostWithRequestBuilder(authorization: authorization, tradeEvent: tradeEvent).execute { (response, error) -> Void in
            completion(error);
        }
    }


    /**
     New trade event
     - POST /api/broker/trades/new
     
     - parameter authorization: (header) JWT access token 
     - parameter tradeEvent: (body)  (optional)

     - returns: RequestBuilder<Void> 
     */
    open class func apiBrokerTradesNewPostWithRequestBuilder(authorization: String, tradeEvent: NewTradeEvent? = nil) -> RequestBuilder<Void> {
        let path = "/api/broker/trades/new"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters = JSONEncodingHelper.encodingParameters(forEncodableObject: tradeEvent)

        let url = NSURLComponents(string: URLString)

        let nillableHeaders: [String: Any?] = [
            "Authorization": authorization
        ]
        let headerParameters = APIHelper.rejectNilHeaders(nillableHeaders)

        let requestBuilder: RequestBuilder<Void>.Type = SwaggerClientAPI.requestBuilderFactory.getNonDecodableBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true, headers: headerParameters)
    }

    /**
     New open trades event
     
     - parameter authorization: (header) JWT access token 
     - parameter trades: (body)  (optional)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func apiBrokerTradesOpenTradesNewPost(authorization: String, trades: NewOpenTradesEvent? = nil, completion: @escaping ((_ error: Error?) -> Void)) {
        apiBrokerTradesOpenTradesNewPostWithRequestBuilder(authorization: authorization, trades: trades).execute { (response, error) -> Void in
            completion(error);
        }
    }


    /**
     New open trades event
     - POST /api/broker/trades/openTrades/new
     
     - parameter authorization: (header) JWT access token 
     - parameter trades: (body)  (optional)

     - returns: RequestBuilder<Void> 
     */
    open class func apiBrokerTradesOpenTradesNewPostWithRequestBuilder(authorization: String, trades: NewOpenTradesEvent? = nil) -> RequestBuilder<Void> {
        let path = "/api/broker/trades/openTrades/new"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters = JSONEncodingHelper.encodingParameters(forEncodableObject: trades)

        let url = NSURLComponents(string: URLString)

        let nillableHeaders: [String: Any?] = [
            "Authorization": authorization
        ]
        let headerParameters = APIHelper.rejectNilHeaders(nillableHeaders)

        let requestBuilder: RequestBuilder<Void>.Type = SwaggerClientAPI.requestBuilderFactory.getNonDecodableBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true, headers: headerParameters)
    }

}
