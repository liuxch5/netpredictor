#' Export file to GML
#' @name saveGML
#' @title save as GML 
#' @description Export an igraph object to GML file which can be in Cytoscape or Gephi.
#' @param g igraph object
#' @param fileName exported file name
#' @param title title of the exported file name
#' @return Outputs a GML format file for loading into cytoscape.s
#' @usage saveGMLsaveGML(g,fileName="netresult.gml",title="netresult")
#' @export  

saveGML = function(g, fileName, title = "untitled") {
    attrToString = function(x) {
        m = mode(x)
        if(m == "numeric") {
            xc = sprintf("%.12f", x)
            
            xc[is.na(x)] = "NaN"
            xc[x == "Infinity"]= "Infinity"
            xc[x == "-Infinity"]= "-Infinity"
            x = xc
        } else {
            #Escape invalid characters
            x = gsub('"', "'", x)
            x = paste("\"", x , "\"", sep="")
        }
        x
    }
    
    illAttrChar = "[ -]"
    vAttrNames = list.vertex.attributes(g)
    vAttrNames = vAttrNames[vAttrNames != "id"]
    vAttr = lapply(vAttrNames, function(x) attrToString(get.vertex.attribute(g, x)))
    names(vAttr) = gsub(illAttrChar, "", vAttrNames)
    eAttrNames = list.edge.attributes(g)
    eAttrNames = eAttrNames[eAttrNames != "id"]
    eAttr = lapply(eAttrNames, function(x) attrToString(get.edge.attribute(g, x)))
    names(eAttr) = gsub(illAttrChar, "", eAttrNames)
    
    f = file(fileName, "w")
    cat("graph\n[", file=f)
    cat(" directed ", as.integer(is.directed(g)), "\n", file=f)
    for(i in seq_len(vcount(g))) {
        cat(" node\n [\n", file=f)
        cat("    id", i, "\n", file=f)
        for(n in names(vAttr)) {
            cat("   ", gsub("[\\._]", "", n), vAttr[[n]][i], "\n", file=f)
        }
        cat(" ]\n", file=f)
    }
    
    el = get.edgelist(g, names=FALSE)
    for (i in seq_len(nrow(el))) { 
        cat(" edge\n  [\n", file=f) 
        cat("  source", el[i,1], "\n", file=f) 
        cat("  target", el[i,2], "\n", file=f) 
        for(n in names(eAttr)) {
            cat("   ", gsub("[\\._]", "", n), eAttr[[n]][i], "\n", file=f)
        }
        cat(" ]\n", file=f) 
    }
    
    cat("]\n", file=f)
    cat("Title \"", title, '"', file=f, sep="")
    close(f)
}

#' Export file to GML
#' @name saveASGEXF
#' @title save as GEXF
#' @description Export an igraph object to gexf format graph file which can be in opened in Gephi.
#' @param g igraph object
#' @param filepath output graph name
#' @return Outputs a Gephi format gexf graph
#' @usage saveAsGEXF(g, filepath="output.gexf")
#' @export

saveAsGEXF = function(g, filepath="output.gexf")
{
    # gexf nodes require two column data frame (id, label)
    if(is.null(igraph::V(g)$label))
        igraph::V(g)$label <- as.character(igraph::V(g)$name)
    
    # similarily if edges does not have weight, add default 1 weight
    if(is.null(igraph::E(g)$weight))
        igraph::E(g)$weight <- rep.int(1, igraph::ecount(g))
    
    nodes <- data.frame(cbind(V(g), V(g)$label))
    edges <- t(Vectorize(igraph::get.edge, vectorize.args='id')(g, 1:igraph::ecount(g)))
    
    # combine all node attributes into a matrix (and take care of & for xml)
    vAttrNames <- setdiff(igraph::list.vertex.attributes(g), "label") 
    nodesAtt <- data.frame(sapply(vAttrNames, function(attr) sub("&", "&#038;",igraph::get.vertex.attribute(g, attr))))
    
    # combine all edge attributes into a matrix (and take care of & for xml)
    eAttrNames <- setdiff(igraph::list.edge.attributes(g), "weight") 
    edgesAtt <- data.frame(sapply(eAttrNames, function(attr) sub("&", "&#038;",igraph::get.edge.attribute(g, attr))))
    
    # combine all graph attributes into a meta-data
    graphAtt <- sapply(igraph::list.graph.attributes(g), function(attr) sub("&", "&#038;",igraph::get.graph.attribute(g, attr)))
    
    # generate the gexf object
    output <- write.gexf(nodes, edges, 
                         edgesWeight=igraph::E(g)$weight,
                         edgesAtt = edgesAtt,
                         nodesAtt = nodesAtt,
                         meta=c(list(description="igraph -> gexf converted file", keywords="igraph, gexf, R, rgexf"), graphAtt))
    
    print(output, filepath, replace=T)
}





