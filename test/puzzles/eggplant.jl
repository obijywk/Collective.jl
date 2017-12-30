@testset "the egg plant" begin
    # tinyurl.com/nplbarexam Main-D-EggPlant.pdf
    f = best_feature(["cardioid", "liqueur", "naiads", "paleoecology", "tenuous", "breathtaking", "hangnail", "topspin", "wardrobe", "worldly"])
    @test f.description == "contains ABA letter pattern"
end
