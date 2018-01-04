@testset "the egg plant" begin
    # tinyurl.com/nplbarexam Main-D-EggPlant.pdf
    f = best_feature(["cardioid", "liqueur", "naiads", "paleoecology", "tenuous", "breathtaking", "hangnail", "topspin", "wardrobe", "worldly"])
    @test f.description == "contains ABA letter pattern"

    f = best_feature(["despumate", "motorcade", "overboard", "shared", "simoleon"])
    @test f.description == "contains a word from category 'animals'"

    f = best_feature(["beggar", "deliver", "fiendish", "multiple", "swordsman"])
    @test f.description == "contains letters of a word from category 'animals'"

    f = best_feature(["brazen", "coatimundi", "hatred", "socket", "vestibule"])
    @test f.description == "contains a word from category 'clothing'"
end
