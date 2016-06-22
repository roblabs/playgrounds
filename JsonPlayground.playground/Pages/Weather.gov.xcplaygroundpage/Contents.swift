//: [Previous](@previous)

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

//: ### Simple Json from Weather.gov
//: Example from [Weather.gov](http://forecast.weather.gov/MapClick.php?FcstType=json&lat=32.9&lon=-116.9)

let someJson:[String:AnyObject] = [
    "key": "value"
]
var json = JSON(someJson)

//: #### Json in the cloud
/*
 var example = "http://forecast.weather.gov/MapClick.php?FcstType=json&lat=32.9&lon=-116.9"
 
 var json = JSON(url:example)
 json.toString(true) => cout
 */



//: #### Json on disk
filePath = NSBundle.mainBundle().pathForResource("weather", ofType:"json")!
optData =  NSData(contentsOfFile:filePath)!

do {
    let weather = try NSJSONSerialization.JSONObjectWithData(optData as NSData, options: .MutableContainers) as! NSDictionary
    
    json = JSON(weather)
    
    json["creationDateLocal"]  => cout
    json["location"]["latitude"]  => cout
    json["location"]["longitude"]  => cout
    json["location"]["areaDescription"]  => cout
    json["location"]["elevation"]  => cout
    
    var period = json["time"]["startPeriodName"][0]
    var data = json["data"]["text"][0]
    print("\(period), \(data)")
    
    period = json["time"]["startPeriodName"][1]
    data = json["data"]["text"][1]
    print("\(period), \(data)")
} catch {
    print("error: \(error)")
}



//: [Next](@next)
