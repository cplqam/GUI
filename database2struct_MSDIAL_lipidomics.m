function database = database2struct_MSDIAL_lipidomics(file)
%This function converts the database downloaded from MS-DIAL to struct
%INPUT
%file: the database imported as sting array, with tab and space as
%delimiters and selecting only the 3 first columns

[r,c] = size(file);
name = {};
precursor = {};
adduct = {};
ionization = {};
rt = {};
css = {};
formula = {};
smiles = {};
inchi = {};
ms2 = {};

n_comp = 1;
for n = 1:r
    row = file(n,:);
    if row(1) == 'NAME:'
            name{n_comp,1} = row(3);
        else
            name{n_comp,1} = strcat(row(3),'/', row(4));
            name{n_comp,1} = replace(name{n_comp,1},'/', ' ');
        end
    elseif row(1) == 'PRECURSORMZ:'
        precursor{n_comp,1} = str2num(row(2));
    elseif row(1) == 'PRECURSORTYPE:'
        adduct{n_comp,1} = row(2);
    elseif row(1) == 'IONMODE:'
        ionization{n_comp,1} = row(2);
    elseif row(1) == 'RETENTIONTIME:'
        rt{n_comp,1} = str2num(row(2));
    elseif row(1) == 'CCS:'
        css{n_comp,1} = row(2);
    elseif row(1) == 'FORMULA:'
        formula{n_comp,1} = row(2);
    elseif row(1) == 'SMILES:'
        smiles{n_comp,1} = row(2);
    elseif row(1) == 'INCHIKEY:'
        inchi{n_comp,1} = row(2);
    elseif file(n-1,1) == 'Num'
        spect = [];
        for pos = n:r
            if file(pos + 1) ~= 'NAME:'
                spect = [spect; str2num(file(pos,1)),str2num(file(pos,2))];
            else
                break
            end
        end
        ms2{n_comp,1} = spect;
        n_comp = n_comp + 1;
    end
    if mod(n,100000) == 0
        n
    end
end
database = struct('NAME', name, 'PRECURSORMZ', precursor, 'PRECURSORTYPE', adduct, 'IONMODE', ionization, 'RETENTIONTIME', rt, 'CCS', css, 'FORMULA', formula, 'SMILES', smiles, 'INCHIKEY', inchi, 'MS2', ms2); 
end