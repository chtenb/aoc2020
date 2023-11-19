module utils

import std/os/path
import std/os/file
import std/text/parse

pub fun parse-exn(input:string, p:parser<total, a>) : exn a
  match parse(slice(input), p)
    ParseOk(result, _) -> result
    ParseError(msg, _) -> throw-exn(Exception("parse error: " ++ msg, ExnError))

pub fun eol() : parse ()
  val _ = optional('\r', fn(){char('\r')})
  val _ = char('\n')
  ()
