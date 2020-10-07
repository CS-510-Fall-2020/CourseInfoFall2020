# Sample testing script

context("testing sample")
source("../functions.R")

library(testthat)
addtwo <- function(x) x+2


test_that("integer", {
  expect_equal(addtwo(-1),1)
  expect_equal(addtwo(10),12)
})

test_that("vector", {
  expect_equal(addtwo(c(0,11)),c(2,13))
  expect_equal(addtwo(c(-3,2)),c(-1,4))
})

test_that("list",{
  expect_error(addtwo(list(1)),"non-numeric argument to binary operator")
})

test_that("empty vector",{
  expect_equal(addtwo(c()),numeric(0))
})