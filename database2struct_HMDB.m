function database = database2struct_HMDB(file)
%import as string. Delimiters > and <. Columns 2:3
name = {};
colision = {};
ionization = {};
inch = {};
adduct = {};
adduct_type = {};
precursor = {};
ms2 = {};

s = 1;
ms2_s = [];
ms2_i = [];
for n = 1:size(file,1)
    row = file(n,:);
    if row(1) == 'database-id'
        name{s,1} = row(2);
    elseif row(1) == 'collision-energy-voltage'
        colision{s,1} = row(2);
    elseif row(1) == 'ionization-mode'
        ionization{s,1} = row(2);
    elseif row(1) == 'adduct'
        adduct{s,1} = convertCharsToStrings(row{2});
    elseif row(1) == 'adduct-type'
        adduct_type{s,1} = row(2);
    elseif (row(1) == 'adduct-mass') & (row(2) ~= '-1.0')
        precursor{s,1} = str2num(row(2));
    elseif row(1) == 'mass-charge'
        ms2_s = [ms2_s; str2num(row(2))];
    elseif row(1) == 'intensity'
        ms2_i = [ms2_i; str2num(row(2))];
    elseif row(1) == '/ms-ms-peaks'
        ms2_sp = [ms2_s,ms2_i];
        ms2_sp = unique(ms2_sp,"rows");
        ms2{s,1} = ms2_sp;
        inch{s,1} = convertCharsToStrings("NaN");
        s = s+1;
        ms2_s = [];
        ms2_i = [];
    end
    
    if mod(n,100000) == 0
        progress = strcat(num2str(n/size(file,1)*100), '%')                             
    end
end

% max_size = size(name,1);
% if size(precursor,1) < max_size
%     precursor{max_size,1} = [];
% end
% if size(adduct,1) < max_size
%     adduct{max_size,1} = [];
% end
% if size(adduct_type,1) < max_size
%     adduct_type{max_size,1} = [];
% end
% if size(colision,1) < max_size
%     colision{max_size,1} = [];
% end
% inch = cellstr(repmat('-',size(precursor,1),1));

database = struct('NAME', name, 'PRECURSORMZ', precursor, 'PRECURSORTYPE', adduct, 'ADDUCT_type', adduct_type, 'COLISION_ENERGY', colision, 'INCHIKEY', inch, 'IONIZATION', ionization, 'MS2', ms2);
empty_mz = find(arrayfun(@(x) isempty(x.('PRECURSORMZ')), database));
database(empty_mz) = [];
end