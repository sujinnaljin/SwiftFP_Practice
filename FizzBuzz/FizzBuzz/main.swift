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

let answer = Int(arc4random() % 100) + 1
var count = 0

while true {
    
    let userInput = readLine()
    
    guard let unwrappedInput = userInput, let inputNumber = Int(unwrappedInput) else {
        print("Wrong")
        continue
    }
    
    if inputNumber == answer {
        print("Correct! : \(count)")
        break
    }
    
    if inputNumber > answer {
        print("High")
    }
    
    if inputNumber < answer {
        print("Low")
    }
    
    count += 1
}

