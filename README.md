## Yet Another Partial Macro

### What

Create anonymous functions with fewer key strokes

```
sextupler = @p 6_
sextupler(5)
30
```

### Why

There are other packages that do basically the same thing (and more), but I remember how to use mine, and this package supports multiple and numbered arguments, which others maybe don't.

### Install

Unregistered for now.
`Pkg.clone("https://github.com/JobJob/Partial.jl.git")`

### Usage

Create functions whose arguments will replace the underscores.

e.g.
```
# setup
using Partial
type Person
    name
    weight
end
N = 10
people = [Person("Fred $i", rand(0:500)) for i in 1:N]

# magic
ages = map(@p(_.weight), people) # equiv of map(prsn->prsn.weight, people)
```
```
10-element Array{Int64,1}:
 433
 432
  85
 205
 301
  87
 385
 476
  12
 125
```
Even though it doesn't look that useful in the above example, in some cases it actually is.


You can also number the underscores/arguments

```
channels = 4
rand_image = @p rand(_1, _2, channels)
width, height = 100, 50
im = rand_image(width, height)
size(im)
```
```
(100,50,4)
```
