using Test

@testset "Quite partial to it really" begin
  add3 = @p(3 + _)
  @test add3(7) == 10
  add4r = @p(_ + 4)
  @test add4r(7) == 11

  lt10 = @partial _ < 10
  @test lt10(7) == true
  @test lt10(27) == false

  gt10 = @p(10 < _)
  @test gt10(17) == true
  @test gt10(7) == false

  fn_of7_and_10 = @p _(7,10)
  @test fn_of7_and_10(*) == 70
  @test fn_of7_and_10(+) == 17
  @test fn_of7_and_10(-) == -3
  @test fn_of7_and_10(/) == 0.7
  @test fn_of7_and_10(%) == 7

  @test map(@p(_(7,10)),[*,+,-,/,%]) == [70,17,-3,0.7,7]

  v1 = 3
  v2 = 5
  fn_of_v1_and_v2 = @p _(v1,v2)
  @test fn_of_v1_and_v2(*) == 15
  @test fn_of_v1_and_v2(+) == 8
  @test fn_of_v1_and_v2(-) == -2
  @test fn_of_v1_and_v2(/) == 0.6
  @test fn_of_v1_and_v2(%) == 3

end

@testset "partial multi sub" begin
  d = 10
  zeros_dxN = @p zeros(_,d,_)
  @test zeros_dxN(Int,3) == zeros(Int,10,3)
  T = Float64
  d2 = 12
  zerosF64 = @p zeros(T,_,_)
  @test zerosF64(d2,4) == zeros(Float64,d2,4)
end

@testset "partial can handle nested syms" begin
  len_gt_10 = @partial(length(_) > 10)
  @test len_gt_10("fred") == false
  @test len_gt_10("freddy mercury") == true

  fred = Array{Real}[]
  push!(fred, [1,2,3])
  push!(fred, [4.0,5.0,6.0])
  fred_sub_ind = @p(fred[_][_])
  @test fred_sub_ind(1,2) == 2
  @test fred_sub_ind(1,3) == 3
  @test fred_sub_ind(2,1) == 4.0
  @test fred_sub_ind(2,3) == 6.0

  len_gt_x = @partial(length(_) > _)
  @test len_gt_x("fred",2) == true
  @test len_gt_x("fred",10) == false
end

@testset "partial indexed sub" begin
  d = 10
  zeros_dxN = @p zeros(Int,_1,_1)
  @test zeros_dxN(3) == zeros(Int,3,3)
  zeros_dxN = @p zeros(Int,_1,_)
  @test zeros_dxN(5) == zeros(Int,5,5)
  T = Float64
  d2 = 12
  zerosF64 = @p zeros(T,_,_1)
  @test zerosF64(d2) == zeros(Float64,12,12)
end

@testset "partial chained" begin
  # unary fn
  x10plus3 = @p _*10 _+3
  for (inp, outp) in zip((2,3,4), (23,33,43))
    @test x10plus3(inp) == outp
  end
  # binary fn
  b_minus_a_x3 = @p _2-_1 _*3
  for (inp, outp) in zip([(2,4), (7,3), (9,2)], (6, -12, -21))
    @test b_minus_a_x3(inp...) == outp
  end
end
