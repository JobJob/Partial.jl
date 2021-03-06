module Partial

export @p, @partial
"""
Converts an expression containing N placeholder underscores, to an anonymous function
taking N args whose values replace the placeholder underscores when the function is evaluated

e.g.
```
    len_gt_10 = @p(length(_) > 10)
    len_gt_10("fred")
        false
    len_gt_10("freddy mercury")
        true
```
e.g.
```
    len_gt_x = @p(length(_) > _)
    len_gt_x("fred",2)
        true
    len_gt_x("fred",10)
        false
```
"""

macro p(fbodies...)
  partial_apply(fbodies)
end

macro partial(fbodies...)
  partial_apply(fbodies)
end

function partial_apply(fbodies)
  foreach(fexpr->replace_sym!(fexpr, "_", :pfargs), fbodies)
  fexprs = map(fbody->esc(:((pfargs...)->$fbody)), fbodies)
  return foldl((cur,f)->:($cur ∘ $f), reverse(fexprs))
end

replace_sym!(expr::Expr, symstr::AbstractString, replacement, i=1) = begin
  symreg = Regex("$symstr(\\d*)")
  expr.head,i = maybe_replace(expr.head, symreg, replacement, i)
  for (argnum, arg) in enumerate(expr.args)
    (typeof(arg) == Expr) && (i = replace_sym!(arg, symstr, replacement, i))
    expr.args[argnum],i = maybe_replace(arg, symreg, replacement, i)
  end
  i
end

maybe_replace(subexpr, symreg, replacement, i) = begin
  if typeof(subexpr) == Symbol && occursin(symreg, string(subexpr))
    m = match(symreg, string(subexpr))
    if length(m.captures[1]) > 0
      #subexpr is e.g. _1 or _3
      replace_idx = parse(Int, m.captures[1])
      return :($replacement[$replace_idx]), i
    else
      return :($replacement[$i]), i+1
    end
  end
  return subexpr, i #unchanged, i.e. maybe_not
end

end # module
