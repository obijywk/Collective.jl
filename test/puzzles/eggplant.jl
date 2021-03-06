@testset "the egg plant" begin
    # tinyurl.com/nplbarexam Main-D-EggPlant.pdf
    f = best_feature(["cardioid", "liqueur", "naiads", "paleoecology", "tenuous", "breathtaking", "hangnail", "topspin", "wardrobe", "worldly"], 0)
    @test f.description == "contains ABA letter pattern"

    f = best_feature(["despumate", "motorcade", "overboard", "shared", "simoleon"], 0)
    @test f.description == "contains a word from category 'animals'"

    f = best_feature(["beggar", "deliver", "fiendish", "multiple", "swordsman"], 0)
    @test f.description == "contains letters of a word from category 'animals'"

    f = best_feature(["brazen", "coatimundi", "hatred", "socket", "vestibule"], 0)
    @test f.description == "contains a word from category 'clothing'"

    f = best_feature(["edens", "emanate", "gratin", "rancho", "select"], 0)
    @test f.description == "is a word when first letter moved to back"

    f = best_feature(["earth", "ingles", "ought", "raked", "those"], 0)
    @test f.description == "is a word when last letter moved to front"
end
