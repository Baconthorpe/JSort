//
//  JSort.swift
//  JSort
//
//  Created by Ezekiel Abuhoff on 9/20/16.
//  Copyright © 2016 Ezekiel Abuhoff. All rights reserved.
//

import Foundation

struct JSort: CustomStringConvertible {
    
    // MARK:
    // MARK: Types of Content
    
    private enum ContentType {
        case String
        case IntOrBool
        case Double
        case Array
        case Dictionary
        case Null
        case InvalidSubscript
    }
    
    // MARK:
    // MARK: Properties
    
    private let object: Any
    private let contentType: ContentType
    
    // MARK:
    // MARK: Initialization
    
    private init(object: Any, contentType: ContentType) {
        self.object = object
        self.contentType = contentType
    }
    
    private static func invalidSubscriptJSort() -> JSort {
        return JSort(object: ContentType.InvalidSubscript, contentType: ContentType.InvalidSubscript)
    }
    
    private init?(foundationObject: Any) {
        guard let verifiedJSONType = JSort.contentTypeFor(foundationObject: foundationObject) else { return nil }
        self.contentType = verifiedJSONType
        
        if verifiedJSONType == .Array {
            var parsedArray: [Any] = []
            let rawArray = foundationObject as! [Any]
            for item in rawArray {
                parsedArray.append(JSort(foundationObject: item))
            }
            self.object = parsedArray
        } else if verifiedJSONType == .Dictionary {
            var parsedDictionary: [String:Any] = [:]
            let rawDictionary = foundationObject as! [String:Any]
            for (key, value) in rawDictionary {
                parsedDictionary[key] = JSort(foundationObject: value)
            }
            self.object = parsedDictionary
        } else {
            self.object = foundationObject
        }
    }
    
    public init?(_ data: Data) {
        let jsonObject = JSort.jsonObjectFrom(data: data)
        self.init(foundationObject: jsonObject)
    }
    
    // MARK:
    // MARK: Composition
    
    private static func contentTypeFor(foundationObject: Any) -> ContentType? {
        if let _ = foundationObject as? String {
            return ContentType.String
        } else if let _ = foundationObject as? Int {
            return ContentType.IntOrBool
        } else if let _ = foundationObject as? Double {
            return ContentType.Double
        } else if let _ = foundationObject as? NSArray {
            return ContentType.Array
        } else if let _ = foundationObject as? NSDictionary {
            return ContentType.Dictionary
        } else if let _ = foundationObject as? NSNull {
            return ContentType.Null
        }
        
        return nil
    }
    
    // MARK:
    // MARK: Access
    
    subscript(spec: Any) -> JSort {
        if let index = spec as? Int {
            guard contentType == .Array else { return JSort.invalidSubscriptJSort() }
            let objectAsArray = object as! [JSort]
            return objectAsArray[index]
        } else if let key = spec as? String {
            guard contentType == .Dictionary else { return JSort.invalidSubscriptJSort() }
            let objectAsDictionary = object as! [String:JSort]
            return objectAsDictionary[key] ?? JSort.invalidSubscriptJSort()
        }
        
        return JSort.invalidSubscriptJSort()
    }
    
    public var string: String? {
        guard contentType == .String else { return nil }
        guard let objectAsString = object as? String else { return nil }
        return objectAsString
    }
    
    public var int: Int? {
        guard contentType == .IntOrBool else { return nil }
        guard let objectAsInt = object as? Int else { return nil }
        return objectAsInt
    }
    
    public var bool: Bool? {
        guard contentType == .IntOrBool else { return nil }
        guard let objectAsInt = object as? Int else { return nil }
        if objectAsInt == 1 { return true }
        if objectAsInt == 0 { return false }
        return nil
    }
    
    public var double: Double? {
        guard contentType == .Double else { return nil }
        guard let objectAsDouble = object as? Double else { return nil }
        return objectAsDouble
    }
    
    public var array: [JSort]? {
        guard contentType == .Array else { return nil }
        guard let objectAsArray = object as? [JSort] else { return nil }
        return objectAsArray
    }
    
    public var dictionary: [String:JSort]? {
        guard contentType == .Dictionary else { return nil }
        guard let objectAsDictionary = object as? [String:JSort] else { return nil }
        return objectAsDictionary
    }
    
    public var isNull: Bool {
        return contentType == .Null
    }
    
    public var isValid: Bool {
        return contentType != .InvalidSubscript
    }
    
    // MARK:
    // MARK: Logging
    
    var description: String {
        return "<\(contentType)> \(object)"
    }
    
    // MARK:
    // MARK: Utility
    
    private static func jsonObjectFrom(data: Data) -> Any? {
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
            return jsonObject
        } catch {
            return nil
        }
    }
    
    
}
