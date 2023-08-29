function database = database2struct_MB_nist(file)
%This function converts the database downloaded from massbank to struct
%INPUT
%file: the database imported as sting array, with tab and space as
%delimiters and selecting only the 4 first columns

[r,c] = size(file);
name = {};
precursor = {};
adduct = {};
ionization = {};
rt = {};
formula = {};
smiles = {};
inchi = {};
instrument = {};
ms2 = {};

n_comp = 1;
for n = 1:r
    row = file(n,:);
    if row(1) == 'Name:'
        tf = ismissing(row(3));
        if tf == 1
            name{n_comp,1} = row(2);
        else
            name{n_comp,1} = strcat(row(2),'/', row(3));
            name{n_comp,1} = replace(name{n_comp,1},'/', ' ');
        end
    elseif row(1) == 'PrecursorMZ:'
        precursor{n_comp,1} = str2num(row(2));
    elseif row(1) == 'Precursor_type:'
        adduct{n_comp,1} = row(2);
    elseif row(1) == 'Ion_mode:'
        ionization{n_comp,1} = lower(row(2));
    elseif row(1) == 'ExactMass:'
        rt{n_comp,1} = str2num(row(2));
    elseif row(1) == 'Formula:'
        formula{n_comp,1} = row(2);
    elseif row(1) == 'SMILES:'
        smiles{n_comp,1} = row(2);
    elseif row(1) == 'InChIKey:'
        inchi{n_comp,1} = row(2);
    elseif row(1) == 'Instrument_type:'
        instrument{n_comp,1} = row(2);
    elseif file(n-1,1) == 'Num'
        spect = [];
        for pos = n:r
            if file(pos + 1) ~= 'Name:'
                spect = [spect; str2num(file(pos,1)),str2num(file(pos,2))];
            else
                break
            end
        end
        ms2{n_comp,1} = spect;
        n_comp = n_comp + 1;
        if size(precursor,1) ~= size(ms2,1)
            n_comp = n_comp - 1;
            name{n_comp,1} = [];
            precursor{n_comp,1} = [];
            adduct{n_comp,1} = [];
            ionization{n_comp,1} = [];
            rt{n_comp,1} = [];
            formula{n_comp,1} = [];;
            smiles{n_comp,1} = [];
            inchi{n_comp,1} = [];
            instrument{n_comp,1} = [];
            ms2{n_comp,1} = [];
        end 
    end   
end
database = struct('NAME', name, 'PRECURSORMZ', precursor, 'PRECURSORTYPE', adduct, 'IONIZATION', ionization, 'EXACTMASS', rt, 'FORMULA', formula, 'SMILES', smiles, 'INCHIKEY', inchi, 'INSTRUMENTTYPE', instrument, 'MS2', ms2); 
end