% Generated by roxygen2 (4.1.1): do not edit by hand
% Please edit documentation in R/functions.R
\name{get.biClosenessCentralit}
\alias{get.biClosenessCentralit}
\alias{get.biClosenessCentrality}
\title{Closeness centrality for bipartite graphs.}
\usage{
get.biClosenessCentrality(A, SM = TRUE)
}
\arguments{
\item{A}{Biparite matrix object}

\item{SM}{Either TRUE or FALSE . If TRUE returns average centrality for rows and columns. If false returns degree centrality for all the nodes.}
}
\value{
Returns a list scores of closeness centrality of the nodes.By deafult \code{SM=TRUE} which return the closeness centrality for two different sets of nodes.
}
\description{
Measures Closeness centrality of bipartite graphs . The closeness centrality of a vertex is inversely proportional to the total geodesic distance to all other vertices.
It also has way to calculate single mode betweeness centrality. Single mode centralization for bipartite graphs measures the extent to which vertices in one vertex subset are central relative only to other vertices in the same subset.
This function is the adaption to bipartite graphs as presented in Borgatti and Everett (1997).
}
\details{
Closeness centrality for bipartite graphs
}
\references{
\itemize{
  \item Borgatti, S. P. and Everett, M. G. (1997) Network analysis of 2--mode data. Social Networks \bold{19}, 243--269.
  }
}

