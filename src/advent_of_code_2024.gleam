import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import simplifile

pub fn main() {
  let lines = load_lines_from("./src/input.txt")
  let lists = list.fold(lines, #([], []), split_line)

  list.map2(lists.0, lists.1, with: fn(first, second) {
    int.absolute_value(first - second)
  })
  |> int.sum
  |> int.to_string
  |> io.println
}

fn load_lines_from(path: String) -> List(String) {
  let assert Ok(content) = simplifile.read(path)

  string.split(content, on: "\n")
  |> list.filter(fn(line) { !string.is_empty(line) })
}

fn split_line(
  acc_lists: #(List(Int), List(Int)),
  line: String,
) -> #(List(Int), List(Int)) {
  let assert Ok(#(first, second)) =
    string.split_once(line, on: "   ")
    |> result.map(with: fn(numbers) {
      let assert Ok(first_number) = int.parse(numbers.0)
      let assert Ok(second_number) = int.parse(numbers.1)
      #(first_number, second_number)
    })

  #(
    list.append(acc_lists.0, [first]) |> list.sort(by: int.compare),
    list.append(acc_lists.1, [second]) |> list.sort(by: int.compare),
  )
}
