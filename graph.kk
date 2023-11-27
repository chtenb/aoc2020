
// Implicit graph structures
effect igraph
  fun nodes() : list<int>
  fun nhood(n : int) : list<int>

fun arcs() : igraph list<(int, int)>
  nodes().map(fn(n)
    nhood(n).map(fn(neigh) (n, neigh))
  ).flatmap(id)

effect visitor
  fun visit(n : int) : ()
  fun visited(n : int) : bool

fun dfs(start : int) : <div,igraph,visitor> ()
  dfs-impl([start])
  
fun dfs-impl(todo : list<int>) : <div,igraph,visitor> ()
  match todo
    Nil -> ()
    Cons (n,ns) -> 
      if !visited(n) then
        visit(n)
        dfs-impl(nhood(n) ++ ns)
      else
        dfs-impl(ns)
  
// Explicitly stored graph structure
value struct graph
  nhoods : vector<list<int>>

fun arcs(g : graph) : list<(int, int)>
  g.nhoods.list().map-indexed(fn(node, nhood)
    nhood.map(fn(neigh) (node, neigh))
  ).flatmap(id)

fun graph(nhoods : list<list<int>>)
  Graph(vector(nhoods))
  
fun handle-graph-as-igraph(g : graph, f : () -> <igraph,exn|e> a) : <exn|e> a
  with handler
    fun nodes() list(0, g.nhoods.length())
    fun nhood(n) g.nhoods[n]
  f()

fun handle-visitor-as-list(f : forall<h> () -> <visitor,local<h>|e> ()) : e list<int>
  var result : list<int> := Nil
  with handler
    fun visit(n) result := Cons(n, result)
    fun visited(n) result.any(fn(m) m == n)
  f()
  result
