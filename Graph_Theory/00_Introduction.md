<!--
  Author: NE- https://github.com/NE-
  Date: 2022 November 08
  Purpose: Graph Theory Introduction
-->

# Introduction
## What is a Graph?
- Diagram represented by points and lines.
  - Points are called **vertices** or **nodes**.
  - Lines are called **edges**.
- **Degree** of vertex is number of edges with that vertex as endpoint.
- **Multiple edges**: when 2 vertices have extra joined edges.
- **Loop**: when an edge points to one and only one vertex (itself).
- **Simple graph**: graph with no loops or multiple edges.
- **Walk**: way of getting from one vertex to another.
  - P→Q→R walk of length 2.
  - P→S→Q→T→S→R walk of length 5.
- **Path**: walk in which no vertex appears more than once.
- **Cycle**: walk that starts and ends on the same vertex.
- **Eulerian** and **Hamiltonian**: graphs containing walks that include every edge or vertex exactly once, ending at the initial vertex.
  - Eulerian traverses every edge exactly once, but may repeat vertices.
  - Hamiltonian visits each vertex exactly once, but may repeat edges.
- **Tree**: connected graphs with only one path between each pair of vertices.
- **Planar Graph**: graph that can be redrawn without crossings.
- **General Graph** or **Graph**: loops and multiple edges are allowed.

## Definitions
- **Simple graph** *G* consists of non-empty finite set *V(G)* of elements called verictes (or nodes), and finite set *E(G)* of distinct unordered pairs of distinct elements of *V(G)* called edges.
  - *V(G)* called vertex set of *G*.
  - *E(G)* called edge set of *G*.
- Edge { v, w } is said to *join* vertices *v* and *w*.
  - Usually abbreviated to *vw*.
- **Graph** *G* consists of non-empty finite set *V(G)* of elements called vertices, and finite family *E(G)* of unordered pairs of (not necessarily distinct) elements of *V(G)* called edges.
  - *Family* permits existence of multiple edges.
    - { a, b, c } is a set, ( a, a, c, b, a, c ) is a family.
  - *V(G)* called vertex set of *G*.
  - *E(G)* called edge family of *G*.
- **Isomorphic**: one-one correspondence between vertices of *G<sub>1</sub>* and *G<sub>2</sub>* such that number of edges joining any two vertices of *G<sub>1</sub>* equal to number of edges joining corresponding vertices of *G<sub>2</sub>*.

### Connectedness
- Combine two graphs to make a larger graph.
- **Union** *G<sub>1</sub>* ∪ *G<sub>2</sub>*, where V(G<sub>1</sub>) and V(G<sub>2</sub>) are disjoint, are *disconnected*.
  - *Connected* graphs cannot be expressed as the union of two graphs.
  - *Disconnected* graphs are union of connected graphs.

### Adjacency
- Vertices *v* and *w* of graph *G* are **adjacent** if there's an edge *vw* joining them, then *v* and *w* are then **incident** with such an edge.
- Degree of a vertex *v* of *G* is the number of edges incident with *v*, written as deg(*v*).
  - Loops contribute 2 to the degree of *v*.
- **Isolated Vertex**: vertex of degree 0.
- **End-Vertex**: vertex of degree 1.
- **Degree Sequence**: degrees written in increasing order, with repeats as necessary.
- In **ANY** graph, sum of vertex-degress is **ALWAYS EVEN**.
  - Twice the number of edges since each edge contributes 2 to the sum.
    - Called **Handshaking Lemma**.
    - Number of vertices of odd degree is even.

### Subgraphs
- Graph whose vertices belongs to *V(G)* and each of whose edges belong to *E(G)*.
- Obtain subgraphs by deleting edges and vertices of a graph.
  - If *e* is an edge of *G*, we denote by *G - e* the graph obtained from *G* by deleting edge *e*.
  - Generally, if *F* is any set of edges in *G*, we denote by *G - F* the graph obtained by deleting the edges in *F*.
  - Similarily, if *v* is a vertex of *G*, we denote by *G - v* the graph obtained from *G* by deleting the vertex *v* together with the edges incident with *v*.
  - Generally, if *S* is any set of vertices in *G*, we denote by *G - S* the graph obtained by deleting the vertices in *S* and all edges incident with any of them.
- Also denote by *G\\e* the graph obtained by taking an edge *e* and contracting it (removing it and identifying its ends *v* and *w* so that the resulting vertex is incident with those edges (other than *e*) that were originally incident with *v* or *w*.

### Matrix Representations
- Used for string graphs as computational data.
- One way to store simple graph is by listing the vertices adjacent to each vertex of the graph.
- **Adjacency Matrix**: *n × n* matrix whose *ij*-th entry is number of edges joining vertex *i* and vertex *j*.
- **Incidence Matrix**: *n × m* matrix whose *ij*-th entry is 1 if vertex *i* is incident to edge *j*, and 0 otherwise.

### Null Graphs
- Graph whose edge-set is empty.
- Denoted by *N<sub>n</sub>* where *n* is number of vertices.
- Regular of degree 0.

### Complete Graphs
- Simple graph which each pair of distinct vertices are adjacent.
- Denoted by *K<sub>n</sub>* where *n* is number of vertices.
- Usually have `n(n-1) / 2` edges.
- Regular of degree *n*-1.

### Cycle Graphs, Path Graphs, and Wheels
- **Cycle Graph**: connected graph that is regular of degree 2.
  - Denoted by *C<sub>n</sub>* where *n* number of vertices.
- **Path Graph**: graph obtained from *C<sub>n</sub>* by removing an edge.
  - Denoted by *P<sub>n</sub>* where *n* number of vertices.
- **Wheel**: graph obtained from *C<sub>n-1</sub>* by joining each vertex to a new vertex *v*.
  - Denoted by *W<sub>n</sub>* where *n* number of vertices.

### Regular Graphs
- Graph which each vertex has same degree.
  - *Regular of degree r* or *r-regular* where *r* is the degree.
- **Cubic Graph**: regular of degree 3.
  - Example is Petersen Graph.

### Platonic Graphs
- Formed from the vertices and edges of the five regular (Platonic) solids — tetrahedron, octahedron, cube, icosahedron and dodecahedron.

### Bipartite Graphs
- If vertex set of *G* can be split into two disjoint sets *A* and *B* so that each edge of *G* joins a vertex of *A* and a vertex of *B*.
  - Vertices can be colored black and white in such a way that each edge  joins a black vertex (in *A*) and white vertex (in *B*).
- **Complete Bipartite Graph**: bipartite graph in which each vertex in *A* is joined to each vertex in *B* by just one edge.
- Denoted by *K<sub>r,s</sub>* where *r* black vertices and *s* white vertices.
- Usually have *r* + *s* vertices and *rs* edges.

### Cubes
- **k-cube** (*Q<sub>k</sub>*) is the graph whose vertices correspond to the sequences (*a<sub>1</sub>, a<sub>2</sub>, ..., a<sub>k</sub>*), where each a<sub>i</sub> = 0 or 1, and whose edges join those sequences that differ in just one place.
- Usually has 2<sup>k</sup> vertices and *k*2<sup>*k*-1</sup> edges, and is regular of degree *k*.

### Complement of a Simple Graph
- *G* complement is simple graph with set *V*(G) in which two vertices are adjacent if and only if they are *not* adjacent in *G*.
- COmplement of a complete graph is a null graph and complement of a complete bipartite graph is the union of two complete graphs.

## Puzzles
### Eight Circles Problem
> *Place the letters A, B, C, D, E, F, G, H into the eight circles in such a way that no letter is adjacent to a letter that is next to it in the alphabet*.
```
   O--O
  /|\/|\
 / |/\| \
O--O--O--O
 \ |\/| /
  \|/\|/
   O--O
```
1. Easiest letters are *A* and *H* because only 1 letter that can't be adjacent.
2. Hardest to fill are in the middle. Each adjacent to 6 others.
- Suggests place *A* and *H* in the middle, *G* and *B* at the ends while following the rules.
```
   O--O
  /|\/|\
 / |/\| \
G--A--H--B
 \ |\/| /
  \|/\|/
   O--O
```
- *C* must be on the left-hand side and *F* on the right, then the remainig letters are obvious.
```
   C--O
  /|\/|\
 / |/\| \
G--A--H--B
 \ |\/| /
  \|/\|/
   O--F

   C--E
  /|\/|\
 / |/\| \
G--A--H--B
 \ |\/| /
  \|/\|/
   D--F
```

### Six People at a Party
> *Show that, in any gathering of six people, there are either three people who all know each other or three people none of whom knows either of the other two*.
- Draw a graph in which we represent each person by a vertex and join two vertices by a solid edge if the corresponding people know each other, and by a dotted edge if not. 
  - We must show that there is always a solid triangle or a dotted triangle. 

### Four Cubes Problem
> *Given four cubes whose faces are colored red, blue, green and yellow, can we pile them up so that all four colours appear on each side of the resulting 4x1 stack?*
```
   [R]          [R]          [G]          [B]
[R][Y][G][B] [R][Y][B][G] [B][B][R][Y] [G][Y][R][G] 
   [R]          [Y]          [G]          [Y]
    1            2            3            4
```
- Each cube represented as a graph with 4 vertices, R, B, G, Y.
- Two vertices are adjacent if and only if the cube has corresponding colors on opposite faces.
- Superimpose the graphs to form one graph *G*.
- Solution obtained by finding two subgraphs *H*<sub>1</sub> and *H*<sub>2</sub> of *G*. *H*<sub>1</sub> tells which pair of colors appear on the front and back of each cube, *H*<sub>2</sub> tells which pair of colors appear on the left and right.
- Subgraph *H*<sub>1</sub> and *H*<sub>2</sub> properties:
  - Each subgraph contains exactly one edge from each cube; this ensures that each cube has a front and back, and a left and right, and the subgraphs tell us which pairs of colours appear on these faces.
- The subgraphs have no edges in common; this ensures that the faces on the front and back are different from those on the sides.
- Each subgraph is regular of degree 2; this tells us that each colour appears exactly twice on the sides of the stack (once on each side) and exactly twice on the front and back (once on the front and once on the back). 
