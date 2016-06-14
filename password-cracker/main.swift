//
//  main.swift
//  password-cracker
//
//  Created by Jeremy Wiebe on 2016-02-15.
//  Copyright © 2016 Jeremy Wiebe. All rights reserved.
//

import Foundation

// List of chars we'll test (space included intentially)
let CHARS = " 0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ~!@#$%^&*()_+`-=[]{};:'\"/?.>,<\\|"

let password = "hello"
let hashedPassword = md5(password)

print("\(password) -> \(hashedPassword)")

func compareHashes(hash1: String, hash2: String) -> Bool {
	return hash1 == hash2
}

func timeGuess(guess: String) -> Int64 {
	let tries = 1000
	var times = [Int64]()

	let hashedGuess = md5(guess)

	for _ in 0..<tries {
		times.append(timeBlock() {
			compareHashes(hashedPassword, hash2: hashedGuess)
		})
	}
	
	let avg = mean(times)
	let s = stddev(times)
	let max = avg + (s * 3)
	let min = avg - (s * 3)
	
	return mean(times.filter() { x in return (min < x) && (x < max) })
}

func replaceChar(guess: String, char: Character, index: Int) -> String {
	return
		guess.substringToIndex(guess.startIndex.advancedBy(index)) +
		String(char) +
		guess.substringFromIndex(guess.startIndex.advancedBy(index + 1))
}

func findChar(currentGuess: String, index: Int) -> String {
	var times = [Character: Int64]()
	
	for c in CHARS.characters {
		let guess = replaceChar(currentGuess, char: c, index: index)
		times[c] = timeGuess(guess)
	}
	
	var bestTime = Int64(Int64.max)
	var bestChar = CHARS.characters[CHARS.characters.startIndex]
	
	for c in times.keys {
		if times[c] < bestTime {
			bestChar = c
			bestTime = times[c]!
		}
	}
	
	return replaceChar(currentGuess, char: bestChar, index: index)
}

var guess = "                                "

//for i in 0..<guess.utf8.count {
//	guess = findChar(guess, index: i)
//	print("Found next candidate: --\(guess)--")
//}

func tryGuess(guess: String) {
	let time = timeGuess(guess)
	print("\(guess) -> \(time)")
}

tryGuess("00000000000000000000000000000000")
tryGuess("50000000000000000000000000000000")
tryGuess("5d000000000000000000000000000000")
tryGuess("5d400000000000000000000000000000")
tryGuess("5d410000000000000000000000000000")
tryGuess("5d414000000000000000000000000000")
tryGuess("5d414000000000000000000000000000")
tryGuess("5d414020000000000000000000000000")
tryGuess("5d41402a000000000000000000000000")
tryGuess("5d41402ab00000000000000000000000")
tryGuess("5d41402abc0000000000000000000000")
tryGuess("5d41402abc4000000000000000000000")
tryGuess("5d41402abc4b00000000000000000000")
tryGuess("5d41402abc4b20000000000000000000")
tryGuess("5d41402abc4b2a000000000000000000")
tryGuess("5d41402abc4b2a700000000000000000")
tryGuess("5d41402abc4b2a760000000000000000")
tryGuess("5d41402abc4b2a76b000000000000000")
tryGuess("5d41402abc4b2a76b900000000000000")
tryGuess("5d41402abc4b2a76b970000000000000")
tryGuess("5d41402abc4b2a76b971000000000000")
tryGuess("5d41402abc4b2a76b971900000000000")
tryGuess("5d41402abc4b2a76b9719d0000000000")
tryGuess("5d41402abc4b2a76b9719d9000000000")
tryGuess("5d41402abc4b2a76b9719d9100000000")
tryGuess("5d41402abc4b2a76b9719d9110000000")
tryGuess("5d41402abc4b2a76b9719d9110000000")
tryGuess("5d41402abc4b2a76b9719d9110100000")
tryGuess("5d41402abc4b2a76b9719d9110170000")
tryGuess("5d41402abc4b2a76b9719d911017c000")
tryGuess("5d41402abc4b2a76b9719d911017c500")
tryGuess("5d41402abc4b2a76b9719d911017c590")
tryGuess("5d41402abc4b2a76b9719d911017c592")
