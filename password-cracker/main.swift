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

// How many characters at a time do we guess?
let Step = 2
let Rounds = 1000

let password = "hello"
let hashedPassword = md5(password)

print("\(password) -> \(hashedPassword)")

func compareHashes(hash1: String, hash2: String) -> Bool {
	if (hash1.utf8.count != hash2.utf8.count) {
		return false
	}
	
	for idx in hash1.characters.startIndex..<hash1.characters.endIndex {
		if (hash1.characters[idx] != hash2.characters[idx]) {
			return false
		}
	}
	
	return true
}

func timeGuess(guess: String) -> Int64 {
	var times = [Int64]()

	for _ in 0..<Rounds {
		times.append(timeBlock() {
			compareHashes(hashedPassword, hash2: guess)
		})
	}
	
	let avg = mean(times)
	let s = stddev(times)
	let max = avg + (s * 3)
	let min = avg - (s * 3)
	
	return mean(times.filter() { x in return (min < x) && (x < max) })
}

func replaceChar(guess: String, replacement: String, index: Int) -> String {
	return
		guess.substringToIndex(guess.startIndex.advancedBy(index)) +
		replacement +
		guess.substringFromIndex(guess.startIndex.advancedBy(index + replacement.characters.count))
}

func iterateChars(currentAtom: String, length: Int = 0) -> String {
	for c in CHARS.characters {
		return String(c)
	}
}

func findNextPair(currentGuess: String, index: Int) -> String {
	var times = [String: Int64]()
	
	var atom = String(count: Step, repeatedValue: Character("0"))
	
	for i in 0..<Step {
		for c in CHARS.characters {
			atom = replaceChar(atom, replacement: String(c), index: i)
			let guess = replaceChar(currentGuess, replacement: atom, index: index)
			times[atom] = timeGuess(guess)
			
			print("\(guess) -> \(atom) -> \(times[atom])")
		}
	}
	
	var bestTime = Int64(Int64.max)
	var bestAtom = ""
	
	for atom in times.keys {
		if times[atom] < bestTime {
			bestAtom = atom
			bestTime = times[atom]!
		}
	}
	
	return replaceChar(currentGuess, replacement: bestAtom, index: index)
}

//var guess = "00000000000000000000000000000000"
var guess = "00"

for i in 0.stride(to: guess.characters.count, by: Step) {
	guess = findNextPair(guess, index: i)
	print(guess)
}

//func tryGuess(guess: String) {
//	let time = timeGuess(guess)
//	print("\(guess) -> \(time)")
//}
//tryGuess("00000000000000000000000000000000")
//tryGuess("50000000000000000000000000000000")
//tryGuess("5d000000000000000000000000000000")
//tryGuess("5d400000000000000000000000000000")
//tryGuess("5d410000000000000000000000000000")
//tryGuess("5d414000000000000000000000000000")
//tryGuess("5d414000000000000000000000000000")
//tryGuess("5d414020000000000000000000000000")
//tryGuess("5d41402a000000000000000000000000")
//tryGuess("5d41402ab00000000000000000000000")
//tryGuess("5d41402abc0000000000000000000000")
//tryGuess("5d41402abc4000000000000000000000")
//tryGuess("5d41402abc4b00000000000000000000")
//tryGuess("5d41402abc4b20000000000000000000")
//tryGuess("5d41402abc4b2a000000000000000000")
//tryGuess("5d41402abc4b2a700000000000000000")
//tryGuess("5d41402abc4b2a760000000000000000")
//tryGuess("5d41402abc4b2a76b000000000000000")
//tryGuess("5d41402abc4b2a76b900000000000000")
//tryGuess("5d41402abc4b2a76b970000000000000")
//tryGuess("5d41402abc4b2a76b971000000000000")
//tryGuess("5d41402abc4b2a76b971900000000000")
//tryGuess("5d41402abc4b2a76b9719d0000000000")
//tryGuess("5d41402abc4b2a76b9719d9000000000")
//tryGuess("5d41402abc4b2a76b9719d9100000000")
//tryGuess("5d41402abc4b2a76b9719d9110000000")
//tryGuess("5d41402abc4b2a76b9719d9110000000")
//tryGuess("5d41402abc4b2a76b9719d9110100000")
//tryGuess("5d41402abc4b2a76b9719d9110170000")
//tryGuess("5d41402abc4b2a76b9719d911017c000")
//tryGuess("5d41402abc4b2a76b9719d911017c500")
//tryGuess("5d41402abc4b2a76b9719d911017c590")
//tryGuess("5d41402abc4b2a76b9719d911017c592")
