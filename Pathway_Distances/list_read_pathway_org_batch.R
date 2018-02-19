suppressWarnings(suppressMessages(library(KEGGgraph)))
suppressWarnings(suppressMessages(library(graph)))
suppressWarnings(suppressMessages(library(RBGL)))
library(KEGGgraph)
library(Rgraphviz)
library(RBGL)
library(parallel)
library(stringi)
library(graph)

shortestPathOrInPathway = function(graph, node1, node2){
  if(is.element(node1, nodes(graph)) && is.element(node2, nodes(graph))){
    val = RBGL::sp.between(graph, node1, node2)
    if(is.na(val[[1]]$length)){
      val = RBGL::sp.between(graph, node2, node1)
    }
    return(val[[1]]$length)
  }
  return(NULL)
}

allShortestPaths = function(graphlist, namelist, node1, node2){
  for(j in 1:length(graphlist)){
    i = graphlist[[j]]
    name = namelist[[j]][1]
    if(is.element(node1, nodes(i)) && is.element(node2, nodes(i))){
      #print(paste(node1, node2, "in pathway"))
      pwayl = shortestPathOrInPathway(i, node1, node2)
      if(is.na(pwayl)){
        #bothinpathwaybutnotconnected
      	print(c(name, "bipbnc"))
      } else {
        print(c(name , pwayl))
      }
    }
    else{
      #print(paste(node1, node2, "not in pathway"))
    }
  }
}

readOrganismFiles = function(organismFiles){
  #pb = txtProgressBar(min = 0, initial = 0, max = length(organismFiles), style = 3)
  graphlist = list()
  namelist = list()
  cnt = 0
  for (i in organismFiles){
    #print(i)
    graph = parseKGML2Graph(i, genesOnly=FALSE, expandGenes=TRUE)
    graphlist = c(graphlist, graph)
    isplit = strsplit(i, "/")[[1]]
    name = isplit[length(isplit)]
    namelist = c(namelist, name)
    cnt = cnt + 1
    #setTxtProgressBar(pb, value = cnt)
  }
  return(list(graphlist, namelist))
}

args = commandArgs(TRUE)
pair_list = readr::read_csv(file = args[1], col_names = FALSE)
current_pairs = list()
comborg = NULL
pathway_list = NULL
name_list = NULL
current_kegg_name = ""
for(i in 1:nrow(pair_list)){
  kegg_name = strsplit(pair_list[[1]][i], ":")[[1]][1]
  print(kegg_name)
  if(kegg_name != current_kegg_name){
    comborg = readOrganismFiles(dir(paste("KEGG_ORGANISM/path_lists/paths_", kegg_name, ".list.dir/", sep=""), full.names = TRUE))
    pathway_list = comborg[[1]]
    name_list = comborg[[2]]
    merged = mergeKEGGgraphs(pathway_list, edgemode = "directed")
    print("Graphs merged!")
    current_kegg_name = kegg_name
  }
  c1 = pair_list[[1]][i]
  c2 = pair_list[[2]][i]
  print(c("check ", c1, c2))
  try(allShortestPaths(pathway_list, name_list ,c1, c2))
  print(c("merged", shortestPathOrInPathway(merged, c1, c2)))
}
print("###exit_without_error")
