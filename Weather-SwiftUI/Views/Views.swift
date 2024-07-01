//
//  Views.swift
//  Weather-SwiftUI
//
//  Created by Shamil Bayramli on 27.05.24.
//

import SwiftUI
import Charts

struct WeatherDayViewDaily: View {
    
    var animationID: String
    var titleNamespace: Namespace.ID
    var iconNamespace: Namespace.ID
    var tempAnimation: Namespace.ID
    var dayOfWeek: String
    var imageName: String
    var maxTemp: Int
    var minTemp: Int
    
    
    var body: some View {
        VStack
        {
            Text(dayOfWeek)
                .font(.system(size: 19, weight: .semibold))
                .foregroundStyle(.white)
                .matchedGeometryEffect(id: animationID, in: titleNamespace)
            
            Image(systemName: imageName)
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 55, height: 55)
                .matchedGeometryEffect(id: animationID, in: iconNamespace)
            
            HStack
            {
                peakTempDaily(maxTemp: maxTemp, minTemp: minTemp)
                    .matchedGeometryEffect(id: animationID, in: tempAnimation)
            }
        }
    }
}

struct WeatherDayViewDailyExpanded: View {
    
    var animationID: String
    var titleNamespace: Namespace.ID
    var iconNamespace: Namespace.ID
    var dayOfWeek: String
    var imageName: String
    
    var body: some View {
        VStack
        {
            Text(dayOfWeek)
                .font(.system(size: 19, weight: .semibold))
                .foregroundStyle(.white)
                .matchedGeometryEffect(id: animationID, in: titleNamespace)
            
            Image(systemName: imageName)
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 55, height: 55)
                .matchedGeometryEffect(id: animationID, in: iconNamespace)
        }
    }
}

struct WeatherDayViewHourly: View {
    
    var dayOfWeek: String
    var imageName: String
    var temperature: Double
    
    
    var body: some View {
        VStack
        {
            Text(dayOfWeek)
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(.white)

            Image(systemName: imageName)
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 55, height: 55)

            Text("\(Int(temperature))°")
                .font(.system(size: 22, weight: .medium))
                .foregroundStyle(.white)
        }
    }
}

struct BackgroundView: View {
    
    @Binding var isNight: Bool
    
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [isNight ? Color("qaravari") : Color("Goyvari"),
                                                   isNight ? Color("qaravari2") : Color("Goyvari")]),
                       startPoint: .top,
                       endPoint: .bottom)
        .ignoresSafeArea(edges: .all)
    }
}

struct CityTextView: View {
    
    var cityName: String
    
    var body: some View {
        Text(cityName)
            .font(.system(size: 32, weight: .medium, design: .default))
            .foregroundStyle(.white)
            .padding()
    }
}

struct MainWeatherStatusView: View {
    
    var imageName: String
    var temperature: Double
    var situation: String
    var maxTemp: Int
    var minTemp: Int
    
    var body: some View {
        VStack(spacing: 8)
        {
            Image(systemName: imageName)
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 150, height: 150)
                
            
            Text("\(Int(temperature))°")
                .font(.system(size: 60, weight: .medium))
                .foregroundStyle(.white)
                .offset(x: 10)

            
            Text("\(situation)")
                .font(.system(size: 25, weight: .medium))
                .foregroundStyle(.white)
                .padding(.bottom,10)
                
            peakTemp(maxTemp: maxTemp, minTemp: minTemp)
            
        }
        .padding(.bottom, 40)
    }
}

struct peakTemp: View {
    
    var maxTemp: Int
    var minTemp: Int
    
    var body: some View {
        HStack
        {
            Image(systemName: "arrowtriangle.up.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 15, height: 15)
                .foregroundStyle(.pink)
            
            Text("\(maxTemp)°C")
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(.white)
            
            Divider()
            
            Image(systemName: "arrowtriangle.down.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 15, height: 15)
                .foregroundStyle(Color("lightGreen"))
            
            Text("\(minTemp)°C")
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(.white)
        }
    }
}

struct peakTempDaily: View {
    
    var maxTemp: Int
    var minTemp: Int
    
    var body: some View {
        Text("\(maxTemp)° / \(minTemp)°")
            .font(.system(size: 16, weight: .semibold))
            .foregroundStyle(.white)
    }
}

struct GridElement: View {
    
    var title: String
    var indicator: String
    var imageName: String
    
    var body: some View {
        VStack
        {
            VStack(alignment: .leading)
            {
                HStack
                {
                    Text(title)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(.agvari)
                    Spacer()
                }
                .padding(.bottom, 1)
                
                HStack
                {
                    Text(indicator)
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundStyle(.white)
                    Spacer()
                }
                
                Spacer()
                
                HStack
                {
                    Spacer()
                    
                    Image(systemName: imageName)
                        .renderingMode(.original)
                        .symbolRenderingMode(.multicolor)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundStyle(.accent)
                        .frame(width: 70, height: 70)
                }
            }
            .padding([.top, .bottom, .trailing], 15)
            .padding(.leading, 20)
            .frame(width: UIScreen.main.bounds.width/2 - 15, height: 180)
            .background
            {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(.black.shadow(.drop(radius: 2)))
                    .opacity(0.3)
            }
        }
    }
}

struct chartDaily: View {
    
    let dailyForecast: [DailyForecastEntry]
    let isTempMax: Bool
    
    var body: some View {
        Chart(dailyForecast) { data in
            LineMark(
                x: .value("Day", data.time),
                y: .value("Temp", isTempMax ? data.temperature_max : data.temperature_min)
            )
            .foregroundStyle(.gozeCarpanGoy)
            .interpolationMethod(.linear)

            
            PointMark(
                x: .value("Day", data.time),
                y: .value("Temp", isTempMax ? data.temperature_max : data.temperature_min)
            )
            
            .symbol {
                
                Circle()
                    .frame(width: 7, height: 7)
                    .foregroundStyle(Color.mint)
            }
            .annotation(position: .top) {
                Text("\(Int(isTempMax ? data.temperature_max : data.temperature_min))°")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(4)
            }
        }
        .chartXAxis(.hidden)
        .chartYAxis(.hidden)
        .frame(height: 60)
        .brightness(0.3)
        .padding([.leading, .trailing], -10)
    }
}

struct chartHourly: View {
    
    let hourlyForecast: [HourlyForecastEntry]
    
    var body: some View {
        Chart(hourlyForecast) { data in
            LineMark(
                x: .value("Hour", data.time),
                y: .value("Temp", data.temperature)
            )
            .foregroundStyle(.gozeCarpanGoy)
            .interpolationMethod(.catmullRom)
            
            AreaMark(
                x: .value("Hour", data.time),
                y: .value("Temp", data.temperature)
            )
            .foregroundStyle(LinearGradient(gradient: Gradient(colors: [Color(.altgoy), Color(.clear)]),
                                            startPoint: .top,
                                            endPoint: UnitPoint(x: 0.5, y: 0.8)))
            .interpolationMethod(.catmullRom)
            
        }
        .chartXAxis(.hidden)
        .chartYAxis(.hidden)
        .frame(height: 50)
        .padding([.leading, .trailing], -25)
    }
}

struct extentButton: View {
    
    let imageName: String
    let animationID: String
    let namespace: Namespace.ID
    
    var body: some View {
        Image(systemName: imageName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .foregroundStyle(.white)
            .frame(width: 20, height: 20)
            .matchedGeometryEffect(id: animationID, in: namespace)
    }
}



