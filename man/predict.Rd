\name{predict.mmer}
\alias{predict.mmer}
\title{Predict form of a LMM fitted with mmer}
\description{\code{predict} method for class \code{"mmer"}.
}
\usage{
\method{predict}{mmer}(object, classify=NULL, 
        hypertable=NULL,
        \dots)
}
\arguments{
 \item{object}{a mixed model of class \code{"mmer"}}
 \item{classify}{a character vector with the variables that define the margins of the multiway table to be aggregated.}
 \item{hypertable}{an optional table to force the terms to be included, ignored and averaged with same format as the output hypertable of this function (see examples).
 
 An ignored term means that the model matrices for that fixed or random effect are not used in the BLUP and SE calculation.
 
 An averaged term means that the model matrices for that fixed or random effect is filled purely with the value 1/#levels.
 
 }
 \item{\dots}{Further arguments to be passed to the model fit (i.e. iters, etc.).}
}
\details{
  This function allows to produce predictions specifying those variables that define the margins of the hypertable to be predicted (argument classify). Predictions are obtained for each combination of values of the specified variables that is present in the data set used to fit the model. See vignettes for more details. 
  
  For predicted values the pertinent design matrices X and Z together with BLUEs (b) and BLUPs (u) are multiplied and added together.
  
  predicted.value equal Xb + Zu.1 + ... + Zu.n
  
  For computing standard errors for predictions the parts of the coefficient matrix:
  
  C11 equal (X'ViX)-
  
  C12 equal 0 - [(X'V-X)-X' V- GZ] 
  
  C22 equal PEV equal G - [Z'G[V- - (VX*tXVXVX)]GZ']
  
  and are summarized as:
  
  standard.errors equal sqrt( rowSums(XC11*X') + rowSums(2*(XC12*Z')) + rowSums(ZC22*Z') )
  
  when both fixed and random effects are present in the inclusion set. If only fixed and random effects are included, only the respective terms from the SE for fixed or random effects are calculated.
  
 }
\value{

  \item{pvals}{the table of predictions according to the specified arguments.}
  
  \item{hypertable}{the summary table specifying the ignored, include and average sets.}
  
  \item{model}{the mixed model used within predict.}
  
  \item{C11}{the inverse of the coefficient matrix corresponding to the fixed effects.}
  
  \item{C12}{the inverse of the coefficient matrix corresponding to the covariance between fixed and random effects.}
  
  \item{C22}{the inverse of the coefficient matrix corresponding to the random effects.}
  
  \item{Xextended}{the model matrix for fixed effects used to compute BLUPs and SEs.}
  
  \item{Zextended}{the model matrix for random effects used to compute BLUPs and SEs.}
  
 }
 \references{
  Welham, S., Cullis, B., Gogel, B., Gilmour, A., and Thompson, R. (2004). Prediction in linear mixed models. Australian and New Zealand Journal of Statistics, 46, 325 - 347.
 }
\author{Giovanny Covarrubias \email{cova_ruber@live.com.mx}}
\seealso{\code{\link{predict}}, \code{\link{mmer}}}
\keyword{models}
\examples{

data(DT_yatesoats)
DT <- DT_yatesoats

m3 <- mmer(fixed=Y ~ V + N + V:N,
           random = ~ B + B:MP,
           rcov=~units,
           data = DT)
summary(m3)$varcomp

p0 <- predict.mmer(object=m3, classify = "N")
p0$hypertable; p0$pvals

p0 <- predict.mmer(object=m3, classify = "V")
p0$hypertable; p0$pvals

p0 <- predict.mmer(object=m3, classify = "B")
p0$hypertable; p0$pvals

p0 <- predict.mmer(object=m3, classify = c("V","N"))
p0$hypertable; p0$pvals

########################################
## Modify terms in the prediction
## Ignore a term: it doesn't include the 
## model matrix in the BLUP and its SE
########################################
p0 <- predict.mmer(object=m3, classify = "N")

# modify the prediction
hypertable <- p0$hypertable; hypertable
# ignore the B:MP random term
hypertable[6,c("ignored","include","average")] <- c(TRUE,FALSE,FALSE) 
hypertable

p1 <- predict.mmer(object=m3, classify = "N", hypertable = hypertable)
p1$pvals

########################################
## Modify terms in the prediction
## Average a term: it fills the model matrix
## for the term with 1/#levels affecting
## the BLUP and its SE
########################################
p0 <- predict.mmer(object=m3, classify = "N")

# modify the prediction
hypertable <- p0$hypertable; hypertable
# average the V:N fixed term
hypertable[4,c("ignored","include","average")] <- c(FALSE,TRUE,TRUE) 
hypertable

p1 <- predict.mmer(object=m3, classify = "N", hypertable = hypertable)
p1$pvals

}
