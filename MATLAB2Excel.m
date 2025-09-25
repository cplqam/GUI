function MATLAB2Excel(identif)
%Identif: la variable compounds antes de realizar el "results
%visualization"

[r_c,c_c] = size(identif);
new_identifier = {};

empty_i = [];
for n = 1:r_c
    spectrum = identif(n);
    if isempty(spectrum.RESULTS.IDENTIFICATIONS)
        empty_i = [empty_i, n];
    end
end
identif(empty_i) = [];

[r_c,c_c] = size(identif);
for n = 1:r_c
    id = identif(n);
    id = id.RESULTS;
    mz = id.MCR_PRECURSOR_ION;
    new_identifier{n,1} = mz;
    
    identifications = id.IDENTIFICATIONS;
    key = unique([identifications.INCHIKEY]);
    for inch = 1:size(key,2)
        ik = find([identifications.INCHIKEY] == key(inch));
        ik_comps = identifications(ik,:);
        [s,p] = max([ik_comps.Similarity]);
        new_identifier{n,2}{inch,1} = ik_comps(p).NAME;
        new_identifier{n,2}{inch,2} = ik_comps(p).Precursor_ppm;
        new_identifier{n,2}{inch,3} = ik_comps(p).MS2;
        new_identifier{n,2}{inch,4} = ik_comps(p).Similarity;
        new_identifier{n,2}{inch,5} = ik_comps(p).Correlation;
        new_identifier{n,2}{inch,6} = ik_comps(p).p_value;
        new_identifier{n,2}{inch,7} = ik_comps(p).INCHIKEY;
    end
end

uni_feat = unique([new_identifier{:,1}]);
new_identifier_uni = {};
for n = 1:size(uni_feat,2)
    pos = find([new_identifier{:,1}] == uni_feat(n));
    joined = [];
    for i = pos
        joined = [joined;new_identifier{i,2}];
    end
    new_identifier_uni{n,1} = uni_feat(n);
    new_identifier_uni{n,2} = joined;    
end

new_identifier_fil = {};
for n = 1:size(new_identifier_uni,1)
    key = unique([new_identifier_uni{n,2}{:,7}]);
    new_identifier_fil{n,1} = new_identifier_uni{n,1};
    for inch = 1:size(key,2)
        ik = find([new_identifier_uni{n,2}{:,7}] == key(inch));
        ik_comps = [new_identifier_uni{n,2}(ik,:)];
        [s,p] = max([ik_comps{:,4}]);
        new_identifier_fil{n,2}{inch,1} = ik_comps{p,1};
        new_identifier_fil{n,2}{inch,2} = ik_comps{p,2};
        new_identifier_fil{n,2}{inch,3} = ik_comps{p,3};
        new_identifier_fil{n,2}{inch,4} = ik_comps{p,4};
        new_identifier_fil{n,2}{inch,5} = ik_comps{p,5};
        new_identifier_fil{n,2}{inch,6} = ik_comps{p,6};
        new_identifier_fil{n,2}{inch,7} = ik_comps{p,7};
    end
end

new_identifier_def = {};
cont = 1;
for n = 1:size(new_identifier_fil,1)
    query = new_identifier_fil(n,:);
    for i = 1:size(query{1,2},1)
        new_identifier_def{cont,1} = query{1};
        new_identifier_def{cont,2} = query{1,2}{i,1};
        new_identifier_def{cont,3} = query{1,2}{i,2};
        new_identifier_def{cont,4} = query{1,2}{i,3};
        new_identifier_def{cont,5} = query{1,2}{i,4};
        new_identifier_def{cont,6} = query{1,2}{i,5};
        new_identifier_def{cont,7} = query{1,2}{i,6};
        new_identifier_def{cont,8} = query{1,2}{i,7};
        cont = cont + 1;
    end
end
ms2_spectra = new_identifier_def(:,4);
new_identifier_def(:,4) = [];

encabezado1 = {'m/z prescursor', 'Identificación', 'ppm error precursor', 'Similarity score', 'Correlation', 'p-value', 'INCHYKEY'};

new_identifier_def = [encabezado1; new_identifier_def];

filename = 'excel_identificaciones.xlsx';
writecell(new_identifier_def,filename, Sheet='Identificaciones');
writecell(ms2_spectra,filename, Sheet="ms2_incognita", Range='A2');
end