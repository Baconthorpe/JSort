//
//  JSort.swift
//  JSort
//
//  Created by Ezekiel Abuhoff on 9/20/16.
//  Copyright © 2016 Ezekiel Abuhoff. All rights reserved.
//

import Foundation

public struct JSort: CustomStringConvertible {
    
    // MARK:
    // MARK: Types of Content
    
    private enum ContentType {
        case string
        case intOrBool
        case double
        case array
        case dictionary
        case null
        case invalidSubscript
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
        return JSort(object: ContentType.invalidSubscript, contentType: ContentType.invalidSubscript)
    }
    
    private init?(foundationObject: Any) {
        guard let verifiedJSONType = JSort.contentTypeFor(foundationObject: foundationObject) else { return nil }
        self.contentType = verifiedJSONType
        
        if verifiedJSONType == .array {
            var parsedArray: [Any] = []
            let rawArray = foundationObject as! [Any]
            for item in rawArray {
                parsedArray.append(JSort(foundationObject: item))
            }
            self.object = parsedArray
        } else if verifiedJSONType == .dictionary {
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
            return ContentType.string
        } else if let _ = foundationObject as? Int {
            return ContentType.intOrBool
        } else if let _ = foundationObject as? Double {
            return ContentType.double
        } else if let _ = foundationObject as? NSArray {
            return ContentType.array
        } else if let _ = foundationObject as? NSDictionary {
            return ContentType.dictionary
        } else if let _ = foundationObject as? NSNull {
            return ContentType.null
        }
        
        return nil
    }
    
    // MARK:
    // MARK: Access - Subscripts
    
    subscript(index: Int) -> JSort {
        guard contentType == .array else { return JSort.invalidSubscriptJSort() }
        let objectAsArray = object as! [JSort]
        return objectAsArray[index]
    }
    
    subscript(key: String) -> JSort {
        guard contentType == .dictionary else { return JSort.invalidSubscriptJSort() }
        let objectAsDictionary = object as! [String:JSort]
        return objectAsDictionary[key] ?? JSort.invalidSubscriptJSort()
    }
    
    // MARK:
    // MARK: Access - Standard Swift Types
    
    public var string: String? {
        guard contentType == .string else { return nil }
        guard let objectAsString = object as? String else { return nil }
        return objectAsString
    }
    
    public var int: Int? {
        guard contentType == .intOrBool else { return nil }
        guard let objectAsInt = object as? Int else { return nil }
        return objectAsInt
    }
    
    public var bool: Bool? {
        guard contentType == .intOrBool else { return nil }
        guard let objectAsInt = object as? Int else { return nil }
        if objectAsInt == 1 { return true }
        if objectAsInt == 0 { return false }
        return nil
    }
    
    public var double: Double? {
        guard contentType == .double else { return nil }
        guard let objectAsDouble = object as? Double else { return nil }
        return objectAsDouble
    }
    
    public var array: [Any]? {
        guard contentType == .array else { return nil }
        guard let objectAsArray = object as? [JSort] else { return nil }
        
        var anyTypeArray: [Any] = []
        for jsortObject in objectAsArray {
            switch jsortObject.contentType {
            case .string:
                if let certainString = jsortObject.string {
                    anyTypeArray.append(certainString)
                }
            case .intOrBool:
                if let certainInt = jsortObject.int {
                    anyTypeArray.append(certainInt)
                }
            case .double:
                if let certainDouble = jsortObject.double {
                    anyTypeArray.append(certainDouble)
                }
            case .array:
                if let certainArray = jsortObject.array {
                    anyTypeArray.append(certainArray)
                }
            case .dictionary:
                if let certainDictionary = jsortObject.dictionary {
                    anyTypeArray.append(certainDictionary)
                }
            default:
                anyTypeArray.append(NSNull())
            }
        }
        return anyTypeArray
    }
    
    public var dictionary: [String:Any]? {
        guard contentType == .dictionary else { return nil }
        guard let objectAsDictionary = object as? [String:JSort] else { return nil }
        
        var anyTypeDictionary: [String:Any] = [:]
        for (key, value) in objectAsDictionary {
            switch value.contentType {
            case .string:
                if let certainString = value.string {
                    anyTypeDictionary[key] = certainString
                }
            case .intOrBool:
                if let certainInt = value.int {
                    anyTypeDictionary[key] = certainInt
                }
            case .double:
                if let certainDouble = value.double {
                    anyTypeDictionary[key] = certainDouble
                }
            case .array:
                if let certainArray = value.array {
                    anyTypeDictionary[key] = certainArray
                }
            case .dictionary:
                if let certainDictionary = value.dictionary {
                    anyTypeDictionary[key] = certainDictionary
                }
            default:
                anyTypeDictionary[key] = NSNull()
            }
        }
        return anyTypeDictionary
    }
    
    public var isNull: Bool {
        return contentType == .null
    }
    
    public var isValid: Bool {
        return contentType != .invalidSubscript
    }
    
    // MARK:
    // MARK: Logging
    
    public var description: String {
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
