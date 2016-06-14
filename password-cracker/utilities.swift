//
//  utilities.swift
//  password-cracker
//
//  Created by Jeremy Wiebe on 2016-06-06.
//  Copyright © 2016 Jeremy Wiebe. All rights reserved.
//

import Foundation

/* Times a block returning the number of nanoseconds it took */
func timeBlock(block: (Void) -> Void) -> Int64 {
	var info = mach_timebase_info(numer: 0, denom: 0)
	if (mach_timebase_info(&info) != KERN_SUCCESS) {
		return 0
	}
	
	let start = mach_absolute_time()
	
	block()
	
	let end = mach_absolute_time()
	
	let elapsed = end - start
	
	let nanos: Int64 = Int64(elapsed * UInt64(info.numer) / UInt64(info.denom))
	
	return nanos
}

/* Calculates the MD5 hash of the given string */
func md5(input: String) -> String {
	var digest = [UInt8](count: Int(CC_MD5_DIGEST_LENGTH), repeatedValue: 0)
	
	guard let data = input.dataUsingEncoding(NSUTF8StringEncoding) else {
		return ""
	}
	
	CC_MD5(data.bytes, CC_LONG(data.length), &digest)
	
	var digestHex = ""
	for index in 0..<Int(CC_MD5_DIGEST_LENGTH) {
		digestHex += String(format: "%02x", digest[index])
	}
	
	return digestHex
}

func mean(data: [Int64]) -> Int64 {
	let sum = data.reduce(0) { (accum, item) -> Int64 in
		return accum + item
	}
	return sum / Int64(data.count)
}

func stddev(data: [Int64]) -> Int64 {
	let avg = mean(data)
	
	let step2 = data.map { item -> Int64 in
		let diff = Int64(item) - Int64(avg)
		return Int64(diff * diff)
	}
	
	let step3 = mean(step2)
	
	return Int64(sqrt(Double(step3)))
}