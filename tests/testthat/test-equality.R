context("Equality")

test_that("data frames equal to themselves", {
  expect_true(all.equal(as_data_frame(mtcars), as_data_frame(mtcars)))
  expect_true(all.equal(as_data_frame(iris), as_data_frame(iris)))
  expect_true(all.equal(as_data_frame(df_all), as_data_frame(df_all)))
})

test_that("data frames equal to random permutations of themselves", {
  scramble <- function(x){
    x[sample(nrow(x)), sample(ncol(x)), drop = FALSE]
  }

  expect_equal(as_data_frame(mtcars), as_data_frame(scramble(mtcars)))
  expect_equal(as_data_frame(iris), as_data_frame(scramble(iris)))
  expect_equal(as_data_frame(df_all), as_data_frame(scramble(df_all)))
})

test_that("data frames not equal if missing row", {
  expect_match(all.equal(as_data_frame(mtcars), as_data_frame(mtcars)[-1, ]), "Different number of rows")
  expect_match(all.equal(as_data_frame(iris), as_data_frame(iris)[-1, ]),     "Different number of rows")
  expect_match(all.equal(as_data_frame(df_all), as_data_frame(df_all)[-1, ]), "Different number of rows")
})

test_that("data frames not equal if missing col", {
  expect_match(all.equal(as_data_frame(mtcars), as_data_frame(mtcars)[, -1]), "Cols in x but not y: 'mpg'")
  expect_match(all.equal(as_data_frame(mtcars)[, -1], as_data_frame(mtcars)), "Cols in y but not x: 'mpg'")
  expect_match(all.equal(as_data_frame(iris), as_data_frame(iris)[, -1]),     "Cols in x but not y: 'Sepal.Length'")
  expect_match(all.equal(as_data_frame(df_all), as_data_frame(df_all)[, -1]), "Cols in x but not y: 'a'")
  expect_match(all.equal(as_data_frame(mtcars), rev(as_data_frame(mtcars)),
                         ignore_col_order = FALSE),
               "Column names same but in different order")
})

test_that("factors equal only if levels equal", {
  df1 <- data.frame(x = factor(c("a", "b")))
  df2 <- data.frame(x = factor(c("a", "d")))
  expect_match(all.equal(as_data_frame(df1), as_data_frame(df2)), "Factor levels not equal for column x" )
})

test_that("all.equal.data.frame handles data.frames with NULL names", {
  x <- data.frame(LETTERS[1:3], rnorm(3))
  names(x) <- NULL
  expect_true(all.equal(x,x))
})

test_that( "data frame equality test with ignore_row_order=TRUE detects difference in number of rows. #1065", {
  DF1 <- data_frame(a = 1:4, b = letters[1:4])
  DF2 <- data_frame(a = c(1:4,4L), b = letters[c(1:4,4L)])
  expect_false( isTRUE(all.equal(DF1, DF2, ignore_row_order=TRUE)))

  DF1 <- data_frame(a = c(1:4,2L), b = letters[c(1:4,2L)])
  DF2 <- data_frame(a = c(1:4,4L), b = letters[c(1:4,4L)])
  expect_false(isTRUE(all.equal(DF1, DF2, ignore_row_order=TRUE)))

})

test_that("all.equal handles NA_character_ correctly. #1095", {
  d1 <- data_frame(x = c(NA_character_))
  expect_true(all.equal(d1, d1))

  d2 <- data_frame( x = c(NA_character_, "foo", "bar" ) )
  expect_true(all.equal(d2, d2))
})

test_that( "handle Date columns of different types, integer and numeric (#1204)", {
  a <- data.frame(date = as.Date("2015-06-07"))
  b <- data.frame(date = structure( as.integer(a$date), class = "Date" ) )
  expect_true( all.equal(a, b) )
})

test_that("equality test fails when convert is FALSE and types don't match (#1484)", {
  df1 <- data_frame(x = "a")
  df2 <- data_frame(x = factor("a"))

  expect_equal( all.equal(df1, df2, convert = FALSE), "Incompatible type for column x: x character, y factor" )
  expect_warning( all.equal(df1, df2, convert = TRUE) )
})

test_that("equality handles data frames with 0 columns (#1506)", {
  df0 <- data_frame(x = numeric(0), y = character(0) )
  expect_equal(df0, df0)
})

test_that("equality fails if types different", {
  expect_equal(all.equal(as_data_frame(iris), iris), "Different types: x 'tbl_df', 'tbl', 'data.frame', y 'data.frame'")
})
