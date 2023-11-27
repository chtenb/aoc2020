module utils

import std/os/path
import std/os/file
import std/text/parse

pub fun parse-exn(input:string, p:parser<total, a>) : exn a
  match parse(slice(input), p)
    ParseOk(result, _) -> result
    ParseError(msg, _) -> throw-exn(Exception("parse error: " ++ msg, ExnError))

pub fun eol() : parse ()
  val _ = optional('\r', { char('\r') })
  val _ = char('\n')
  ()

effect each
  ctl each(elems : list<a>) : a
  ctl fail() : a

fun list-comp(action : () -> each a) : list<a>
  with handler
    return (x) [x]
    ctl each(elems) elems.flatmap(resume)
    ctl fail() []
  action()

fun guard(pred : bool) : each ()
  if pred then () else fail()

pub fun test-each()
  list-comp
    val x = each([1,2,3])
    val y = each([1,2,2])
    val z = x+y
    guard (z != 3)
    z * z
