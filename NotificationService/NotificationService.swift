//
//  NotificationService.swift
//  NotificationService
//
//  Created by Ruslan Lukin on 30.09.2020.
//  Copyright © 2020 Genesis Vision. All rights reserved.
//

import UserNotifications

class NotificationService: UNNotificationServiceExtension {
    
    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?
    
    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        guard let bestAttemptContent = bestAttemptContent else { return }
              
        guard let result = request.content.userInfo["result"] as? String,
              let dict = convertToDictionary(text: result),
              let imageUrlString = dict["imageUrl"] as? String,
              let attachmentUrl = URL(string: imageUrlString) else {
            contentHandler(bestAttemptContent)
            return }
        
        store(url: attachmentUrl, fileExtension: "jpeg") { (path, error) in
            if let path = path, let attachment = try? UNNotificationAttachment(identifier: "image", url: path, options: nil) {
                bestAttemptContent.attachments = [attachment]
                contentHandler(bestAttemptContent)
            } else {
                contentHandler(bestAttemptContent)
            }
        }
    }
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    func store(url: URL, fileExtension: String, completion: ((URL?, Error?) -> ())?) {
        // obtain path to temporary file
        let filename = ProcessInfo.processInfo.globallyUniqueString
        let path = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("\(filename).\(fileExtension)")
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let semaphore = DispatchSemaphore(value: 0)
        let task = session.dataTask(with: url) { (data, response, error) in
            let _ = try? data?.write(to: path)
            completion?(path, error)
            semaphore.signal()
        }
        task.resume()
        _ = semaphore.wait(timeout: .distantFuture)
    }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }
    
}
