//
// NewPost.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


public struct NewPost: Codable {


    public var text: String?

    public var postId: UUID?

    public var userId: UUID?

    public var images: [NewPostImage]?
    public init(text: String? = nil, postId: UUID? = nil, userId: UUID? = nil, images: [NewPostImage]? = nil) { 
        self.text = text
        self.postId = postId
        self.userId = userId
        self.images = images
    }

}
