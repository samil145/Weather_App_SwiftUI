![](https://github.com/samil145/Weather_App_SwiftUI/blob/main/Images/Weather%20App%20Whiteboard.jpg?raw=true)

# Weather App (SwiftUI)

**Weather App** is an IOS app built to show current, hourly, daily forecast and more.  This app is made with **SwiftUI** and **Open-Meteo**.

## App Background

<p align="center">
  <p align="left">
    Background image changes according to <strong>weather code</strong> and <strong>time</strong>.
  </p>
</p>

<p align="center">
<img src= "https://github.com/samil145/Weather_App_SwiftUI/blob/main/Images/sunny.png?raw=true" height="600" >
   &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
<img src= "https://github.com/samil145/Weather_App_SwiftUI/blob/main/Images/rainy_extended.png?raw=true" height="600" >
</p>



## ⛓ Features

  - Location, **current forecast** ( weather code based icon and temperature), **max** and **min** temperatues of current day are on top of the screen.
  - Below that, there is **daily** and **hourly** forecasts. User can tap daily forecast for observing **chart** of daily temperatures. 
  - Below these, there are four indicators which show **humidity**, **real feel** temperature, **precipitation** and finally **wind speed**.

<p align="center">
<img src= "https://github.com/samil145/Weather_App_SwiftUI/blob/main/Images/app_record2.gif?raw=true" height="600" width="300" >
</p>

## Network Connection

In case of **network problems**, new screen pops up which informs user about current problem. When **"Retry"** button is tapped, app proceeds regularly if there is no network problem.

<p align="center">
<img src= "https://github.com/samil145/Weather_App_SwiftUI/blob/main/Images/retry.png?raw=true" height="600" >
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
<img src= "https://github.com/samil145/Weather_App_SwiftUI/blob/main/Images/retry_record.gif?raw=true" height="600" width="300">
</p>

## Technical Background
 - **Weather App** is made with **"SwiftUI"** framework.
 - **"Open-Meteo"** is used for API calls.
 - **MVVM** is applied.
 - Simple animations used in tapping daily forecast.
