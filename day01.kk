module day01
import std/os/path
import std/os/file
import std/text/parse
import utils

pub fun show-pair(x:(int,int)) 
  show-tuple(x, show, show)
  
pub fun show-cand(l:list<(int,int)>)
  show-list(l, show-pair)

pub fun run(fname)
  val s = "Koka is a well-typed language"
  println( "plain  : " ++ s)
  val input = read-text-file(fname.path)
  val numbers = parse-exn(input, parse-input)
  val candidates = valid-pairs(numbers)
  // if (candidates.length > 1) then
  //   throw-exn(Exception("multiple candidates " ++ candidates.show-cand, ExnAssert))
  match candidates.head
    Just((a,b)) -> a*b
    Nothing -> throw-exn (Exception("no candidates found", ExnError))

fun parse-input() { many1(parse-line) }

fun parse-line() : parse int
  val n = pnat()
  eol()
  n


fun is-valid((a:int, b:int)) { a + b == 2020 }
fun all-pairs(l1 : list<a>, l2:list<b>):list<(a,b)>
  flatmap(l1, fn(x) { map(l2, fn (y) (x,y) ) } )

fun valid-pairs(l : list<int>)
  filter(all-pairs(l, l), is-valid)

