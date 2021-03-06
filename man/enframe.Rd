% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/enframe.R
\name{enframe}
\alias{enframe}
\title{Converting atomic vectors to data frames}
\usage{
enframe(x, name = "name", value = "value")
}
\arguments{
\item{x}{An atomic vector}

\item{name, value}{Names of the columns that store the names and values}
}
\value{
A \code{\link{data_frame}}
}
\description{
A helper function that converts named atomic vectors or lists to two-column
data frames.
For unnamed vectors, the natural sequence is used as name column.
}
\examples{
enframe(1:3)
enframe(c(a = 5, b = 7))
}

