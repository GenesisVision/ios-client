//
// ManagersAPI.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation
import Alamofire



open class ManagersAPI {
    /**
     Manager profile
     
     - parameter id: (path)  
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func v10ManagersByIdGet(id: UUID, completion: @escaping ((_ data: ManagerProfile?,_ error: Error?) -> Void)) {
        v10ManagersByIdGetWithRequestBuilder(id: id).execute { (response, error) -> Void in
            completion(response?.body, error);
        }
    }


    /**
     Manager profile
     - GET /v1.0/managers/{id}
     - examples: [{contentType=application/json, example={
  "assets" : [ "assets", "assets" ],
  "about" : "about",
  "regDate" : "2000-01-23T04:56:07.000+00:00",
  "id" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
  "avatar" : "avatar",
  "username" : "username"
}}]
     
     - parameter id: (path)  

     - returns: RequestBuilder<ManagerProfile> 
     */
    open class func v10ManagersByIdGetWithRequestBuilder(id: UUID) -> RequestBuilder<ManagerProfile> {
        var path = "/v1.0/managers/{id}"
        path = path.replacingOccurrences(of: "{id}", with: "\(id)", options: .literal, range: nil)
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)


        let requestBuilder: RequestBuilder<ManagerProfile>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**
     Update fund assets parts
     
     - parameter id: (path)  
     - parameter authorization: (header) JWT access token 
     - parameter model: (body)  (optional)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func v10ManagersFundsByIdAssetsUpdatePost(id: UUID, authorization: String, model: AssetsPartsChangeRequest? = nil, completion: @escaping ((_ error: Error?) -> Void)) {
        v10ManagersFundsByIdAssetsUpdatePostWithRequestBuilder(id: id, authorization: authorization, model: model).execute { (response, error) -> Void in
            completion(error);
        }
    }


    /**
     Update fund assets parts
     - POST /v1.0/managers/funds/{id}/assets/update
     
     - parameter id: (path)  
     - parameter authorization: (header) JWT access token 
     - parameter model: (body)  (optional)

     - returns: RequestBuilder<Void> 
     */
    open class func v10ManagersFundsByIdAssetsUpdatePostWithRequestBuilder(id: UUID, authorization: String, model: AssetsPartsChangeRequest? = nil) -> RequestBuilder<Void> {
        var path = "/v1.0/managers/funds/{id}/assets/update"
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
     Close existing investment program/fund
     
     - parameter id: (path)  
     - parameter authorization: (header) JWT access token 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func v10ManagersFundsByIdClosePost(id: UUID, authorization: String, completion: @escaping ((_ error: Error?) -> Void)) {
        v10ManagersFundsByIdClosePostWithRequestBuilder(id: id, authorization: authorization).execute { (response, error) -> Void in
            completion(error);
        }
    }


    /**
     Close existing investment program/fund
     - POST /v1.0/managers/funds/{id}/close
     
     - parameter id: (path)  
     - parameter authorization: (header) JWT access token 

     - returns: RequestBuilder<Void> 
     */
    open class func v10ManagersFundsByIdClosePostWithRequestBuilder(id: UUID, authorization: String) -> RequestBuilder<Void> {
        var path = "/v1.0/managers/funds/{id}/close"
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
     Get investment program/fund requests
     
     - parameter id: (path)  
     - parameter skip: (path)  
     - parameter take: (path)  
     - parameter authorization: (header) JWT access token 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func v10ManagersFundsByIdRequestsBySkipByTakeGet(id: UUID, skip: Int, take: Int, authorization: String, completion: @escaping ((_ data: ProgramRequests?,_ error: Error?) -> Void)) {
        v10ManagersFundsByIdRequestsBySkipByTakeGetWithRequestBuilder(id: id, skip: skip, take: take, authorization: authorization).execute { (response, error) -> Void in
            completion(response?.body, error);
        }
    }


    /**
     Get investment program/fund requests
     - GET /v1.0/managers/funds/{id}/requests/{skip}/{take}
     - examples: [{contentType=application/json, example={
  "totalValue" : 6.683562403749608,
  "total" : 9,
  "requests" : [ {
    "date" : "2000-01-23T04:56:07.000+00:00",
    "canCancelRequest" : true,
    "logo" : "logo",
    "id" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
    "type" : "Invest",
    "title" : "title",
    "value" : 9.965781217890562,
    "programId" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
    "status" : "New"
  }, {
    "date" : "2000-01-23T04:56:07.000+00:00",
    "canCancelRequest" : true,
    "logo" : "logo",
    "id" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
    "type" : "Invest",
    "title" : "title",
    "value" : 9.965781217890562,
    "programId" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
    "status" : "New"
  } ]
}}]
     
     - parameter id: (path)  
     - parameter skip: (path)  
     - parameter take: (path)  
     - parameter authorization: (header) JWT access token 

     - returns: RequestBuilder<ProgramRequests> 
     */
    open class func v10ManagersFundsByIdRequestsBySkipByTakeGetWithRequestBuilder(id: UUID, skip: Int, take: Int, authorization: String) -> RequestBuilder<ProgramRequests> {
        var path = "/v1.0/managers/funds/{id}/requests/{skip}/{take}"
        path = path.replacingOccurrences(of: "{id}", with: "\(id)", options: .literal, range: nil)
        path = path.replacingOccurrences(of: "{skip}", with: "\(skip)", options: .literal, range: nil)
        path = path.replacingOccurrences(of: "{take}", with: "\(take)", options: .literal, range: nil)
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)

        let nillableHeaders: [String: Any?] = [
            "Authorization": authorization
        ]
        let headerParameters = APIHelper.rejectNilHeaders(nillableHeaders)

        let requestBuilder: RequestBuilder<ProgramRequests>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false, headers: headerParameters)
    }

    /**
     Update investment program/fund details
     
     - parameter id: (path)  
     - parameter authorization: (header) JWT access token 
     - parameter model: (body)  (optional)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func v10ManagersFundsByIdUpdatePost(id: UUID, authorization: String, model: ProgramUpdate? = nil, completion: @escaping ((_ error: Error?) -> Void)) {
        v10ManagersFundsByIdUpdatePostWithRequestBuilder(id: id, authorization: authorization, model: model).execute { (response, error) -> Void in
            completion(error);
        }
    }


    /**
     Update investment program/fund details
     - POST /v1.0/managers/funds/{id}/update
     
     - parameter id: (path)  
     - parameter authorization: (header) JWT access token 
     - parameter model: (body)  (optional)

     - returns: RequestBuilder<Void> 
     */
    open class func v10ManagersFundsByIdUpdatePostWithRequestBuilder(id: UUID, authorization: String, model: ProgramUpdate? = nil) -> RequestBuilder<Void> {
        var path = "/v1.0/managers/funds/{id}/update"
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
     Create fund
     
     - parameter authorization: (header) JWT access token 
     - parameter request: (body)  (optional)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func v10ManagersFundsCreatePost(authorization: String, request: NewFundRequest? = nil, completion: @escaping ((_ error: Error?) -> Void)) {
        v10ManagersFundsCreatePostWithRequestBuilder(authorization: authorization, request: request).execute { (response, error) -> Void in
            completion(error);
        }
    }


    /**
     Create fund
     - POST /v1.0/managers/funds/create
     
     - parameter authorization: (header) JWT access token 
     - parameter request: (body)  (optional)

     - returns: RequestBuilder<Void> 
     */
    open class func v10ManagersFundsCreatePostWithRequestBuilder(authorization: String, request: NewFundRequest? = nil) -> RequestBuilder<Void> {
        let path = "/v1.0/managers/funds/create"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters = JSONEncodingHelper.encodingParameters(forEncodableObject: request)

        let url = NSURLComponents(string: URLString)

        let nillableHeaders: [String: Any?] = [
            "Authorization": authorization
        ]
        let headerParameters = APIHelper.rejectNilHeaders(nillableHeaders)

        let requestBuilder: RequestBuilder<Void>.Type = SwaggerClientAPI.requestBuilderFactory.getNonDecodableBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true, headers: headerParameters)
    }

    /**
     Get GVT investment to create fund
     
     - parameter authorization: (header) JWT access token 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func v10ManagersFundsInvestmentAmountGet(authorization: String, completion: @escaping ((_ data: Double?,_ error: Error?) -> Void)) {
        v10ManagersFundsInvestmentAmountGetWithRequestBuilder(authorization: authorization).execute { (response, error) -> Void in
            completion(response?.body, error);
        }
    }


    /**
     Get GVT investment to create fund
     - GET /v1.0/managers/funds/investment/amount
     - examples: [{contentType=application/json, example=0.8008281904610115}]
     
     - parameter authorization: (header) JWT access token 

     - returns: RequestBuilder<Double> 
     */
    open class func v10ManagersFundsInvestmentAmountGetWithRequestBuilder(authorization: String) -> RequestBuilder<Double> {
        let path = "/v1.0/managers/funds/investment/amount"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)

        let nillableHeaders: [String: Any?] = [
            "Authorization": authorization
        ]
        let headerParameters = APIHelper.rejectNilHeaders(nillableHeaders)

        let requestBuilder: RequestBuilder<Double>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false, headers: headerParameters)
    }

    /**
     Cancel investment program/fund request
     
     - parameter id: (path)  
     - parameter authorization: (header) JWT access token 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func v10ManagersFundsRequestsByIdCancelPost(id: UUID, authorization: String, completion: @escaping ((_ error: Error?) -> Void)) {
        v10ManagersFundsRequestsByIdCancelPostWithRequestBuilder(id: id, authorization: authorization).execute { (response, error) -> Void in
            completion(error);
        }
    }


    /**
     Cancel investment program/fund request
     - POST /v1.0/managers/funds/requests/{id}/cancel
     
     - parameter id: (path)  
     - parameter authorization: (header) JWT access token 

     - returns: RequestBuilder<Void> 
     */
    open class func v10ManagersFundsRequestsByIdCancelPostWithRequestBuilder(id: UUID, authorization: String) -> RequestBuilder<Void> {
        var path = "/v1.0/managers/funds/requests/{id}/cancel"
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
     Close existing investment program/fund
     
     - parameter id: (path)  
     - parameter authorization: (header) JWT access token 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func v10ManagersProgramsByIdClosePost(id: UUID, authorization: String, completion: @escaping ((_ error: Error?) -> Void)) {
        v10ManagersProgramsByIdClosePostWithRequestBuilder(id: id, authorization: authorization).execute { (response, error) -> Void in
            completion(error);
        }
    }


    /**
     Close existing investment program/fund
     - POST /v1.0/managers/programs/{id}/close
     
     - parameter id: (path)  
     - parameter authorization: (header) JWT access token 

     - returns: RequestBuilder<Void> 
     */
    open class func v10ManagersProgramsByIdClosePostWithRequestBuilder(id: UUID, authorization: String) -> RequestBuilder<Void> {
        var path = "/v1.0/managers/programs/{id}/close"
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
     Deposit
     
     - parameter id: (path)  
     - parameter amount: (path)  
     - parameter authorization: (header) JWT access token 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func v10ManagersProgramsByIdDepositByAmountPost(id: UUID, amount: Double, authorization: String, completion: @escaping ((_ error: Error?) -> Void)) {
        v10ManagersProgramsByIdDepositByAmountPostWithRequestBuilder(id: id, amount: amount, authorization: authorization).execute { (response, error) -> Void in
            completion(error);
        }
    }


    /**
     Deposit
     - POST /v1.0/managers/programs/{id}/deposit/{amount}
     
     - parameter id: (path)  
     - parameter amount: (path)  
     - parameter authorization: (header) JWT access token 

     - returns: RequestBuilder<Void> 
     */
    open class func v10ManagersProgramsByIdDepositByAmountPostWithRequestBuilder(id: UUID, amount: Double, authorization: String) -> RequestBuilder<Void> {
        var path = "/v1.0/managers/programs/{id}/deposit/{amount}"
        path = path.replacingOccurrences(of: "{id}", with: "\(id)", options: .literal, range: nil)
        path = path.replacingOccurrences(of: "{amount}", with: "\(amount)", options: .literal, range: nil)
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
     Close current period
     
     - parameter id: (path)  
     - parameter authorization: (header) JWT access token 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func v10ManagersProgramsByIdPeriodClosePost(id: UUID, authorization: String, completion: @escaping ((_ error: Error?) -> Void)) {
        v10ManagersProgramsByIdPeriodClosePostWithRequestBuilder(id: id, authorization: authorization).execute { (response, error) -> Void in
            completion(error);
        }
    }


    /**
     Close current period
     - POST /v1.0/managers/programs/{id}/period/close
     
     - parameter id: (path)  
     - parameter authorization: (header) JWT access token 

     - returns: RequestBuilder<Void> 
     */
    open class func v10ManagersProgramsByIdPeriodClosePostWithRequestBuilder(id: UUID, authorization: String) -> RequestBuilder<Void> {
        var path = "/v1.0/managers/programs/{id}/period/close"
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
     Get investment program/fund requests
     
     - parameter id: (path)  
     - parameter skip: (path)  
     - parameter take: (path)  
     - parameter authorization: (header) JWT access token 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func v10ManagersProgramsByIdRequestsBySkipByTakeGet(id: UUID, skip: Int, take: Int, authorization: String, completion: @escaping ((_ data: ProgramRequests?,_ error: Error?) -> Void)) {
        v10ManagersProgramsByIdRequestsBySkipByTakeGetWithRequestBuilder(id: id, skip: skip, take: take, authorization: authorization).execute { (response, error) -> Void in
            completion(response?.body, error);
        }
    }


    /**
     Get investment program/fund requests
     - GET /v1.0/managers/programs/{id}/requests/{skip}/{take}
     - examples: [{contentType=application/json, example={
  "totalValue" : 6.683562403749608,
  "total" : 9,
  "requests" : [ {
    "date" : "2000-01-23T04:56:07.000+00:00",
    "canCancelRequest" : true,
    "logo" : "logo",
    "id" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
    "type" : "Invest",
    "title" : "title",
    "value" : 9.965781217890562,
    "programId" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
    "status" : "New"
  }, {
    "date" : "2000-01-23T04:56:07.000+00:00",
    "canCancelRequest" : true,
    "logo" : "logo",
    "id" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
    "type" : "Invest",
    "title" : "title",
    "value" : 9.965781217890562,
    "programId" : "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
    "status" : "New"
  } ]
}}]
     
     - parameter id: (path)  
     - parameter skip: (path)  
     - parameter take: (path)  
     - parameter authorization: (header) JWT access token 

     - returns: RequestBuilder<ProgramRequests> 
     */
    open class func v10ManagersProgramsByIdRequestsBySkipByTakeGetWithRequestBuilder(id: UUID, skip: Int, take: Int, authorization: String) -> RequestBuilder<ProgramRequests> {
        var path = "/v1.0/managers/programs/{id}/requests/{skip}/{take}"
        path = path.replacingOccurrences(of: "{id}", with: "\(id)", options: .literal, range: nil)
        path = path.replacingOccurrences(of: "{skip}", with: "\(skip)", options: .literal, range: nil)
        path = path.replacingOccurrences(of: "{take}", with: "\(take)", options: .literal, range: nil)
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)

        let nillableHeaders: [String: Any?] = [
            "Authorization": authorization
        ]
        let headerParameters = APIHelper.rejectNilHeaders(nillableHeaders)

        let requestBuilder: RequestBuilder<ProgramRequests>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false, headers: headerParameters)
    }

    /**
     Update investment program/fund details
     
     - parameter id: (path)  
     - parameter authorization: (header) JWT access token 
     - parameter model: (body)  (optional)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func v10ManagersProgramsByIdUpdatePost(id: UUID, authorization: String, model: ProgramUpdate? = nil, completion: @escaping ((_ error: Error?) -> Void)) {
        v10ManagersProgramsByIdUpdatePostWithRequestBuilder(id: id, authorization: authorization, model: model).execute { (response, error) -> Void in
            completion(error);
        }
    }


    /**
     Update investment program/fund details
     - POST /v1.0/managers/programs/{id}/update
     
     - parameter id: (path)  
     - parameter authorization: (header) JWT access token 
     - parameter model: (body)  (optional)

     - returns: RequestBuilder<Void> 
     */
    open class func v10ManagersProgramsByIdUpdatePostWithRequestBuilder(id: UUID, authorization: String, model: ProgramUpdate? = nil) -> RequestBuilder<Void> {
        var path = "/v1.0/managers/programs/{id}/update"
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
     Withdraw
     
     - parameter id: (path)  
     - parameter amount: (path)  
     - parameter authorization: (header) JWT access token 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func v10ManagersProgramsByIdWithdrawByAmountPost(id: UUID, amount: Double, authorization: String, completion: @escaping ((_ error: Error?) -> Void)) {
        v10ManagersProgramsByIdWithdrawByAmountPostWithRequestBuilder(id: id, amount: amount, authorization: authorization).execute { (response, error) -> Void in
            completion(error);
        }
    }


    /**
     Withdraw
     - POST /v1.0/managers/programs/{id}/withdraw/{amount}
     
     - parameter id: (path)  
     - parameter amount: (path)  
     - parameter authorization: (header) JWT access token 

     - returns: RequestBuilder<Void> 
     */
    open class func v10ManagersProgramsByIdWithdrawByAmountPostWithRequestBuilder(id: UUID, amount: Double, authorization: String) -> RequestBuilder<Void> {
        var path = "/v1.0/managers/programs/{id}/withdraw/{amount}"
        path = path.replacingOccurrences(of: "{id}", with: "\(id)", options: .literal, range: nil)
        path = path.replacingOccurrences(of: "{amount}", with: "\(amount)", options: .literal, range: nil)
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
     Create an investment program
     
     - parameter authorization: (header) JWT access token 
     - parameter request: (body)  (optional)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func v10ManagersProgramsCreatePost(authorization: String, request: NewProgramRequest? = nil, completion: @escaping ((_ error: Error?) -> Void)) {
        v10ManagersProgramsCreatePostWithRequestBuilder(authorization: authorization, request: request).execute { (response, error) -> Void in
            completion(error);
        }
    }


    /**
     Create an investment program
     - POST /v1.0/managers/programs/create
     
     - parameter authorization: (header) JWT access token 
     - parameter request: (body)  (optional)

     - returns: RequestBuilder<Void> 
     */
    open class func v10ManagersProgramsCreatePostWithRequestBuilder(authorization: String, request: NewProgramRequest? = nil) -> RequestBuilder<Void> {
        let path = "/v1.0/managers/programs/create"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters = JSONEncodingHelper.encodingParameters(forEncodableObject: request)

        let url = NSURLComponents(string: URLString)

        let nillableHeaders: [String: Any?] = [
            "Authorization": authorization
        ]
        let headerParameters = APIHelper.rejectNilHeaders(nillableHeaders)

        let requestBuilder: RequestBuilder<Void>.Type = SwaggerClientAPI.requestBuilderFactory.getNonDecodableBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true, headers: headerParameters)
    }

    /**
     Get GVT investment to create program
     
     - parameter authorization: (header) JWT access token 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func v10ManagersProgramsInvestmentAmountGet(authorization: String, completion: @escaping ((_ data: Double?,_ error: Error?) -> Void)) {
        v10ManagersProgramsInvestmentAmountGetWithRequestBuilder(authorization: authorization).execute { (response, error) -> Void in
            completion(response?.body, error);
        }
    }


    /**
     Get GVT investment to create program
     - GET /v1.0/managers/programs/investment/amount
     - examples: [{contentType=application/json, example=0.8008281904610115}]
     
     - parameter authorization: (header) JWT access token 

     - returns: RequestBuilder<Double> 
     */
    open class func v10ManagersProgramsInvestmentAmountGetWithRequestBuilder(authorization: String) -> RequestBuilder<Double> {
        let path = "/v1.0/managers/programs/investment/amount"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)

        let nillableHeaders: [String: Any?] = [
            "Authorization": authorization
        ]
        let headerParameters = APIHelper.rejectNilHeaders(nillableHeaders)

        let requestBuilder: RequestBuilder<Double>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false, headers: headerParameters)
    }

    /**
     Cancel investment program/fund request
     
     - parameter id: (path)  
     - parameter authorization: (header) JWT access token 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func v10ManagersProgramsRequestsByIdCancelPost(id: UUID, authorization: String, completion: @escaping ((_ error: Error?) -> Void)) {
        v10ManagersProgramsRequestsByIdCancelPostWithRequestBuilder(id: id, authorization: authorization).execute { (response, error) -> Void in
            completion(error);
        }
    }


    /**
     Cancel investment program/fund request
     - POST /v1.0/managers/programs/requests/{id}/cancel
     
     - parameter id: (path)  
     - parameter authorization: (header) JWT access token 

     - returns: RequestBuilder<Void> 
     */
    open class func v10ManagersProgramsRequestsByIdCancelPostWithRequestBuilder(id: UUID, authorization: String) -> RequestBuilder<Void> {
        var path = "/v1.0/managers/programs/requests/{id}/cancel"
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
