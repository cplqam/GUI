function deco2mgf(deco, name)
%This function transform the spectral format of the results of DecoMetDIA to
%mgf format. The user has to import the consensus spectra resulting from DecoMetDIA
%to MATLAB as string matrix

%INPUT
%deco: imported results from DecoMetDIA
%name: name of the mgf output file. By default: "deco_results.mgf"

if nargin < 3
    name = 'deco_results.mgf';
end
eli = find(deco(:,1) == 'NAME:');
eli = [eli; find(deco(:,1) == 'SAMPLEGROUP:')];
eli = [eli; find(deco(:,1) == 'Num')];
deco(eli,:) = [];

rows = size(deco,1);
file = fopen(name,'w');
contador = 1;
for r = 1:rows
    
    if deco(r,1) == 'PRECURSORMZ:'
        fprintf(file, '%s\n', 'BEGIN IONS');
        fprintf(file, 'SCANS=%i\n\n', contador);
        contador = contador + 1;
        fprintf(file, '%s\n\n', 'MSLEVEL=2');
        fprintf(file, 'PEPMASS=%s\n\n', deco(r,2));

    elseif deco(r,1) == 'RETENTIONTIME'
        fprintf(file, 'RTINSECONDS=%s\n', deco(r,2));
        fprintf(file, 'ION=[M+?]\n');
    elseif ismissing(deco(r,1))
        fprintf(file, '%s\n\n', 'END IONS');
    else
        fprintf(file, '%s %s\n', deco(r,1), deco(r,2));
    end
end 

fclose(file);
end
