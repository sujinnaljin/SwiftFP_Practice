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

