function database = database2struct_HMDB(path)

files = dir(path);
name_files = {files(~[files.isdir]).name};
name = {};
colision = {};
ionization = {};
inch = {};
adduct = {};
adduct_type = {};
precursor = {};
ms2 = {};

for f = 1:size(name_files,2)
    filename = strcat(path,'\',name_files{f});
    data = readlines(filename);
    ms2_sp = [];
    s = 1;
    for n = 1:(size(data,1)-1)
        row = data(n);
        row = regexp(row,'[<>]','split');
        if row(2) == 'database-id'
            name{f,1} = row(3);
        elseif row(2) == 'collision-energy-voltage'
            colision{f,1} = row(3);
        elseif row(2) == 'ionization-mode'
            ionization{f,1} = row(3);
        elseif row(2) == 'adduct'
            adduct{f,1} = convertCharsToStrings(row{3});
        elseif row(2) == 'adduct-type'
            adduct_type{f,1} = row(3);
        elseif row(2) == 'adduct-mass'
            precursor{f,1} = str2num(row(3));
        elseif row(2) == 'mass-charge'
            ms2_sp(s,1) = str2num(row(3));
        elseif row(2) == 'intensity'
            ms2_sp(s,2) = str2num(row(3));
            s = s+1;
        end
    end
    ms2_sp = unique(ms2_sp,"rows");
    ms2{f,1} = ms2_sp;
    
    inch{f,1} = convertCharsToStrings("NaN");
    if mod(f,1000) == 0
        f
    end
end
max_size = size(name,1);
if size(precursor,1) < max_size
    precursor{max_size,1} = [];
end
if size(adduct,1) < max_size
    adduct{max_size,1} = [];
end
if size(adduct_type,1) < max_size
    adduct_type{max_size,1} = [];
end
if size(colision,1) < max_size
    colision{max_size,1} = [];
end
% inch = cellstr(repmat('-',size(precursor,1),1));

database = struct('NAME', name, 'PRECURSORMZ', precursor, 'PRECURSORTYPE', adduct, 'ADDUCT_type', adduct_type, 'COLISION_ENERGY', colision, 'INCHIKEY', inch, 'IONIZATION', ionization, 'MS2', ms2);
empty_mz = find(arrayfun(@(x) isempty(x.('PRECURSORMZ')), database));
database(empty_mz) = [];
end