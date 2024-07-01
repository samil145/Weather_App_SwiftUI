//
//  WeatherMainViewModel+Ext.swift
//  Weather-SwiftUI
//
//  Created by Shamil Bayramli on 31.05.24.
//

import SwiftUI

extension WeatherMainViewModel
{
    
    func getForecasts() {
        isLoading = true // Start loading

        Task {
            var hourlySuccess = false
            var dailySuccess = false
            var minuteSuccess = false
            
            await getDailyForecast(success: &dailySuccess)
            await getMinuteForecast(success: &minuteSuccess)
            await getHourlyForecast(success: &hourlySuccess)
            
            // All data fetching is done, stop loading
            isLoading = false
            isInitialLoad = false
            
            if hourlySuccess && dailySuccess && minuteSuccess
            {
                isNoConnection = false
            }
            else
            {
                isNoConnection = true
            }
            
            isRetryLoading = false
        }
    }

    
    
    
    
    func getHourlyForecast(success: inout Bool) async
    {
        
            do
            {
                hourlyForecast = try await NetworkManager.shared.getHourlyForecast(latitude: locationManager.location?.coordinate.latitude, longitude: locationManager.location?.coordinate.longitude)
                
                print("longitute \(locationManager.location?.coordinate.longitude ?? 0)")
                print("latitude \(locationManager.location?.coordinate.latitude ?? 0)")
                
                guard var hourlyForecast_ = self.hourlyForecast else { return }
                let index = findCurrentTimeIndexHourly(hourlyForecast: hourlyForecast_)
                
                hourlyForecast_.time = hourlyForecast_.time[index...index+23].compactMap {formatTime($0)}
                hourlyForecast_.temperature_2m = hourlyForecast_.temperature_2m[index...index+23].compactMap {$0}
                hourlyForecast_.precipitation_probability = hourlyForecast_.precipitation_probability[index...index+23].compactMap {$0}
                hourlyForecast_.is_day = hourlyForecast_.is_day[index...index+23].compactMap {$0}
                
                //precipitation = hourlyForecast_.precipitation_probability[index]
                
                hourlyForecast = hourlyForecast_
                
                success = true
            
                
            } catch
            {
                print("View Model Get Hourly Forecast Does Not Work")
                if let error = error as? Errors
                {
                    switch error {
                    case .invalidURL:
                        isNoConnection = true
                    case .invalidResponse:
                        isNoConnection = true
                    case .invalidData:
                        isNoConnection = true
                    case .unableToComplete:
                        isNoConnection = true
                    }
                } else
                {
                    isNoConnection = true
                }
                isNoConnection = true
                print("View Model Get Hourly Forecast Does Not Work")
            }
        
    }
    
    func getMinuteForecast(success: inout Bool) async
    {

            do
            {
                minuteForecast = try await NetworkManager.shared.getMinuteForecast(latitude: locationManager.location?.coordinate.latitude, longitude: locationManager.location?.coordinate.longitude)
                
                guard let minuteForecast_ = self.minuteForecast else { return }
                let index = findCurrentTimeIndexMinute(minuteForecast: minuteForecast_)
                
                minuteEntry = MinutelyForecastEntry(time: formatTime(minuteForecast_.time[index]),
                                                    temperature_2m: minuteForecast_.temperature_2m[index],
                                                    weather_code: minuteForecast_.weather_code[index],
                                                    relative_humidity_2m: minuteForecast_.relative_humidity_2m[index],
                                                    apparent_temperature: minuteForecast_.apparent_temperature[index],
                                                    wind_speed_10m: minuteForecast_.wind_speed_10m[index],
                                                    precipitation: minuteForecast_.precipitation[index],
                                                    wind_direction_10m: minuteForecast_.wind_direction_10m[index],
                                                    weather_situation: weatherCodeToSituation(weatherCode: minuteForecast_.weather_code[index]),
                                                    
                                                    isSunset: isSunsetMinuteForecast(minuteTimeString: minuteForecast_.time[index],
                                                                                     sunriseString: dailyForecastEntries[0].sunrise,
                                                                                     sunsetString: dailyForecastEntries[0].sunset).0,
                                                    
                                                    isDay: isDayMinuteForecast(minuteTimeString: minuteForecast_.time[index],
                                                                               sunriseString: dailyForecastEntries[0].sunrise,
                                                                               sunsetString: dailyForecastEntries[0].sunset),
                                                    
                                                    iconName: isSunsetMinuteForecast(minuteTimeString: minuteForecast_.time[index],
                                                                                     sunriseString: dailyForecastEntries[0].sunrise,
                                                                                     sunsetString: dailyForecastEntries[0].sunset).0 ?  isSunsetMinuteForecast(minuteTimeString: minuteForecast_.time[index],
                                                                                                                                                               sunriseString: dailyForecastEntries[0].sunrise,
                                                                                                                                                               sunsetString: dailyForecastEntries[0].sunset).1 : weatherCodeToImageName(weatherCode: minuteForecast_.weather_code[index], isDay: isDayMinuteForecast(minuteTimeString: minuteForecast_.time[index],
                                                                                                                                                                  sunriseString: dailyForecastEntries[0].sunrise,
                                                                                                                                                                  sunsetString: dailyForecastEntries[0].sunset)))
                
                backgroundView = backgroundViewSetter(weatherCode: minuteEntry.weather_code, isDay: minuteEntry.isDay, isSunset: minuteEntry.isSunset)
                
                success = true
                
                print(minuteForecast_.wind_speed_10m[index])
                
                
            } catch
            {
                print("View Model Get Hourly Forecast Does Not Work")
                if let error = error as? Errors
                {
                    switch error {
                    case .invalidURL:
                        isNoConnection = true
                    case .invalidResponse:
                        isNoConnection = true
                    case .invalidData:
                        isNoConnection = true
                    case .unableToComplete:
                        isNoConnection = true
                    }
                } else
                {
                    isNoConnection = true
                }
                isNoConnection = true
                print("View Model Get Hourly Forecast Does Not Work")
            }
        
    }
    
    func getDailyForecast(success: inout Bool) async
    {
            do
            {
                dailyForecast = try await NetworkManager.shared.getDailyForecast(latitude: locationManager.location?.coordinate.latitude, longitude: locationManager.location?.coordinate.longitude)
                
                success = true
                
            } catch
            {
                print("View Model Get Hourly Forecast Does Not Work")
                if let error = error as? Errors
                {
                    switch error {
                    case .invalidURL:
                        isNoConnection = true
                    case .invalidResponse:
                        isNoConnection = true
                    case .invalidData:
                        isNoConnection = true
                    case .unableToComplete:
                        isNoConnection = true
                    }
                } else
                {
                    isNoConnection = true
                }
                isNoConnection = true
                print("View Model Get Hourly Forecast Does Not Work")
            }
        
    }

    
    // MARK: Formatting And Sorting Time and Temperature
    private func formatTime(_ iso8601String: String) -> String
    {
        let dateISOFormatter = DateFormatter()
        dateISOFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        if let date = dateISOFormatter.date(from: iso8601String) {
            return dateFormatter.string(from: date)
        } else {
            print("Failed to parse date: \(iso8601String)")
        }
        
        return ""
    }

    private func findCurrentTimeIndexHourly(hourlyForecast: HourlyData) -> Int {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        let currentDate = Date()

        for (index, timeString) in hourlyForecast.time.enumerated() {
            if let date = isoFormatter.date(from: timeString) ?? convertFromISODate(from: timeString) {
                if date == currentDate {
                    return index + 1
                } else if date >= currentDate {
                    return index
                }
            }
        }

        return 0
    }
    
    private func findCurrentTimeIndexMinute(minuteForecast: MinuteData) -> Int {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        let currentDate = Date()

        for (index, timeString) in minuteForecast.time.enumerated() {
            if let date = isoFormatter.date(from: timeString) ?? convertFromISODate(from: timeString), date >= currentDate {
                return index
            }
        }

        return 0
    }
    
    
    private func isSunsetMinuteForecast(minuteTimeString: String, sunriseString: String, sunsetString: String) -> (Bool, String) {
//        if let minuteTime = convertForSunset(from: minuteTimeString), let sunrise = convertForSunset(from: sunriseString), let sunset = convertForSunset(from: sunsetString)
//        {
//            if minuteTime == sunset
//            {
//                return (true, "sunset.fill")
//            } else if minuteTime == sunrise
//            {
//                return (true, "sunrise.fill")
//            }
//            else
//            {
//                return (false,"")
//            }
//        }
//        
//        return (false, "")
        
        guard let minuteTime = convertFromISODate(from: minuteTimeString),
                  let sunrise = convertFromISODate(from: sunriseString),
                  let sunset = convertFromISODate(from: sunsetString) else {
                return (false, "")
            }
            
            let calendar = Calendar.current
            
            let sunriseStart = calendar.date(byAdding: .minute, value: -5, to: sunrise)!
            let sunriseEnd = calendar.date(byAdding: .minute, value: 5, to: sunrise)!
            let sunsetStart = calendar.date(byAdding: .minute, value: -5, to: sunset)!
            let sunsetEnd = calendar.date(byAdding: .minute, value: 5, to: sunset)!
            
            if sunriseStart <= minuteTime && minuteTime <= sunriseEnd {
                return (true, "sunrise.fill")
            } else if sunsetStart <= minuteTime && minuteTime <= sunsetEnd {
                return (true, "sunset.fill")
            } else {
                return (false, "")
            }
    }
    
    private func isSunsetHourForecast(hourTimeString: String, sunriseString: String, sunsetString: String) -> (Bool, String) {
        
//        guard let hourTime = convertForSunset(from: hourTimeString),
//                let sunrise = convertForSunset(from: sunriseString),
//                let sunset = convertForSunset(from: sunsetString) else { return (false, "") }
//            
//        if hourTime == sunrise {
//            return (true, "sunrise.fill")
//        } else if hourTime == sunset {
//            return (true, "sunset.fill")
//        } else {
//            return (false, "")
//        }
        
//        guard let hourlyTime = convertForSunsetHour(from: hourTimeString),
//              let sunrise = convertForSunsetHour(from: sunriseString),
//              let sunset = convertForSunsetHour(from: sunsetString) else { return (false, "") }
//            
//        let calendar = Calendar.current
//        let hourlyHour = calendar.component(.hour, from: hourlyTime)
//        let sunriseHour = calendar.component(.hour, from: sunrise)
//        let sunsetHour = calendar.component(.hour, from: sunset)
//            
//        if hourlyHour == sunriseHour {
//            return (true, "sunrise.fill")
//        } else if hourlyHour == sunsetHour {
//            return (true, "sunset.fill")
//        } else {
//            return (false, "")
//        }
//        
        guard let hourlyHour = Int(hourTimeString.prefix(2)) else {
            return (false, "")
        }

        // Extract the hour from the sunrise and sunset strings
        guard let sunriseDate = convertFromISODate(from: sunriseString), let sunsetDate = convertFromISODate(from: sunsetString) else { return (false, "") }
            
        let calendar = Calendar.current
        let sunriseHour = calendar.component(.hour, from: sunriseDate)
        let sunsetHour = calendar.component(.hour, from: sunsetDate)

        if hourlyHour == sunriseHour {
            return (true, "sunrise.fill")
        } else if hourlyHour == sunsetHour {
            return (true, "sunset.fill")
        } else {
            return (false, "")
        }

    }
    
    
    
    private func isDayMinuteForecast(minuteTimeString: String, sunriseString: String, sunsetString: String) -> Bool {
        if let minuteTime = convertFromISODate(from: minuteTimeString), let sunrise = convertFromISODate(from: sunriseString), let sunset = convertFromISODate(from: sunsetString)
        {
            if sunrise < minuteTime, minuteTime < sunset
            {
                return true
            }
            else
            {
                return false
            }
        }
        
        return true
    }
    
    

    
    func formatToWeekday(_ iso8601String: String) -> String {
        let dateISOFormatter = DateFormatter()
        dateISOFormatter.dateFormat = "yyyy-MM-dd"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE"

        if let date = dateISOFormatter.date(from: iso8601String) {
            return dateFormatter.string(from: date)
        } else {
            print("Failed to parse date: \(iso8601String)")
        }

        return ""
    }
    
    private func formatTimeDaily(_ iso8601String: String) -> String
    {
        let dateISOFormatter = DateFormatter()
        dateISOFormatter.dateFormat = "yyyy-MM-dd"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM"
        
        if let date = dateISOFormatter.date(from: iso8601String) {
            return dateFormatter.string(from: date)
        } else {
            print("Failed to parse date: \(iso8601String)")
        }
        
        return ""
    }


    private func convertFromISODate(from iso8601String: String) -> Date? {
        let fallbackFormatter = DateFormatter()
        fallbackFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
        return fallbackFormatter.date(from: iso8601String)
    }
    
    private func convertForSunset(from iso8601String: String) -> Date? {
        let fallbackFormatter = DateFormatter()
        fallbackFormatter.dateFormat = "HH"
        return fallbackFormatter.date(from: iso8601String)
    }
    
    private func convertForSunsetHour(from iso8601String: String) -> Date? {
        let fallbackFormatter = DateFormatter()
        fallbackFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return fallbackFormatter.date(from: iso8601String)
    }
    
    
    private func weatherCodeToImageName(weatherCode: Int, isDay: Bool) -> String
    {
        switch weatherCode
        {
        case 0:
            return isDay ? "sun.max.fill" : "moon.stars.fill"
            
        case 1:
            return isDay ? "cloud.sun.fill" : "cloud.moon.fill"
            
        case 2:
            return "cloud.fill"
            
        case 3:
            return "smoke.fill"
            
        case 45, 48:
            return "cloud.fog.fill"
            
        case 51, 53, 55, 56, 57:
            return "cloud.drizzle.fill"
            
        case 61, 63, 65:
            return "cloud.rain.fill"
            
        case 66, 67:
            return "cloud.heavyrain.fill"
            
        case 71, 73, 75:
            return "cloud.snow.fill"
            
        case 77:
            return "snowflake"
            
        case 80, 81, 82:
            return isDay ? "cloud.sun.rain.fill" : "cloud.moon.rain.fill"
            
        case 85, 86:
            return isDay ? "sun.snow.fill" : "cloud.snow.fill"
            
        case 95:
            return "cloud.bolt.fill"
            
        case 96, 99:
            return "cloud.bolt.rain.fill"
            
            

        default:
            return isDay ? "sun.max.fill" : "moon.stars.fill"
        }
    }
    
    private func weatherCodeToSituation(weatherCode: Int) -> String
    {
        switch weatherCode
        {
        case 0:
            return "Clear"
            
        case 1:
            return "Mostly Clear"
            
        case 2:
            return "Partly Cloudy"
            
        case 3:
            return "Mostly Cloudy"
            
        case 45:
            return "Foggy"
            
        case 48:
            return "Rime Fog"
            
        case 51:
            return "Light Drizzle"
            
        case 53:
            return "Drizzle"
            
        case 55:
            return "Heavy Drizzle"
            
        case 56:
            return "Light Freezing Drizzle"
            
        case 57:
            return "Freezing Drizzle"
            
        case 61:
            return "Light Rain"
            
        case 63:
            return "Rain"
            
        case 65:
            return "Heavy Rain"
            
        case 66:
            return "Light Freezing Rain"
            
        case 67:
            return "Freezing Rain"
            
        case 71:
            return "Light Snow"
            
        case 73:
            return "Snow"
            
        case 75:
            return "Heavy Snow"
            
        case 77:
            return "Snow Grains"
            
        case 80:
            return "Light Showers"
            
        case 81:
            return "Showers"
            
        case 82:
            return "Heavy Showers"
            
        case 85:
            return "Light Snow Showers"
            
        case 86:
            return "Snow Showers"
            
        case 95:
            return "Thunderstorm"
            
        case 96:
            return "Light Thunderstorms With Hail"
            
        case 99:
            return "Thunderstorm With Hail"
            
            

        default:
            return "Clear"
        }
    }
    
    
    var hourlyForecastEntries: [HourlyForecastEntry] {
        guard let hourlyForecast = hourlyForecast, !dailyForecastEntries.isEmpty else { return [] }
            
        var entries: [HourlyForecastEntry] = []
            
        for i in 0..<hourlyForecast.time.count {
            let time = hourlyForecast.time[i]
            let temperature = hourlyForecast.temperature_2m[i]
            let weatherCode = hourlyForecast.weather_code[i]
            let precipitation = hourlyForecast.precipitation_probability[i]
            let is_day = hourlyForecast.is_day[i] == 1 ? true : false
            let iconName = isSunsetHourForecast(hourTimeString: hourlyForecast.time[i],
                                                sunriseString: dailyForecastEntries[0].sunrise,
                                                sunsetString: dailyForecastEntries[0].sunset).0 && !isSunsetMinuteForecast(minuteTimeString: minuteEntry.time,
                                                                                                                          sunriseString: dailyForecastEntries[0].sunrise,
                                                                                                                          sunsetString: dailyForecastEntries[0].sunset).0 ?
            isSunsetHourForecast(hourTimeString: hourlyForecast.time[i],
                                                sunriseString: dailyForecastEntries[0].sunrise,
                                                sunsetString: dailyForecastEntries[0].sunset).1 :
            weatherCodeToImageName(weatherCode: weatherCode, isDay: is_day)
            
            entries.append(HourlyForecastEntry(time: time, temperature: temperature, weather_code: weatherCode, precipitation_probability: precipitation, is_day: is_day, iconName: iconName))
        }
            
        return entries
    }
    
    var dailyForecastEntries: [DailyForecastEntry] {
        guard let dailyForecast = dailyForecast else { return [] }
            
        var entries: [DailyForecastEntry] = []
            
        for i in 0..<dailyForecast.time.count {
            
            let time = formatTimeDaily(dailyForecast.time[i])
            let temperature_max = dailyForecast.temperature_2m_max[i]
            let temperature_min = dailyForecast.temperature_2m_min[i]
            let weatherCode = dailyForecast.weather_code[i]
            let wind_speed = dailyForecast.wind_speed_10m_max[i]
            let wind_direction = dailyForecast.wind_direction_10m_dominant[i]
            let weekday = formatToWeekday(dailyForecast.time[i])
            let sunset = dailyForecast.sunset[i]
            let sunrise = dailyForecast.sunrise[i]
            let iconName = weatherCodeToImageName(weatherCode: weatherCode, isDay: true)
            
            entries.append(DailyForecastEntry(time: time, temperature_max: temperature_max, temperature_min: temperature_min, weather_code: weatherCode, wind_speed: wind_speed, wind_direction: wind_direction, weekday: weekday, sunset: sunset, sunrise: sunrise, iconName: iconName))
        }
        
        return entries
    }
}

// MARK: Entries for Forecast Data
struct HourlyForecastEntry: Identifiable {
    let id = UUID()
    let time: String
    let temperature: Double
    let weather_code: Int
    let precipitation_probability: Int
    let is_day: Bool
    let iconName: String
}

struct DailyForecastEntry: Identifiable {
    let id = UUID()
    let time: String
    let temperature_max: Float
    let temperature_min: Float
    let weather_code: Int
    let wind_speed: Float
    let wind_direction: Int
    let weekday: String
    let sunset: String
    let sunrise: String
    let iconName: String
}

struct MinutelyForecastEntry: Identifiable {
    let id = UUID()
    var time: String
    var temperature_2m: Double
    var weather_code: Int
    var relative_humidity_2m: Int
    var apparent_temperature: Float
    var wind_speed_10m: Float
    var precipitation: Float
    var wind_direction_10m: Int
    var weather_situation: String
    var isSunset: Bool
    var isDay: Bool
    var iconName: String
    
    init(time: String, temperature_2m: Double, weather_code: Int, relative_humidity_2m: Int, apparent_temperature: Float, wind_speed_10m: Float, precipitation: Float, wind_direction_10m: Int, weather_situation: String, isSunset: Bool, isDay: Bool, iconName: String) {
        self.time = time
        self.temperature_2m = temperature_2m
        self.weather_code = weather_code
        self.relative_humidity_2m = relative_humidity_2m
        self.apparent_temperature = apparent_temperature
        self.wind_speed_10m = wind_speed_10m
        self.precipitation = precipitation
        self.wind_direction_10m = wind_direction_10m
        self.weather_situation = weather_situation
        self.isDay = isDay
        self.iconName = iconName
        self.isSunset = isSunset
    }
    
    init() {
        self.time = "Now"
        self.temperature_2m = 0
        self.weather_code = 0
        self.relative_humidity_2m = 0
        self.apparent_temperature = 0
        self.wind_speed_10m = 0
        self.precipitation = 0
        self.wind_direction_10m = 0
        self.weather_situation = "Clear"
        self.isDay = true
        self.iconName = ""
        self.isSunset = false
    }
}
