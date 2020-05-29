//
// EditablePost.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


public struct EditablePost: Codable {


    public var textOriginal: String?

    public var _id: UUID?

    public var text: String?

    public var date: Date?

    public var likesCount: Int?

    public var rePostsCount: Int?

    public var impressionsCount: Int?

    public var isPinned: Bool?

    public var isDeleted: Bool?

    public var images: [PostImage]?

    public var tags: [PostTag]?

    public var author: ProfilePublic?

    public var actions: PostActions?

    public var comments: [Post]?
    public init(textOriginal: String? = nil, _id: UUID? = nil, text: String? = nil, date: Date? = nil, likesCount: Int? = nil, rePostsCount: Int? = nil, impressionsCount: Int? = nil, isPinned: Bool? = nil, isDeleted: Bool? = nil, images: [PostImage]? = nil, tags: [PostTag]? = nil, author: ProfilePublic? = nil, actions: PostActions? = nil, comments: [Post]? = nil) { 
        self.textOriginal = textOriginal
        self._id = _id
        self.text = text
        self.date = date
        self.likesCount = likesCount
        self.rePostsCount = rePostsCount
        self.impressionsCount = impressionsCount
        self.isPinned = isPinned
        self.isDeleted = isDeleted
        self.images = images
        self.tags = tags
        self.author = author
        self.actions = actions
        self.comments = comments
    }
    public enum CodingKeys: String, CodingKey { 
        case textOriginal
        case _id = "id"
        case text
        case date
        case likesCount
        case rePostsCount
        case impressionsCount
        case isPinned
        case isDeleted
        case images
        case tags
        case author
        case actions
        case comments
    }

}
