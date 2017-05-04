using FactCheck

facts("Quite partial to it really") do
  add3 = @p(3 + _)
  @fact add3(7) --> 10
  add4r = @p(_ + 4)
  @fact add4r(7) --> 11

  lt10 = @partial _ < 10
  @fact lt10(7) --> true
  @fact lt10(27) --> false

  gt10 = @p(10 < _)
  @fact gt10(17) --> true
  @fact gt10(7) --> false

  fn_of7_and_10 = @p _(7,10)
  @fact fn_of7_and_10(*) --> 70
  @fact fn_of7_and_10(+) --> 17
  @fact fn_of7_and_10(-) --> -3
  @fact fn_of7_and_10(/) --> 0.7
  @fact fn_of7_and_10(%) --> 7

  @fact map(@p(_(7,10)),[*,+,-,/,%]) --> [70,17,-3,0.7,7]

  v1 = 3
  v2 = 5
  fn_of_v1_and_v2 = @p _(v1,v2)
  @fact fn_of_v1_and_v2(*) --> 15
  @fact fn_of_v1_and_v2(+) --> 8
  @fact fn_of_v1_and_v2(-) --> -2
  @fact fn_of_v1_and_v2(/) --> 0.6
  @fact fn_of_v1_and_v2(%) --> 3

end

facts("partial multi sub") do
  d = 10
  zeros_dxN = @p zeros(_,d,_)
  @fact zeros_dxN(Int,3) --> zeros(Int,10,3)
  T = Float64
  d2 = 12
  zerosF64 = @p zeros(T,_,_)
  @fact zerosF64(d2,4) --> zeros(Float64,d2,4)
end

facts("partial can handle nested syms") do
  len_gt_10 = @partial(length(_) > 10)
  @fact len_gt_10("fred") --> false
  @fact len_gt_10("freddy mercury") --> true

  fred = Array{Real}[]
  push!(fred, [1,2,3])
  push!(fred, [4.0,5.0,6.0])
  fred_sub_ind = @p(fred[_][_])
  @fact fred_sub_ind(1,2) --> 2
  @fact fred_sub_ind(1,3) --> 3
  @fact fred_sub_ind(2,1) --> 4.0
  @fact fred_sub_ind(2,3) --> 6.0

  len_gt_x = @partial(length(_) > _)
  @fact len_gt_x("fred",2) --> true
  @fact len_gt_x("fred",10) --> false
end

facts("partial indexed sub") do
  d = 10
  zeros_dxN = @p zeros(Int,_1,_1)
  @fact zeros_dxN(3) --> zeros(Int,3,3)
  zeros_dxN = @p zeros(Int,_1,_)
  @fact zeros_dxN(5) --> zeros(Int,5,5)
  T = Float64
  d2 = 12
  zerosF64 = @p zeros(T,_,_1)
  @fact zerosF64(d2) --> zeros(Float64,12,12)
end
