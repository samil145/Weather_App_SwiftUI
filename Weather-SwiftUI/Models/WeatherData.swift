//
//  WeatherData.swift
//  Weather-SwiftUI
//
//  Created by Shamil Bayramli on 28.05.24.
//

import Foundation

// MARK: Hourly Forecast Data
struct WeatherHourlyData: Codable
{
    var latitude: Double
    var longitude: Double
    var generationtime_ms: Double
    var utc_offset_seconds: Int
    var timezone: String
    var timezone_abbreviation: String
    var elevation: Double
    var hourly_units: HourlyUnits
    var hourly: HourlyData
}

struct HourlyUnits: Codable
{
    let time: String
    let temperature_2m: String
    let weather_code: String
    let precipitation_probability: String
    let is_day: String
}

struct HourlyData: Codable
{
    var time: [String]
    var temperature_2m: [Double]
    var weather_code: [Int]
    var precipitation_probability: [Int]
    var is_day: [Int]
}

// MARK: 15-Minute Forecast Data

struct WeatherMinuteData: Codable
{
    var latitude: Double
    var longitude: Double
    var generationtime_ms: Double
    var utc_offset_seconds: Int
    var timezone: String
    var timezone_abbreviation: String
    var elevation: Double
    var minutely_15_units: MinuteUnits
    var minutely_15: MinuteData
}

struct MinuteUnits: Codable
{
    let time: String
    let temperature_2m: String
    let weather_code: String
    let relative_humidity_2m: String
    let apparent_temperature: String
    let wind_speed_10m: String
    let precipitation: String
    let wind_direction_10m: String
}

struct MinuteData: Codable
{
    var time: [String]
    var temperature_2m: [Double]
    var weather_code: [Int]
    var relative_humidity_2m: [Int]
    var apparent_temperature: [Float]
    var wind_speed_10m: [Float]
    var precipitation: [Float]
    var wind_direction_10m: [Int]
}



// MARK: Daily Forecast Data

struct WeatherDailyData: Codable
{
    var latitude: Double
    var longitude: Double
    var generationtime_ms: Double
    var utc_offset_seconds: Int
    var timezone: String
    var timezone_abbreviation: String
    var elevation: Double
    var daily_units: DailyUnits
    var daily: DailyData
}

struct DailyUnits: Codable
{
    let time: String
    let temperature_2m_max: String
    let temperature_2m_min: String
    let weather_code: String
    let wind_speed_10m_max: String
    let wind_direction_10m_dominant: String
    let sunrise: String
    let sunset: String
}

struct DailyData: Codable
{
    var time: [String]
    var temperature_2m_max: [Float]
    var temperature_2m_min: [Float]
    var weather_code: [Int]
    var wind_speed_10m_max: [Float]
    var wind_direction_10m_dominant: [Int]
    var sunrise: [String]
    var sunset: [String]
}
