import gleam/int
import gleam/io
import gleam/list
import gleam/string
import simplifile

pub fn main() {
  let lines = load_lines_from("./src/input.txt")
  let reports = list.fold(lines, [], split_line)

  reports
  |> list.filter(is_safe_report_with_dampener)
  |> list.length
  |> int.to_string
  |> io.println
}

fn is_safe_report_with_dampener(report: List(Int)) -> Bool {
  case is_valid_report(report) {
    True -> True
    False -> {
      list.range(0, list.length(report) - 1)
      |> list.any(fn(i) {
        remove_at(report, i)
        |> is_valid_report
      })
    }
  }
}

fn remove_at(list: List(a), index: Int) -> List(a) {
  case list, index {
    [], _ -> []
    [_x, ..xs], 0 -> xs
    [x, ..xs], i -> [x, ..remove_at(xs, i - 1)]
  }
}

fn is_valid_report(report: List(Int)) -> Bool {
  let diffs = get_differences(report)
  let is_all_positive =
    diffs
    |> list.all(fn(x) { x > 0 && x <= 3 })

  let is_all_negative =
    diffs
    |> list.all(fn(x) { x < 0 && x >= -3 })

  is_all_positive || is_all_negative
}

fn get_differences(report: List(Int)) -> List(Int) {
  case report {
    [first, second, ..rest] -> {
      let diff = second - first
      [diff, ..get_differences([second, ..rest])]
    }
    _ -> []
  }
}

fn load_lines_from(path: String) -> List(String) {
  let assert Ok(content) = simplifile.read(path)

  string.split(content, on: "\n")
  |> list.filter(fn(line) { !string.is_empty(line) })
}

fn split_line(acc_lists: List(List(Int)), line: String) -> List(List(Int)) {
  let numbers =
    string.split(line, on: " ")
    |> list.map(with: fn(number) {
      let assert Ok(n) = int.parse(number)
      n
    })

  list.append(acc_lists, [numbers])
}
