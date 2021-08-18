#Extract lines from TASA corpus to separate files

# Install the library of LSA routines
#install.packages("lsa")

# Establish and set up the wording directory
#dir.create("/Users/jamiesor/Desktop/LSA/")
unlink("/Users/jamiesor/Desktop/LSA/TASA/", recursive=TRUE) 
dir.create("/Users/jamiesor/Desktop/LSA/TASA/")

# Read and import the TASA database as an internal table
Whole_corpus = read.table("/Users/jamiesor/Desktop/LSA/tasaDocsPara.txt", 
                          sep="\t", 
                          fill=FALSE, 
                          strip.white=TRUE)

# Parse the TASA database into separate document files
N_sample <- 2000
setwd("/Users/jamiesor/Desktop/LSA/TASA")
a <- sample(nrow(Whole_corpus), N_sample, replace=FALSE)
for (i in 1:N_sample) {
  write(toString(Whole_corpus[a[i],1]), toString(a[i]))
}

# Construct the textmatrix from files in assigned directory
Input_matrix = textmatrix("/Users/jamiesor/Desktop/LSA/TASA")

# Weight the textmatrix
Input_matrix = lw_logtf(Input_matrix) * gw_idf(Input_matrix)

# Compute the semantic space in [dims] dimensions
Semantic_space = lsa(Input_matrix, dims=20) 

# Get vectors
Vectors = as.textmatrix(Semantic_space)

# Search the derived space
associate(Vectors, "cognitive", measure="cosine", threshold = 0.6)


# Matt's Code
library(dplyr)
library(tm)
library(stringr)

# Import TASA separated by paragraphs
TASA <- read.table("corpus_modeling/TASA/tasaDocsPara.txt", 
                          sep="\t", 
                          fill=FALSE, 
                          strip.white=TRUE)
# convert to tm corpus
TASA <- TASA %>% mutate(V1 = as.character(V1))
vTASA <- VCorpus(VectorSource(TASA$V1[1:10000]))

# document term matrix
dtm <- DocumentTermMatrix(vTASA)
m <- as.matrix(dtm)

