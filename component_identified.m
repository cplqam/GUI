function result = component_identified(file)

r = size(file,1);
result = [];

for i = 1:r
    component = file(i);
    identifications = {component.RESULTS.IDENTIFICATIONS};
    n_ident = sum(cellfun(@(x) size(x, 1), identifications));
    
    if n_ident > 0
        result = [result;i];
    end
end