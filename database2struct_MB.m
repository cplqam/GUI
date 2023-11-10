function database = database2struct_MB(file)
%This function converts the database downloaded from massbank to struct
%INPUT
%file: the database imported as sting array, with tab and space as
%delimiters and selecting only the 5 first columns

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
    if row(1) == 'NAME'
        tf = ismissing(row(3));
        if tf == 1
            name{n_comp,1} = row(2);
        else
            tf2 = ismissing(row(4));
            if tf2 == 1
                name{n_comp,1} = strcat(row(2),'/', row(3));
                name{n_comp,1} = replace(name{n_comp,1},'/', ' ');
            else
                tf3 = ismissing(row(5));
                if tf3 == 1
                    name{n_comp,1} = strcat(row(2),'/', row(3), '/', row(4));
                    name{n_comp,1} = replace(name{n_comp,1},'/', ' ');
                else
                    name{n_comp,1} = strcat(row(2),'/', row(3), '/', row(4), '/' , row(5));
                    name{n_comp,1} = replace(name{n_comp,1},'/', ' ');
                end
            end
        end

    elseif row(1) == 'PRECURSORMZ:'
        precursor{n_comp,1} = str2num(row(2));
    elseif row(1) == 'ADDUCTIONNAME:'
        adduct{n_comp,1} = row(2);
    elseif row(1) == 'IONMODE:'
        ionization{n_comp,1} = lower(row(2));
    elseif row(1) == 'RETENTIONTIME:'
        rt{n_comp,1} = str2num(row(2));
    elseif row(1) == 'FORMULA:'
        formula{n_comp,1} = row(2);
    elseif row(1) == 'SMILES:'
        smiles{n_comp,1} = row(2);
    elseif row(1) == 'INCHIKEY:'
        inchi{n_comp,1} = row(2);
    elseif row(1) == 'INSTRUMENTTYPE:'
        instrument{n_comp,1} = row(2);
    elseif file(n-1,1) == 'Num'
        spect = [];
        for pos = n:r
            if file(pos + 1) ~= 'NAME'
                spect = [spect; str2num(file(pos,1)),str2num(file(pos,2))];
            else
                break
            end
        end
        int_max = max(spect(:,2));
        int_normalized = [];
        for i = 1:size(spect,1)
            int_normalized = [int_normalized;round(spect(i,2)/int_max*1000, 0)];
        end
        spect(:,2) = int_normalized;
        ms2{n_comp,1} = spect;
        n_comp = n_comp + 1;
    end 

    if mod(n,100000) == 0
        progress = strcat(num2str(n/size(file,1)*100), '%')                             
    end

end
database = struct('NAME', name, 'PRECURSORMZ', precursor, 'PRECURSORTYPE', adduct, 'IONIZATION', ionization, 'RETENTIONTIME', rt, 'FORMULA', formula, 'SMILES', smiles, 'INCHIKEY', inchi, 'INSTRUMENTTYPE', instrument, 'MS2', ms2); 
empty_mz = find(arrayfun(@(x) isempty(x.('PRECURSORMZ')), database));
database(empty_mz) = [];
end