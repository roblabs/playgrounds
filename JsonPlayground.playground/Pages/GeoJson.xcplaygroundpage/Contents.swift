//: Playground for consuming GeoJson using [swift-json](https://github.com/dankogai/swift-json)

import UIKit

var filePath = ""
var optData = NSData()

//: 'cout' for convenience
infix operator => { associativity left precedence 95 }
func => <A,R> (lhs:A, rhs:A->R)->R {
    return rhs(lhs)
}
var counter = 0;
func cout(a: Any) {
    print("\(counter):\t\(a)")
    counter += 1
}


//: This is what a new .geojson from [GeoJson.io](http://geojson.io) looks like
let geojsonio:[String:AnyObject] = [
    "type": "FeatureCollection",
    "features": []
]

var json = JSON(geojsonio)
let jstr = json.toString()
jstr => cout


//: ### Simple GeoJson
//: Example from [Mapbox simplestyle-spec](https://raw.githubusercontent.com/mapbox/simplestyle-spec/master/1.1.0/example.geojson)

//: #### Json in the cloud
var example = "https://raw.githubusercontent.com/mapbox/simplestyle-spec/master/1.1.0/example.geojson"
JSON(url:example).toString(true)    => cout


//: #### Json on disk
filePath = NSBundle.mainBundle().pathForResource("example", ofType:"geojson")!
optData =  NSData(contentsOfFile:filePath)!

do {
    let directions = try NSJSONSerialization.JSONObjectWithData(optData as NSData, options: .MutableContainers) as! NSDictionary
    
    json = JSON(directions)
    
    json["features"][0]["properties"] => cout
    json["features"][0]["geometry"]["type"] => cout
    json["features"][0]["geometry"]["coordinates"] => cout
} catch {
    print("error: \(error)")
}

//: ### Mapbox Directions
//: Example call using [Command line interface to Mapbox Web Services](https://github.com/mapbox/mapbox-cli-py)
//:
//: ```mapbox directions "[-117.25955512721029, 32.79567733656968]" "[-117.25657591544467, 32.79634186493631]" --profile mapbox.walking --geojson```
//:
filePath = NSBundle.mainBundle().pathForResource("Pacific-Beach", ofType:"geojson")!
optData =  NSData(contentsOfFile:filePath)!

do {
    let directions = try NSJSONSerialization.JSONObjectWithData(optData as NSData, options: .MutableContainers) as! NSDictionary
    
    json = JSON(directions)
    
    json["features"][0]["properties"] => cout
    json["features"][0]["properties"]["distance"] => cout
    json["features"][0]["properties"]["summary"] => cout
} catch {
    print("error: \(error)")
}


//: ### Traverse two points from a .geojson file on disk

filePath = NSBundle.mainBundle().pathForResource("two-points", ofType:"geojson")!
optData =  NSData(contentsOfFile:filePath)!

do {
    let twoPoints = try NSJSONSerialization.JSONObjectWithData(optData as NSData, options: .MutableContainers) as! NSDictionary
    
    json = JSON(twoPoints)
    
    
    // Iterate over all key value pairs
    for (k, v) in json["features"] {
        "[\"object\"][\"\(k)\"] =>\t\(v)"   => cout
    }
    
    for (key, value) in json["features"] {
        "[\"object\"][\"\(key)\"] =>\t\(value["geometry"]["coordinates"])"   => cout
        "[\"object\"][\"\(key)\"] =>\t\(value["geometry"]["coordinates"][0])"   => cout
        "[\"object\"][\"\(key)\"] =>\t\(value["geometry"]["coordinates"][1])"   => cout
    }
    
    // or Traverse manually
    json["features"][0]["geometry"]["type"] => cout
    json["features"][0]["geometry"]["coordinates"] => cout
    json["features"][0]["geometry"]["coordinates"][0] => cout
    json["features"][0]["geometry"]["coordinates"][1] => cout
} catch {
    print("error: \(error)")
}
