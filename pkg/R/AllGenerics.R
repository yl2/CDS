if(!isGeneric("summary"))
    setGeneric("summary", function(object,
                                   ...) standardGeneric("summary"))

if(!isGeneric("calcSpreadDV01"))
    setGeneric("calcSpreadDV01", function(object) standardGeneric("calcSpreadDV01"))
