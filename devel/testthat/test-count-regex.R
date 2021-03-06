require(testthat)
context("test-count-regex.R")

test_that("stri_count_regex", {
   expect_identical(stri_count_regex(character(0)," "),integer(0))
   expect_identical(stri_count_regex(NA,"a"),NA_integer_)
   expect_identical(stri_count_regex("NA",NA),NA_integer_)
   expect_identical(stri_count_regex("   "," "),3L)
   expect_identical(stri_count_regex("###",c("#","##","###")),c(3L,1L,1L))
   expect_identical(stri_count_regex("a a","a"),2L)
   expect_identical(stri_count_regex("aba","abcdef"),0L)
   suppressWarnings(expect_identical(stri_count_regex("",""), NA_integer_))
   suppressWarnings(expect_identical(stri_count_regex("a",""), NA_integer_))


   expect_identical(stri_count_regex(c("\u0105\u0106\u0107", "\u0105\u0107"), "\u0106*"), c(4L, 3L)) # match of zero length
   expect_identical(stri_count_regex(c("\u0105\u0106\u0107", "\u0105\u0107"), "(?<=\u0106)"), c(1L, 0L)) # match of zero length:

   s <- "Lorem ipsum dolor sit amet, consectetur adipisicing elit. Proin
nibh augue, suscipit a, scelerisque sed, lacinia in, mi. Cras vel
lorem. Etiam pellentesque aliquet tellus. Phasellus pharetra nulla ac
diam. Quisque semper justo at risus. Donec venenatis, turpis vel
hendrerit interdum, dui ligula ultricies purus, sed posuere libero dui
id orci. Nam congue, pede vitae dapibus aliquet, elit magna vulputate
arcu, vel tempus metus leo non est. Etiam sit amet lectus quis est
congue mollis. Phasellus congue lacus eget neque. Phasellus ornare,
ante vitae consectetuer consequat, purus sapien ultricies dolor, et
mollis pede metus eget nisi. Praesent sodales velit quis augue. Cras
suscipit, urna at aliquam rhoncus, urna quam viverra nisi, in interdum
massa nibh nec erat."
   s <- stri_dup(s,1:3)
   expect_warning(stri_count_regex(s,c("o","a")))
   expect_error(stri_count_regex(s,"[[:numbers:]]"))
   expect_identical(stri_count_regex("ALA","ala"), 0L)
   expect_identical(stri_count_regex("ALA","ala",stri_opts_regex(case_insensitive=TRUE)), 1L)
   expect_identical(stri_count_regex(s,"m [[a-z]]"), 1:3*7L)
   expect_identical(stri_count_regex(s,"m, [[a-z]]"), 1:3)
   expect_identical(stri_count_regex(s,"[[:digit:]]"), c(0L,0L,0L))
   expect_identical(stri_count_regex(s," [[a-z]]*\\. Phasellus (ph|or|co)"), 1:3*3L)
   s <- c("abababab babab abab bbaba","a")
   expect_identical(stri_count_regex(s,"bab"),c(5L,0L))
   expect_identical(stri_count_regex(c("lalal","12l34l56","\u0105\u0f3l\u0142"),"l"),3:1)
   expect_equivalent(stri_count_regex("aaaab", "ab"), 1L)
   expect_equivalent(stri_count_regex("bababababaab", "aab"), 1L)

   expect_identical(stri_count_regex("X\U00024B62\U00024B63\U00024B64X",
                               c("\U00024B62", "\U00024B63", "\U00024B64", "X")),
                                      c(1L, 1L, 1L, 2L))
})
