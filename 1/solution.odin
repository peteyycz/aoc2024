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

	first_arr := make([dynamic]int)
	defer delete(first_arr)
	second_arr := make([dynamic]int)
	defer delete(second_arr)
	for line in strings.split_lines_iterator(&data_str) {
		nrs := strings.split(line, "   ", context.allocator)
		first, ok1 := strconv.parse_int(nrs[0])
		if !ok1 {
			fmt.println("not ok first")
			return
		}
		append(&first_arr, first)

		second, ok2 := strconv.parse_int(nrs[1])
		if !ok2 {
			fmt.println("not ok second")
			return
		}
		append(&second_arr, second)
	}

	slice.sort(first_arr[:])
	slice.sort(second_arr[:])

	total_similarity := 0
	for first in first_arr {
		found := 0
		for second in second_arr {
			if first == second {
				found += 1
			}
		}
		total_similarity += first * found
	}

	fmt.println(total_similarity)
}
