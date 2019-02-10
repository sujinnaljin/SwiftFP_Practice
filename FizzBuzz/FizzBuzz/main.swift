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

func fizz(_ i : Int) -> String {
    if i % 3 == 0 {
        return "fizz"
    }
    return ""
}

func buzz(_ i : Int) -> String {
    if i % 5 == 0 {
        return "buzz"
    }
    return ""
}

func fizzbuzz(_ i : Int) -> String {
    let f = fizz(i)
    let b = fizz(i)
    let result = f+b
    
    if result.isEmpty {
        return "\(i)"
    }
    
    return result
}

func loop(min : Int, max: Int, do f: (Int)->Void){
    var i = min
    while i <= max {
        f(i)
        i += 1
    }
}

loop(min: 1, max: 100, do: {i in
    let result = fizzbuzz(i)
    print(result)
})

