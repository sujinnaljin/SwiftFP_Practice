//
//  main.swift
//  FizzBuzz
//
//  Created by 강수진 on 08/02/2019.
//  Copyright © 2019 강수진. All rights reserved.
//

/*
 FizzBuzz
 FizzBuzz 프로그램은 1 ~ 100 까지의 숫자를 출력하되, 3으로 나누어 떨어진다면 fizz, 5로 나누어 떨어진다면 buzz, 3과 5 둘 다 나누어 떨어지면 fizzbuzz를 출력하는 프로그램 입니다.
 */

import Foundation

let fizz = {i in i % 3 == 0 ? "fizz" : ""}
let buzz = {i in i % 5 == 0 ? "buzz" : ""}
let fizzbuzz = {i in { a, b in return b.isEmpty ? a : b}("\(i)", fizz(i)+buzz(i))}

func loop(min : Int, max: Int, do f: (Int)->Void){
    Array(min...max).forEach(f)
}

//loop(min: 1, max: 100, do: { print(fizzbuzz($0))})


/*
 Low-High
 Low-High 는 사용자로부터 숫자를 입력받아 랜덤(1~100)으로 생성된 값과 비교하여,
 큰 값이 입력되면 High, 작은 값이 입력되면 Low, 같으면 Correct! 를 출력합니다.
 Correct 출력 시 시도했던 횟수를 함께 출력합니다.
 수행은 Correct가 될 때까지 무한반복됩니다.
 숫자가 입력되지 않으면 Wrong 을 출력합니다.
 */

func countingLoop(_ needContinue : @escaping () -> Bool, _ finished : (Int)->Void){
    func counter(_ c : Int) -> Int {
        if !needContinue() {return c}
        return counter(c+1)
    }
    finished(counter(0))
    
}

func corrected(_ count : Int){
    print("correct! \(count)")
}

func generateNum(_ min : Int, _ max : Int) -> Int{
    return Int(arc4random()) % (max-min) + min
}

func inputAndCheck(_ answer : Int)->()->Bool{
    return {printResult(evaluateValue(answer))}
}

func printResult(_ r : Result) -> Bool{
    if case .correct = r {return false}
    print(r.rawValue)
    return true
}

func evaluateValue(_ answer : Int) -> Result{
    guard let inputNumber = Int(readLine() ?? "") else { return .wrong}
    if inputNumber > answer {return .high}
    if inputNumber < answer {return .low}
    return .correct
}

enum Result : String{
    case low = "Low"
    case high = "High"
    case correct = "Correct"
    case wrong = "Wrong"
}

//countingLoop(inputAndCheck(generateNum(1, 100)), corrected)

/*
 Weather Forecast
 특정지역의 날씨를 일별로 조회하여 표시합니다.
 
 검색어로 지역명을 조회할 수 있습니다. (예를들어 “york 검색어는 York 와 New York 두 지역을 검색할 수 있습니다.)
 특정 지역의 날씨를 조회합니다.
 날짜별로 날씨현황, 최고/저 온도를 표시합니다.
 지역 및 날씨 조회는 www.metaweather.com 에서 제공하는 Open API를 사용합니다.
 네트워크로 조회한 결과로 반환되는 JSON을 파싱하여 사용합니다.
 API Document - https://www.metaweather.com/api/
 */

struct Location: Codable {
    let title: String
    let location_type: String
    let woeid: Int
    let latt_long: String
}

struct WeatherInfo: Codable {
    let consolidated_weather: [Weather]
}

struct Weather: Codable {
    let weather_state_name: String
    let wind_direction_compass: String
    let applicable_date: String
    let min_temp: Float
    let max_temp: Float
    let the_temp: Float
    let wind_speed: Float
    let wind_direction: Float
    let air_pressure: Float
    let humidity: Float
    let visibility: Float
    let predictability: Float
}

//데이터
func getData(_ url : URL, _ completed : @escaping (Data)->()){
    DispatchQueue.global().async {
        if let data = try? Data(contentsOf: url) {
            print(Thread.current)
            completed(data)
        }
    }
}

//지역
func getLocation(_ loaction : String, completed:@escaping ([Location])->Void){
    let url = URL(string: "https://www.metaweather.com/api/location/search?query=\(loaction)")!
    getData(url) { (data) in
        if let locations = try? JSONDecoder().decode([Location].self, from: data) {
            completed(locations)
        }
    }
}

//날씨
func getWeathers(_ woeid : Int, completed : @escaping ([Weather])->()){
    let url = URL(string: "https://www.metaweather.com/api/location/\(woeid)")!
    getData(url) { (data) in
        if let weatherInfo = try? JSONDecoder().decode(WeatherInfo.self, from: data) {
            completed(weatherInfo.consolidated_weather)
        }
    }
}

//프린트
func printWeather(_ weather : Weather){
    
    let state = weather.weather_state_name.padding(toLength: 15,
                                                   withPad: " ",
                                                   startingAt: 0)
    let forecast = String(format: "%@: %@ %2.2f°C ~ %2.2f°C",
                          weather.applicable_date,
                          state,
                          weather.max_temp,
                          weather.min_temp)
    print(forecast)
    
}

getLocation("san") { (locations) in
    locations.forEach({ (location) in
        getWeathers(location.woeid){ (weathers) in
            print("[\(location.title)]")
            weathers.forEach({ (weather) in
                printWeather(weather)
            })
            print("")
        }
    })
}

RunLoop.main.run()
