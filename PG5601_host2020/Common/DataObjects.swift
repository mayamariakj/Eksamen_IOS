import Foundation
import CoreLocation

var myLocationLong : Double = 10.744810
var myLocationLat : Double = 59.911166
var myLocationName : String = "Høyskolen Kristiania"

func setWeatherCoordinates(latitude:CLLocationDegrees, longitude:CLLocationDegrees){
    myLocationLong = longitude
    myLocationLat = latitude
    myLocationName = String(myLocationLat) + ", " + String(myLocationLong)
}

// MARK: - Welcome
struct MetWeatherObject: Codable {
   var updateTime: Date?
   let type: String
   let properties: Properties
}
// MARK: - Properties
struct Properties: Codable {
   let timeseries: [Timesery]
}

// MARK: - Timesery
struct Timesery: Codable {
    let time: String
    let data: DataClass
}

// MARK: - DataClass
struct DataClass: Codable {
    let instant: Instant
    let next12_Hours: Next12_Hours?
    let next1_Hours, next6_Hours: NextHours?

    enum CodingKeys: String, CodingKey {
        case instant
        case next12_Hours = "next_12_hours"
        case next1_Hours = "next_1_hours"
        case next6_Hours = "next_6_hours"
    }
}

// MARK: - Instant
struct Instant: Codable {
    let details: InstantDetails
}

// MARK: - InstantDetails
struct InstantDetails: Codable {
    let airPressureAtSeaLevel, airTemperature, cloudAreaFraction, relativeHumidity: Double
    let windFromDirection, windSpeed: Double

    enum CodingKeys: String, CodingKey {
        case airPressureAtSeaLevel = "air_pressure_at_sea_level"
        case airTemperature = "air_temperature"
        case cloudAreaFraction = "cloud_area_fraction"
        case relativeHumidity = "relative_humidity"
        case windFromDirection = "wind_from_direction"
        case windSpeed = "wind_speed"
    }
}

// MARK: - Next12_Hours
struct Next12_Hours: Codable {
    let summary: Summary
}

// MARK: - Summary
struct Summary: Codable {
    let symbolCode: String //SymbolCode

    enum CodingKeys: String, CodingKey {
        case symbolCode = "symbol_code"
    }
}

enum SymbolCode: String, Codable {
    case clearskyNight = "clearsky_night"
    case cloudy = "cloudy"
    case fairDay = "fair_day"
    case fairNight = "fair_night"
    case heavyrain = "heavyrain"
    case lightrain = "lightrain"
    case lightrainshowersDay = "lightrainshowers_day"
    case lightrainshowersNight = "lightrainshowers_night"
    case partlycloudyDay = "partlycloudy_day"
    case partlycloudyNight = "partlycloudy_night"
    case rain = "rain"
    case rainshowersDay = "rainshowers_day"
    case rainshowersNight = "rainshowers_night"
}

// MARK: - NextHours
struct NextHours: Codable {
    let summary: Summary
    let details: Next1_HoursDetails
}

// MARK: - Next1_HoursDetails
struct Next1_HoursDetails: Codable {
    let precipitationAmount: Double

    enum CodingKeys: String, CodingKey {
        case precipitationAmount = "precipitation_amount"
    }
}
