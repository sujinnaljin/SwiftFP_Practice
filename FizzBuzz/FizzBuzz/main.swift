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

/*getLocation("san") { (locations) in
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

RunLoop.main.run()*/

/*
 자동 판매기 프로젝트
 1. 상품은 콜라(1000), 사이다(1100), 환타(1200)
 2. 사용가능 지폐는 100, 500, 1000
 3. 현재 입력된 금액을 표시
 4. 상품이 나오면 상품 금액만큼 현재 금액에서 차감
 5. 입력된 금액이 상품 가격보다 낮으면 상품이 나오지 않음
 6. 반환 버튼을 누르면 현재 잔액이 모두 나옴
 
 프로그램은 콘솔에서 동작하는 것을 기본으로 합니다.
 그래서 입력값은 사용자로부터 명령어를 입력받아 처리합니다.
 출력값도 콘솔출력으로 처리합니다.
 
 <수행 결과 예시>
 100
 현재 금액은 100 입니다.
 500
 현재 금액은 600 입니다.
 cola
 잔액이 부족합니다.
 500
 현재 금액은 1100 입니다.
 cola
 콜라(1000원) 상품이 나왔습니다.
 현재 금액은 100 입니다.
 reset
 잔액 100원이 나왔습니다.
 현재 금액은 0 입니다.
 */

enum Product : Int{
    case cola = 1000
    case cider = 1100
    case fanta = 1200
    func name() -> String {
        switch self {
        case .cola:
            return "콜라"
        case .cider:
            return "사이다"
        case .fanta:
            return "환타"
        }
    }
}

enum Input {
    case moneyInput(Int)
    case productInput(Product)
    case reset
    case none
}

enum Output {
    case displayMoney(Int)
    case productOut(Product)
    case shortMoneyError
    case change(Int)
}

struct State {
    let money : Int
}

func consoleInput() -> Input  {
    guard let command = readLine() else { return .none }
    switch command {
    case "100": return .moneyInput(100)
    case "500": return .moneyInput(500)
    case "1000": return .moneyInput(1000)
    case "cola": return .productInput(.cola)
    case "cider": return .productInput(.cider)
    case "fanta": return .productInput(.fanta)
    case "reset": return .reset
    default: return .none
    }
}

func consoleOutput(_ output : Output){
    switch output {
    case .displayMoney(let m):
        print("현재금액은 \(m)원입니다.")
    case .productOut(let p):
        print("\(p.name())이 나왔습니다")
    case .shortMoneyError:
        print("잔액이 부족합니다")
    case .change(let c):
        print("잔액 \(c)원이 나왔습니다")
    }
}

func operation(_ inp:@escaping ()->Input, _ out : @escaping (Output)->()) -> (State) -> State {
    return { state in
        let input = inp()
        switch input {
        case .moneyInput(let m):
            let money = state.money + m
            out(.displayMoney(money))
            return(State(money: money))
        case .productInput(let p):
            if state.money < p.rawValue {
                out(.shortMoneyError)
                return state
            }
            out(.productOut(p))
            let money = state.money - p.rawValue
            out(.displayMoney(money))
            return(State(money: money))
        case .reset:
            out(.change(state.money))
            out(.displayMoney(0))
            return State(money: 0)
        case .none:
            return state
        }
    }
}

func machineLoop(_ f : @escaping (State)->State){
    func loop(_ s : State){
        loop(f(s))
    }
    loop(State(money: 0))
}


machineLoop(operation(consoleInput, consoleOutput))
