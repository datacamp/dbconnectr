context("utils")

test_that("cpaste and spaste work as expected", {
  expect_equal(cpaste(c("a", "b", "c")), "a\nb\nc")
  expect_equal(cpaste(c("a")), "a")
  expect_equal(spaste("a", "b", "c"), "a\nb\nc")
  expect_equal(spaste("a"), "a")
})
