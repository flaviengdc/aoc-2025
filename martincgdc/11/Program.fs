open System.IO
open System.Collections.Generic

let line_to_edge (line: string) =
    let elements = line.Split ": " |> List.ofArray

    match elements with
    | [] -> failwith "Unexpected empty line"
    | from :: tail -> let children = (List.head tail).Split " " |> List.ofArray in from, children

let lines =
    let filename = "example.txt"

    File.ReadAllLines filename
    |> Array.filter (fun line -> line <> "")
    |> Array.map line_to_edge

let edges = Map lines

let rec count_paths (from: string) (dest: string) (memo: Dictionary<string, uint64>) =
    match memo.TryGetValue from with
    | true, count -> count
    | false, _ ->
        if from = dest then
            1UL
        else
            match edges.TryFind from with
            | None -> 0UL
            | Some children ->
                let sum = List.sumBy (fun x -> count_paths x dest memo) children
                memo.Add(from, sum)
                sum

let part1 = count_paths "you" "out" (Dictionary())

let part2 =
    let r1 =
        count_paths "svr" "fft" (Dictionary())
        * count_paths "fft" "dac" (Dictionary())
        * count_paths "dac" "out" (Dictionary())

    let r2 =
        count_paths "svr" "dac" (Dictionary())
        * count_paths "dac" "fft" (Dictionary())
        * count_paths "fft" "out" (Dictionary())

    r1 + r2

printfn "Part 1: %u" part1
printfn "Part 2: %u" part2
