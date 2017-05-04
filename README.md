## Yet Another Partial Macro

Mine uses underscores - boring

e.g.
```
type Person
    name
    age
end
N = 10
people = [Person("Fred $i", rand(0:100)) for i in 1:N]
ages = map((@p _.age), people)
```
```
10-element Array{Int64,1}:
 78
 15
 87
 92
 71
 90
 61
 69
 93
 52
```

and you can number the underscores

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
