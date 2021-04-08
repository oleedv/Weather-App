



import Foundation

//MARK:- Model
class WeatherData {
    
    var air_pressure_at_sea_level:Double?
    var air_temperature:Double?
    var cloud_area_fraction:Double?
    var relative_humidity:Double?
    var wind_from_direction:Double?
    var wind_speed:Double?
    
    var next_1_symbol_code:String?
    var next_12_symbol_code:String?
    var next_6_symbol_code:String?
    
    var next_1_precipitation_amount:Double?
    var next_12_precipitation_amount:Double?
    var next_6_precipitation_amount:Double?
    
    var air_pressure_at_sea_levelUnit = ""
    var air_temperatureUnit = ""
    var cloud_area_fractionUnit = ""
    var precipitation_amountUnit = ""
    var relative_humidityUnit = ""
    var wind_from_directionUnit = ""
    var wind_speedUnit = ""
    
    init(air_pressure_at_sea_level:Double,air_temperature:Double,cloud_area_fraction:Double,relative_humidity:Double,wind_from_direction:Double,wind_speed:Double,next_1_symbol_code:String,next_12_symbol_code:String,next_6_symbol_code:String,next_12_precipitation_amount:Double,next_1_precipitation_amount:Double,next_6_precipitation_amount:Double,air_pressure_at_sea_levelUnit:String,air_temperatureUnit:String,cloud_area_fractionUnit:String,precipitation_amountUnit:String,relative_humidityUnit:String,wind_from_directionUnit:String,wind_speedUnit:String) {
        
        self.air_pressure_at_sea_level = air_pressure_at_sea_level
        self.air_temperature = air_temperature
        self.cloud_area_fraction = cloud_area_fraction
        self.relative_humidity = relative_humidity
        self.wind_from_direction = wind_from_direction
        self.wind_speed = wind_speed
        self.next_1_symbol_code = next_1_symbol_code
        self.next_12_symbol_code = next_12_symbol_code
        self.next_6_symbol_code = next_6_symbol_code
        
        self.next_1_precipitation_amount = next_1_precipitation_amount
        self.next_12_precipitation_amount = next_12_precipitation_amount
        self.next_6_precipitation_amount = next_6_precipitation_amount
        
        self.air_pressure_at_sea_levelUnit = air_pressure_at_sea_levelUnit
        self.air_temperatureUnit = air_temperatureUnit
        self.cloud_area_fractionUnit = cloud_area_fractionUnit
        self.relative_humidityUnit = relative_humidityUnit
        self.wind_from_directionUnit = wind_from_directionUnit
        self.wind_speedUnit = wind_speedUnit
        
    }
}
class NextxHours {
    var precipitation_amount:Double?
    var symbol_code:Double?
    
}
