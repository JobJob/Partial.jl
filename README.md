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

```

AND - you can number the underscores

```
age_vec = map((@p string("person ", _1, " is ", _2.age), enumerate(people))
```
