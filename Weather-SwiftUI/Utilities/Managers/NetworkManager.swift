//
//  NetworkManager.swift
//  Weather-SwiftUI
//
//  Created by Shamil Bayramli on 28.05.24.
//

import Foundation

final class NetworkManager
{
    static let shared = NetworkManager()

    private var hourlyURL: String?
    
    private var minuteURL: String?
    
    private var dailyURL: String?
    
    private init() {}
    
    func getHourlyForecast(latitude: Double?, longitude: Double?) async throws -> HourlyData
    {
        guard let latitude = latitude else { throw Errors.unableToComplete }
        guard let longitude = longitude else { throw Errors.unableToComplete }
        
        hourlyURL = "https://api.open-meteo.com/v1/forecast?latitude=\(latitude)&longitude=\(longitude)&hourly=temperature_2m&hourly=weather_code&hourly=precipitation_probability&hourly=is_day&timezone=Asia/Baku"
        
        guard let url = URL(string: hourlyURL!) else
        {
            print("URL Error")
            throw Errors.invalidURL
        }
        
        
        
        do
        {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            return try decoder.decode(WeatherHourlyData.self, from: data).hourly
        } catch
        {
            print("do catch error")
            throw Errors.invalidData
        }
    }
    
    func getMinuteForecast(latitude: Double?, longitude: Double?) async throws -> MinuteData
    {
        guard let latitude = latitude else { throw Errors.unableToComplete }
        guard let longitude = longitude else { throw Errors.unableToComplete }
        
        minuteURL = "https://api.open-meteo.com/v1/forecast?latitude=\(latitude)&longitude=\(longitude)&minutely_15=temperature_2m&minutely_15=weather_code&minutely_15=relative_humidity_2m&minutely_15=apparent_temperature&minutely_15=wind_speed_10m&minutely_15=precipitation&minutely_15=wind_direction_10m&timezone=Asia/Baku"
        
        guard let url = URL(string: minuteURL!) else
        {
            print("URL Error")
            throw Errors.invalidURL
        }
        
        
        do
        {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            return try decoder.decode(WeatherMinuteData.self, from: data).minutely_15
        } catch
        {
            print("do catch error")
            throw Errors.invalidData
        }
    }
    
    func getDailyForecast(latitude: Double?, longitude: Double?) async throws -> DailyData
    {
        guard let latitude = latitude else { throw Errors.unableToComplete }
        guard let longitude = longitude else { throw Errors.unableToComplete }
        
        dailyURL = "https://api.open-meteo.com/v1/forecast?latitude=\(latitude)&longitude=\(longitude)&forecast_days=5&daily=temperature_2m_max&daily=temperature_2m_min&daily=weather_code&daily=wind_speed_10m_max&daily=wind_direction_10m_dominant&daily=sunrise&daily=sunset&timezone=Asia/Baku"
        
        guard let url = URL(string: dailyURL!) else
        {
            print("URL Error")
            throw Errors.invalidURL
        }
        
        
        
        do
        {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            return try decoder.decode(WeatherDailyData.self, from: data).daily
        } catch
        {
            print("do catch error")
            throw Errors.invalidData
        }
    }
}
