package main

import "core:fmt"
import "core:math"
import "core:os"
import "core:slice"
import "core:strconv"
import "core:strings"

Sequence :: enum {
	Increasing,
	Decreasing,
}

is_diff_safe :: proc(first: int, second: int) -> bool {
	diff := math.abs(first - second)
	if diff < 1 || diff > 3 {
		return false
	}
	return true
}

is_line_safe :: proc(parsed_numbers: []int) -> bool {
	attribute: Sequence = parsed_numbers[0] < parsed_numbers[1] ? .Increasing : .Decreasing
	if !is_diff_safe(parsed_numbers[0], parsed_numbers[1]) {
		return false
	}
	for i in 2 ..< len(parsed_numbers) {
		if !is_diff_safe(parsed_numbers[i - 1], parsed_numbers[i]) {
			return false
		}
		if parsed_numbers[i - 1] < parsed_numbers[i] {
			if attribute == .Decreasing {
				return false
			}
		} else {
			if attribute == .Increasing {
				return false
			}
		}
	}
	return true
}

remove_at_index :: proc(arr: []int, index: int) -> []int {
	if index < 0 || index >= len(arr) {
		return arr
	}

	new_arr := make([]int, len(arr) - 1)
	copy(new_arr[:index], arr[:index])
	copy(new_arr[index:], arr[index + 1:])

	return new_arr
}

main :: proc() {
	file_data, ok := os.read_entire_file("./input.txt", context.allocator)
	if !ok {
		fmt.println("Cannot read file")
		return
	}
	defer delete(file_data, context.allocator)
	data_str := string(file_data)

	safe_lines := 0
	for line in strings.split_lines_iterator(&data_str) {
		numbers := strings.split(line, " ", context.allocator)

		parsed_numbers := make([dynamic]int)
		defer delete(parsed_numbers)

		for number in numbers {
			parsed_number, ok := strconv.parse_int(number)
			if ok {
				append(&parsed_numbers, parsed_number)
			}
		}

		if is_line_safe(parsed_numbers[:]) {
			safe_lines += 1
		} else {
			for parsed_number, index in parsed_numbers {
				removed := remove_at_index(parsed_numbers[:], index)
				if is_line_safe(removed) {
					safe_lines += 1
					break
				}
			}
		}
	}
	fmt.println(safe_lines)
}
