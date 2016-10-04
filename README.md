![Logo](JSortLogo.png)

JSort is a simple framework for parsing JSON data in Swift.

## Usage
Pass your data (such as the data you get in an HTTP response) into the initializer for a JSort object.
```swift
guard let sortedData = JSort(responseData) else { return }
```
As long as you pass in data comprising valid json, you'll get back a JSort object.

Use a type property of your JSort object to cast its contents to the native Swift type you expect.
```swift
guard let responseDictionary = sortedData.dictionary else { return }
```
You can also use subscripts to navigate through the JSON to the level that interests you before casting.
```swift
let nestedJSON = sortedData["results"][3]["name"]
guard let name = nestedJSON.string else { return }
```
And that's it! No having to fuss with `NSJSONSerialization` or handle all manner of errors. You just turn your data into JSort and your JSort into a native type.

## Examples
```swift
// This function parses data expected to be a simple dictionary of strings.

func parseDictionary(data: Data) -> [String : String]? {
  guard let sortedData = JSort(data) else { return nil }
  if let sortedDictionary = sortedData.dictionary as? [String : String] {
    return sortedDictionary
  }
  return nil
}
```
```swift
// This function uses JSort's 'isValid' property to check if JSON data matches the expected structure.

func validateJSON(data: Data) -> Bool {
  guard let _ = JSort(data) else { return false }
  guard validJSON["items"]["businesses"][0]["contact_info"].isValid else { return false }
  guard validJSON["items"]["businesses"][0]["menu"].isValid else { return false }

  return true
}
```
```swift
// This function relegates all parsing issues to the error-catching system.
// The error type 'APIError' is presumably defined elsewhere.

func arrayFromJSON(data: Data) -> throws [Int] {
  guard let intArray = JSort(data)?.array as? [Int] else { throw APIError.parsing }
  return intArray
}
```

## License
All rights - Zeke Abuhoff 2016
