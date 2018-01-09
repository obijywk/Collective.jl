@testset "letter additions" begin
    f = best_feature(["word", "mother", "prayer", "teak", "trumpet"], 0)
    @test f.description == "is a word when prefixed with 's'"

    f = best_feature(["drive", "flora", "larva", "morse", "shove"], 0)
    @test f.description == "is a word when suffixed with 'l'"    
end
