function scrabble_score(word::String)
    score = 0
    for c in word
        score += scrabble_score(c)
    end
    score
end

scrabble_score(char::Char) = SCRABBLE_SCORES[char]

const SCRABBLE_SCORES = Dict{Char, Int}(
    'e' => 1,
    'a' => 1,
    'i' => 1,
    'o' => 1,
    'n' => 1,
    'r' => 1,
    't' => 1,
    'l' => 1,
    's' => 1,
    'u' => 1,
    'd' => 2,
    'g' => 2,
    'b' => 3,
    'c' => 3,
    'm' => 3,
    'p' => 3,
    'f' => 4,
    'h' => 4,
    'v' => 4,
    'w' => 4,
    'y' => 4,
    'k' => 5,
    'j' => 8,
    'x' => 8,
    'q' => 10,
    'z' => 10
    )

const VOWELS = Set(collect("aeiouy"))
const CONSONANTS = Set(collect("bcdfghjklmnpqrstvwxyz"))
isconsonant(char) = char in CONSONANTS
isvowel(char) = char in VOWELS

num_unique_vowels(word) = length(Set(filter(isvowel, word)))
num_unique_consonants(word) = length(Set(filter(isconsonant, word)))
num_unique_letters(word) = length(Set(word))
alternates_consonant_vowel(word) = consonant_then_vowel(word) || vowel_then_consonant(word)
function consonant_then_vowel(word)
    expected = true
    for c in word
        if isconsonant(c) != expected
            return false
        end
        expected = !expected
    end
    true
end
function vowel_then_consonant(word)
    expected = true
    for c in word
        if isvowel(c) != expected
            return false
        end
        expected = !expected
    end
    true
end
function contains_double_letter(word)
    for i in 1:(length(word) - 1)
        if word[i] == word[i+1]
            return true
        end
    end
    return false
end

function contains_repeated_letter(word)
    for i in 1:length(word) - 1
        for j in (i + 1):length(word)
            if word[i] == word[j]
                return true
            end
        end
    end
    return false
end

contains_day_of_week(word) = ismatch(r"(sat)|(sun)|(mon)|(tue)|(wed)|(thu)|(fri)", word)

"""
Letters are alpha, then reverse alpha
"""
function is_hill(word)
    diffs = diff(collect(word))
    has_rise = false
    has_fall = false
    rising = true
    for d in diffs
        if d > 0
            if !rising
                return false
            end
            has_rise = true
        elseif d < 0
            rising = false
            has_fall = true
        end
    end
    has_rise && has_fall
end

"""
Letters are reverse alpha, then alpha
"""
function is_valley(word)
    diffs = diff(collect(word))
    has_rise = false
    has_fall = false
    rising = false
    for d in diffs
        if d < 0
            if rising
                return false
            end
            has_fall = true
        elseif d > 0
            rising = true
            has_rise = true
        end
    end
    has_rise && has_fall
end

function is_sequential(a::AbstractArray)
    for i in 1:(length(a) - 1)
        a[i+1] == a[i] + 1 || return false
    end
    true
end

"""
Letter tally is 1, 2, 3, etc.
"""
function is_pyramid(word)
    letter_tallies = zeros(Int, 26)
    for c in word
        letter_tallies[c - 'a' + 1] += 1
    end
    nonzero_tallies = Int[t for t in letter_tallies if t > 0]
    is_sequential(sort!(nonzero_tallies))
end

function num_alpha_bigrams(word)
    count = 0
    for i in 1:(length(word) - 1)
        if word[i] < word[i + 1]
            count += 1
        end
    end
    count
end

function num_reverse_alpha_bigrams(word)
    count = 0
    for i in 1:(length(word) - 1)
        if word[i] > word[i + 1]
            count += 1
        end
    end
    count
end

function allfeatures()
    Feature[
        @feature((scrabble_score(word) == j for j in 1:26), "has scrabble score $j")
        @feature((c in word for c in 'a':'z'), "contains '$c'")
        @feature((length(word) >= j && word[j] == c for c in 'a':'z', j in 1:26), "contains '$c' at index $j")
        @feature((length(word) >= j && word[end - j + 1] == c for c in 'a':'z', j in 1:26), "contains '$c' at index $j from end")
        @feature((num_unique_vowels(word) == j for j in 1:5), "has $j unique vowels")
        @feature((num_unique_consonants(word) == j for j in 1:21), "has $j unique consonants")
        @feature((num_unique_letters(word) == j for j in 1:26), "has $j unique letters")
        @feature((alternates_consonant_vowel(word)), "alternates consonant vowel")
        @feature((contains_double_letter(word)), "contains a double letter")
        @feature(contains_repeated_letter(word), "contains a repeated letter")
        @feature(contains_day_of_week(word), "contains a day of the week abbreviation")
        @feature(is_hill(word), "is a hill word")
        @feature(is_valley(word), "is a valley word")
        @feature(word == reverse(word), "is a palindrome")
        @feature(is_pyramid(word), "is a pyramid word")
        @feature((num_alpha_bigrams(word) == j for j in 0:10), "has $j alphabetical bigrams")
        @feature((num_reverse_alpha_bigrams(word) == j for j in 0:10), "has $j reverse alphabetical bigrams")
        ]
end
