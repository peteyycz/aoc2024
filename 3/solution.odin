package main

import "core:fmt"
import "core:math"
import "core:os"
import "core:slice"
import "core:strconv"
import "core:strings"

main :: proc() {
	file_data, ok := os.read_entire_file("./input.txt", context.allocator)
	if !ok {
		fmt.println("Cannot read file")
		return
	}
	defer delete(file_data, context.allocator)
	data_str := string(file_data)
	for line in strings.split_lines_iterator(&data_str) {
		storage := strings.builder_make(context.allocator)
		for char in line {
			if char == 'm' {
				// storage = char
			}
			if storage == "m" && char == 'u' {
				// storage += char
			}
			if storage == "mu" && char == 'l' {
			}
			if char == '(' {
			}
			fmt.println(char)
		}
	}
}
