//
//  WeatherMainViewModel.swift
//  Weather-SwiftUI
//
//  Created by Shamil Bayramli on 28.05.24.
//

import SwiftUI

@MainActor final class WeatherMainViewModel: ObservableObject, LocationManagerDelegate
{
    @Published var locationManager = LocationManager()
    @Published var hourlyForecast: HourlyData?
    @Published var minuteForecast: MinuteData?
    @Published var dailyForecast: DailyData?
    @Published var longitude: Double?
    @Published var latitude: Double?
    @Published var minuteEntry = MinutelyForecastEntry()
    @Published var locationText = "Unknown"
    @Published var precipitation = 0
    @Published var backgroundView: AnyView?
    @Published var isLoading = true
    @Published var isInitialLoad = true
    @Published var isNoConnection = false
    @Published var isRetryLoading = false
    @Published var isDailyExpanded = false
    
    //var index = 0
    
    init() {
        locationManager.delegate = self
    }
    
    func didUpdateLocationText(_ locationText: String) {
        isLoading = true
        self.locationText = locationText
        getForecasts()
        print("\(locationText)")
    }
    
    func didGiveError(error: Errors) {
        isNoConnection = true
        isRetryLoading = false
    }
    
    func recreateLocationManager() {
        self.locationManager = LocationManager()
        self.locationManager.delegate = self
    }
    
    
    
    func backgroundViewSetter(weatherCode: Int, isDay: Bool, isSunset: Bool) -> AnyView
    {
        if (isSunset && weatherCode == 0 && weatherCode == 1 && weatherCode == 2 && weatherCode == 3)
        {
            return AnyView(Image("sunset_2").resizable().aspectRatio(contentMode: .fill).ignoresSafeArea(.all).brightness(-0.05))
        }
        
        switch  weatherCode
        {
        case 0, 1:
            return isDay ? AnyView(Image("clean_day").resizable().aspectRatio(contentMode: .fill).ignoresSafeArea(.all)) : AnyView(Image("starry_night").resizable().aspectRatio(contentMode: .fill).ignoresSafeArea(.all))
            
        case 2:
            return isDay ? AnyView(Image("day_cloudy").resizable().aspectRatio(contentMode: .fill).ignoresSafeArea(.all).brightness(-0.08)) : AnyView(Image("night_cloudy").resizable().aspectRatio(contentMode: .fill).ignoresSafeArea(.all).brightness(-0.05))
            
        case 3:
            return isDay ? AnyView(Image("day_most_cloudy_3").resizable().aspectRatio(contentMode: .fill).ignoresSafeArea(.all).brightness(-0.25)) : AnyView(Image("night_most_cloudy").resizable().aspectRatio(contentMode: .fill).ignoresSafeArea(.all))
            
        case 45, 48:
            return AnyView(Image("foggy").resizable().aspectRatio(contentMode: .fill).ignoresSafeArea(.all).brightness(-0.1))
            
        case 51, 53, 55, 56, 57, 61, 63, 65, 66, 67, 80, 81, 82:
            return AnyView(Image("rain").resizable().aspectRatio(contentMode: .fill).ignoresSafeArea(.all))
            
        case 71, 73, 75, 77, 85, 86:
            return AnyView(Image("snow").resizable().aspectRatio(contentMode: .fill).ignoresSafeArea(.all))
            
        case 95, 96, 99:
            return AnyView(Image("thunderstorm_2").resizable().aspectRatio(contentMode: .fill).ignoresSafeArea(.all))
            
        default:
            return isDay ? AnyView(Image("clean_day").resizable().aspectRatio(contentMode: .fill).ignoresSafeArea(.all)) : AnyView(Image("starry_night").resizable().aspectRatio(contentMode: .fill).ignoresSafeArea(.all))
        }
    }
    
    var backgroundViewEntry: AnyView
    {
        guard let backgroundView else { return AnyView(Color.accentColor) }
        return backgroundView
    }
}
