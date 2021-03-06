% Generated by roxygen2 (4.1.1): do not edit by hand
% Please edit documentation in R/search_split_bound.R
\name{stri_split_boundaries}
\alias{stri_split_boundaries}
\title{Split a String at Specific Text Boundaries}
\usage{
stri_split_boundaries(str, n = -1L, tokens_only = FALSE, simplify = FALSE,
  ..., opts_brkiter = NULL)
}
\arguments{
\item{str}{character vector or an object coercible to}

\item{n}{integer vector, maximal number of strings to return}

\item{tokens_only}{single logical value; may affect the result if \code{n}
is positive, see Details}

\item{simplify}{single logical value; if \code{TRUE} or \code{NA},
then a character matrix is returned; otherwise (the default), a list of
character vectors is given, see Value}

\item{...}{additional settings for \code{opts_brkiter}}

\item{opts_brkiter}{a named list with \pkg{ICU} BreakIterator's settings
as generated with \code{\link{stri_opts_brkiter}}; \code{NULL} for the
default break iterator, i.e. \code{line_break}}
}
\value{
If \code{simplify=FALSE} (the default),
then the functions return a list of character vectors.

Otherwise, \code{\link{stri_list2matrix}} with \code{byrow=TRUE}
and \code{n_min=n} arguments is called on the resulting object.
In such a case, a character matrix with \code{length(str)} rows
is returned. Note that \code{\link{stri_list2matrix}}'s \code{fill}
argument is set to an empty string and \code{NA},
for \code{simplify} equal to \code{TRUE} and \code{NA}, respectively.
}
\description{
This function locates specific text boundaries
(like character, word, line, or sentence boundaries)
and splits strings at the indicated positions.
}
\details{
Vectorized over \code{str} and \code{n}.

If \code{n} is negative (default), then all pieces are extracted.
Otherwise, if \code{tokens_only} is \code{FALSE} (this is the default,
for compatibility with the \pkg{stringr} package), then \code{n-1}
tokes are extracted (if possible) and the \code{n}-th string
gives the (non-split) remainder (see Examples).
On the other hand, if \code{tokens_only} is \code{TRUE},
then only full tokens (up to \code{n} pieces) are extracted.

For more information on the text boundary analysis
performed by \pkg{ICU}'s \code{BreakIterator}, see
\link{stringi-search-boundaries}.
}
\examples{
test <- "The\\u00a0above-mentioned    features are very useful. " \%s+\%
   "Warm thanks to their developers. 123 456 789"
stri_split_boundaries(test, type="line")
stri_split_boundaries(test, type="word")
stri_split_boundaries(test, type="word", skip_word_none=TRUE)
stri_split_boundaries(test, type="word", skip_word_none=TRUE, skip_word_letter=TRUE)
stri_split_boundaries(test, type="word", skip_word_none=TRUE, skip_word_number=TRUE)
stri_split_boundaries(test, type="sentence")
stri_split_boundaries(test, type="sentence", skip_sentence_sep=TRUE)
stri_split_boundaries(test, type="character")
}
\seealso{
Other locale_sensitive: \code{\link{\%s!==\%}},
  \code{\link{\%s!=\%}}, \code{\link{\%s<=\%}},
  \code{\link{\%s<\%}}, \code{\link{\%s===\%}},
  \code{\link{\%s==\%}}, \code{\link{\%s>=\%}},
  \code{\link{\%s>\%}}, \code{\link{\%stri!==\%}},
  \code{\link{\%stri!=\%}}, \code{\link{\%stri<=\%}},
  \code{\link{\%stri<\%}}, \code{\link{\%stri===\%}},
  \code{\link{\%stri==\%}}, \code{\link{\%stri>=\%}},
  \code{\link{\%stri>\%}}; \code{\link{stri_cmp}},
  \code{\link{stri_cmp_eq}}, \code{\link{stri_cmp_equiv}},
  \code{\link{stri_cmp_ge}}, \code{\link{stri_cmp_gt}},
  \code{\link{stri_cmp_le}}, \code{\link{stri_cmp_lt}},
  \code{\link{stri_cmp_neq}},
  \code{\link{stri_cmp_nequiv}},
  \code{\link{stri_compare}};
  \code{\link{stri_count_boundaries}},
  \code{\link{stri_count_words}};
  \code{\link{stri_duplicated}},
  \code{\link{stri_duplicated_any}};
  \code{\link{stri_enc_detect2}};
  \code{\link{stri_extract_all_boundaries}},
  \code{\link{stri_extract_all_words}},
  \code{\link{stri_extract_first_boundaries}},
  \code{\link{stri_extract_first_words}},
  \code{\link{stri_extract_last_boundaries}},
  \code{\link{stri_extract_last_words}};
  \code{\link{stri_locate_all_boundaries}},
  \code{\link{stri_locate_all_words}},
  \code{\link{stri_locate_first_boundaries}},
  \code{\link{stri_locate_first_words}},
  \code{\link{stri_locate_last_boundaries}},
  \code{\link{stri_locate_last_words}};
  \code{\link{stri_opts_collator}};
  \code{\link{stri_order}}, \code{\link{stri_sort}};
  \code{\link{stri_trans_tolower}},
  \code{\link{stri_trans_totitle}},
  \code{\link{stri_trans_toupper}};
  \code{\link{stri_unique}}; \code{\link{stri_wrap}};
  \code{\link{stringi-locale}};
  \code{\link{stringi-search-boundaries}};
  \code{\link{stringi-search-coll}}

Other search_split: \code{\link{stri_split_lines}},
  \code{\link{stri_split_lines1}},
  \code{\link{stri_split_lines1}};
  \code{\link{stri_split}},
  \code{\link{stri_split_charclass}},
  \code{\link{stri_split_coll}},
  \code{\link{stri_split_fixed}},
  \code{\link{stri_split_regex}};
  \code{\link{stringi-search}}

Other text_boundaries: \code{\link{stri_count_boundaries}},
  \code{\link{stri_count_words}};
  \code{\link{stri_extract_all_boundaries}},
  \code{\link{stri_extract_all_words}},
  \code{\link{stri_extract_first_boundaries}},
  \code{\link{stri_extract_first_words}},
  \code{\link{stri_extract_last_boundaries}},
  \code{\link{stri_extract_last_words}};
  \code{\link{stri_locate_all_boundaries}},
  \code{\link{stri_locate_all_words}},
  \code{\link{stri_locate_first_boundaries}},
  \code{\link{stri_locate_first_words}},
  \code{\link{stri_locate_last_boundaries}},
  \code{\link{stri_locate_last_words}};
  \code{\link{stri_opts_brkiter}};
  \code{\link{stri_split_lines}},
  \code{\link{stri_split_lines1}},
  \code{\link{stri_split_lines1}};
  \code{\link{stri_trans_tolower}},
  \code{\link{stri_trans_totitle}},
  \code{\link{stri_trans_toupper}};
  \code{\link{stri_wrap}};
  \code{\link{stringi-search-boundaries}};
  \code{\link{stringi-search}}
}

