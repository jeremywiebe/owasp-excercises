//
//  main.swift
//  password-cracker
//
//  Created by Jeremy Wiebe on 2016-02-15.
//  Copyright © 2016 Jeremy Wiebe. All rights reserved.
//

import Foundation

var password = "hello"
var hashedPassword = md5(password)

print("\(password) -> \(hashedPassword)")


var times = (1..<1000).map({ (x) -> UInt64 in
	timeBlock() {
		_ = hashedPassword == "00000000000000"
	}
})
let m = mean(times)
var s = stddev(times)
print("Standard Deviation is \(s)")

times = times.filter() { x -> Bool in
	var diff: Int64 = Int64(x) - Int64(m)
	return UInt64(abs(diff)) <= (s * 3)
}

// List of chars we'll test (space included intentially)
let CHARS = " 0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ~!@#$%^&*()_+`-=[]{};:'\"/?.>,<\\|"

func compareHashes(hash1: String, hash2: String) -> Bool {
	var idx = hash1.characters.startIndex
	while idx < hash1.characters.endIndex {
		if idx >= hash2.endIndex {
			return false
		}
		
		if hash1[idx] != hash2[idx] {
			return false
		}
		idx = idx.advancedBy(1)
	}
	
	return true
}


func timeGuess(guess: String) -> UInt64 {
	let tries = 1000
	var totalTime = UInt64(0)

	let hashedGuess = md5(guess)

	for _ in 0..<tries {
		totalTime += timeBlock() {
			compareHashes(hashedPassword, hash2: hashedGuess)
		}
	}
	return totalTime / UInt64(tries)
}

func findNextChar(currentGuess: String) -> String {
	var times = [Character: UInt64]()
	
	for c in CHARS.characters {
		let guess = currentGuess + String(c)
		times[c] = timeGuess(guess)
	}
	
	var bestTime = UInt64(UInt64.max)
	var bestChar = CHARS.characters[CHARS.characters.startIndex]
	
	for c in times.keys {
		if times[c] < bestTime {
			bestChar = c
			bestTime = times[c]!
		}
	}
	
	return currentGuess + String(bestChar)
}

//var guess = ""
//for i in 0..<10 {
//	guess = findNextChar(guess)
//	print("Found next candidate: \(guess)")
//}

