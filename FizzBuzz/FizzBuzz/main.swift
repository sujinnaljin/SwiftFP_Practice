//
//  main.swift
//  FizzBuzz
//
//  Created by 강수진 on 08/02/2019.
//  Copyright © 2019 강수진. All rights reserved.
//

/*
 FizzBuzz (non-FP)
 FizzBuzz 프로그램은 1 ~ 100 까지의 숫자를 출력하되, 3으로 나누어 떨어진다면 fizz, 5로 나누어 떨어진다면 buzz, 3과 5 둘 다 나누어 떨어지면 fizzbuzz를 출력하는 프로그램 입니다.
 */

import Foundation

let fizz = {i in i % 3 == 0 ? "fizz" : ""}
let buzz = {i in i % 5 == 0 ? "buzz" : ""}
let fizzbuzz = {i in { a, b in return b.isEmpty ? a : b}("\(i)", fizz(i)+buzz(i))}

func loop(min : Int, max: Int, do f: (Int)->Void){
    Array(min...max).forEach(f)
}

loop(min: 1, max: 100, do: { print(fizzbuzz($0))})


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

countingLoop(inputAndCheck(generateNum(1, 100)), corrected)
