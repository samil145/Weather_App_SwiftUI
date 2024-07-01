//
//  ContentView.swift
//  Weather-SwiftUI
//
//  Created by Shamil Bayramli on 13.05.24.
//

import SwiftUI
import Charts


struct WeatherMainView: View {
    
    @StateObject var viewModel = WeatherMainViewModel()
    @Namespace private var titleAnimation
    @Namespace private var iconAnimation
    @Namespace private var tempAnimation
    @Namespace private var buttonAnimation
    
    let columns: [GridItem] = [GridItem(.flexible(), alignment: .leading),
                               GridItem(.flexible(), alignment: .trailing)]
    
    
    
    var body: some View {
        
        NavigationView {
            ZStack{
    
                viewModel.backgroundViewEntry
                
//                Image("sunset_2")
//                    .resizable()
//                    .aspectRatio(contentMode: .fill)
//                    .ignoresSafeArea(.all)
//                    .brightness(-0.05)
//
//                Image("clean_day")
//                    .resizable()
//                    .ignoresSafeArea(.all)
//                    .scaledToFill()
//                    .brightness(-0.0)
//
//                Image("starry_night")
//                    .resizable()
//                    .aspectRatio(contentMode: .fill)
//                    .ignoresSafeArea(.all)
//                    .brightness(0.0)
//
//                Image("day_cloudy")
//                    .resizable()
//                    .aspectRatio(contentMode: .fill)
//                    .ignoresSafeArea(.all)
//                    .brightness(-0.08)
//
//                Image("night_cloudy")
//                    .resizable()
//                    .aspectRatio(contentMode: .fill)
//                    .ignoresSafeArea(.all)
//                    .brightness(-0.05)
//
//                Image("day_most_cloudy_3")
//                    .resizable()
//                    .aspectRatio(contentMode: .fill)
//                    .ignoresSafeArea(.all)
//                    .brightness(-0.25)
             
//                Image("night_most_cloudy")
//                    .resizable()
//                    .aspectRatio(contentMode: .fill)
//                    .ignoresSafeArea(.all)
//                    .brightness(0.0)

//
//                Image("foggy")
//                    .resizable()
//                    .aspectRatio(contentMode: .fill)
//                    .ignoresSafeArea(.all)
//                    .brightness(-0.1)
//
//                Image("rain")
//                    .resizable()
//                    .aspectRatio(contentMode: .fill)
//                    .ignoresSafeArea(.all)
//                    .brightness(-0.0)
//
//                Image("snow")
//                    .resizable()
//                    .aspectRatio(contentMode: .fill)
//                    .ignoresSafeArea(.all)
//                    .brightness(-0.0)
//
//                Image("thunderstorm_2")
//                    .resizable()
//                    .aspectRatio(contentMode: .fill)
//                    .ignoresSafeArea(.all)
                    
                
                Text("\(viewModel.locationText)")
                    .font(.system(size: 20, weight: .medium, design: .default))
                    .foregroundStyle(.white)
                    .frame(maxWidth: UIScreen.main.bounds.width , maxHeight: .infinity, alignment: .top)
                    .padding(.top, -1)
                
                ScrollView(.vertical)
                {
                    VStack
                    {
                        //CityTextView(cityName: viewModel.locationText)
                        MainWeatherStatusView(imageName: viewModel.minuteEntry.iconName,
                                              temperature: viewModel.minuteEntry.temperature_2m,
                                              situation: viewModel.minuteEntry.weather_situation,
                                              maxTemp: Int(viewModel.dailyForecastEntries.first?.temperature_max ?? 0),
                                              minTemp: Int(viewModel.dailyForecastEntries.first?.temperature_min ?? 0))
                        .padding(.top, 20)
                        
                        VStack(alignment: .leading, spacing: 30)
                        {
                            HStack
                            {
                                Text("5-Day Forecast")
                                    .font(.system(size: 23, weight: .regular))
                                    .foregroundStyle(.white)
                                
                                Spacer()
                                
                                if (viewModel.isDailyExpanded)
                                {
                                    Image(systemName: "chevron.up")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .foregroundStyle(.white)
                                        .frame(width: 20, height: 20)
                                        .matchedGeometryEffect(id: "Animation Button", in: buttonAnimation)
                                        
                                } else
                                {
                                    Image(systemName: "chevron.down")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .foregroundStyle(.white)
                                        .frame(width: 20, height: 20)
                                        .matchedGeometryEffect(id: "Animation Button", in: buttonAnimation)
                                        
                                }
                            }
                            
                            
                            ScrollView(.horizontal)
                            {
                                if viewModel.isDailyExpanded
                                {
                                    VStack (spacing: 17)
                                    {
                                        HStack(spacing: 27)
                                        {
                                            
                                            WeatherDayViewDailyExpanded(animationID: "Animation 0", titleNamespace: titleAnimation, iconNamespace: iconAnimation, dayOfWeek: "Today", imageName: viewModel.dailyForecastEntries.first?.iconName ?? "cloud.sun.fill")
                                            
                                                
                                            
                                            ForEach(viewModel.dailyForecastEntries.dropFirst(), id: \.time) { entry in
                                                
                                                WeatherDayViewDailyExpanded(animationID: "Animation \(entry.time)", titleNamespace: titleAnimation, iconNamespace: iconAnimation, dayOfWeek: entry.weekday.uppercased(), imageName: entry.iconName)
                                            }
                                        }
                                        
                                        
                                        Chart(viewModel.dailyForecastEntries) { data in
                                            LineMark(
                                                x: .value("Day", data.time),
                                                y: .value("Temp", data.temperature_max)
                                            )
                                            .foregroundStyle(.altgoy)
                                            .interpolationMethod(.linear)

                                            
                                            PointMark(
                                                x: .value("Day", data.time),
                                                y: .value("Temp", data.temperature_max)
                                            )
                                            
                                            .symbol {
                                                
                                                Circle()
                                                    .frame(width: 7, height: 7)
                                                    .foregroundStyle(Color.cyan)
                                            }
                                            .annotation(position: .top) {
                                                Text("\(Int(data.temperature_max))°")
                                                    .font(.headline)
                                                    .foregroundColor(.white)
                                                    .padding(4)
                                            }
                                        }
                                        .chartXAxis(.hidden)
                                        .chartYAxis(.hidden)
                                        .frame(height: 60)
                                        .padding([.leading, .trailing], -10)
                                        
                                        
                                        Spacer()
                                            .frame(height: 20)
                                        
                                        Chart(viewModel.dailyForecastEntries) { data in
                                            LineMark(
                                                x: .value("Day", data.time),
                                                y: .value("Temp", data.temperature_min)
                                            )
                                            .foregroundStyle(.altgoy)
                                            .interpolationMethod(.linear)
                                            

                                            
                                            PointMark(
                                                x: .value("Day", data.time),
                                                y: .value("Temp", data.temperature_min)
                                            )
                                            
                                            .symbol {
                                                
                                                Circle()
                                                    .frame(width: 7, height: 7)
                                                    .foregroundStyle(Color.cyan)
                                            }
                                            .annotation(position: .bottom) {
                                                Text("\(Int(data.temperature_min))°")
                                                    .font(.headline)
                                                    .foregroundColor(.white)
                                                    .padding(4)
                                            }
                                        }
                                        .chartXAxis(.hidden)
                                        .chartYAxis(.hidden)
                                        .frame(height: 60)
                                        .padding([.leading, .trailing], -10)
                                        
                                    }
                                } else
                                {
                                    HStack(spacing: 27)
                                    {
                                        
                                        WeatherDayViewDaily(animationID: "Animation 0", titleNamespace: titleAnimation, iconNamespace: iconAnimation, tempAnimation: tempAnimation, dayOfWeek: "Today", imageName: viewModel.dailyForecastEntries.first?.iconName ?? "cloud.sun.fill", maxTemp: Int(viewModel.dailyForecastEntries.first?.temperature_max ?? 0), minTemp: Int(viewModel.dailyForecastEntries.first?.temperature_min ?? 0))
                                    
                                        
                                        ForEach(viewModel.dailyForecastEntries.dropFirst(), id: \.time) { entry in
                                            
                                            WeatherDayViewDaily(animationID: "Animation \(entry.time)", titleNamespace: titleAnimation, iconNamespace: iconAnimation, tempAnimation: tempAnimation, dayOfWeek: "\(entry.weekday.uppercased())", imageName: entry.iconName, maxTemp: Int(entry.temperature_max), minTemp: Int(entry.temperature_min))
                                        }
                                    }
                                }
                            }
                        }
                        .frame(width: UIScreen.main.bounds.width - 70)
                        .padding([.leading, .bottom, .trailing], 25)
                        .padding([.top], 20)
                        .background
                        {
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .fill(.black.shadow(.drop(radius: 2)))
                                .opacity(0.3)
                        }
                        .onTapGesture {
                            withAnimation(.spring())
                            {
                                viewModel.isDailyExpanded.toggle()
                            }
                        }
//                        .background
//                        {
//                            RoundedRectangle(cornerRadius: 10, style: .continuous)
//                                .fill(.secondary)//.shadow(.drop(radius: 2)))
//                                .opacity(0.7)
//                            //                                    .foregroundStyle(.ultraThinMaterial)
//                            //                                    .environment(\.colorScheme, .dark)
//                        }
                        
                        
                        
                        
                        VStack(alignment: .leading, spacing: 30)
                        {
                            HStack
                            {
                                Text("24-Hour Forecast")
                                    .font(.system(size: 23, weight: .regular))
                                    .foregroundStyle(.white)
                                
                                Spacer()
                                
                            }
                            
                            
                            ScrollView(.horizontal)
                            {
                                VStack
                                {
                                    HStack(spacing: 27)
                                    {
                                        
                                        WeatherDayViewHourly(dayOfWeek: "Now",
                                                             imageName: viewModel.minuteEntry.iconName,
                                                             temperature: viewModel.minuteEntry.temperature_2m)
                                        
                                        
                                        ForEach(viewModel.hourlyForecastEntries, id: \.time) { entry in
                                            
                                            WeatherDayViewHourly(dayOfWeek: "\(entry.time)",
                                                                 imageName: entry.iconName,
                                                                 temperature: entry.temperature)
                                            
                                        }
                                    }
                                    
                                    Chart(viewModel.hourlyForecastEntries) { data in
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
                            
                            
                            
                            
                            
                        }
                        .frame(width: UIScreen.main.bounds.width - 70)
                        .padding([.leading, .bottom, .trailing], 25)
                        .padding([.top], 20)
                        .background
                        {
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .fill(.black.shadow(.drop(radius: 2)))
                                .opacity(0.3)
                        }
                        
                        LazyVGrid(columns: columns)
                        {
                            GridElement(title: "Humidity", indicator: "\(viewModel.minuteEntry.relative_humidity_2m)%", imageName: "drop.circle.fill")
                            
                            GridElement(title: "Real Feel", indicator: "\(Int(viewModel.minuteEntry.apparent_temperature))°", imageName: "thermometer.high")
                            
                            GridElement(title: "Precipitation", indicator: "\(viewModel.precipitation)%", imageName: "cloud.rain.fill")
                            
                            GridElement(title: "Wind Speed", indicator: "\(Int(viewModel.minuteEntry.wind_speed_10m)) km/h", imageName: "wind")
                            
                        }
                        .frame(width: UIScreen.main.bounds.width-20)
                    }
                }
                .scrollIndicators(.never)
                .padding(.top, 35)
                .refreshable {
                    viewModel.recreateLocationManager()
                }
                
                
                if viewModel.isLoading && viewModel.isInitialLoad
                {
                    LoadingView()
                }
                
                if viewModel.isNoConnection
                {
                    NoConnectionView(isRetryLoading: $viewModel.isRetryLoading)
                }
            }
        }
        .environmentObject(viewModel)
//        .onAppear
//        {
//            viewModel.getForecasts()
//        }
    }
}


#Preview {
    WeatherMainView()
}
