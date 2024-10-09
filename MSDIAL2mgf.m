function MSDIAL2mgf(msdial, c_ms2, name)
%This function transform the spectral format of the results of MSDIAL to
%mgf format. The user has to export the results as txt from MSDIAL,
%transform to Excel and import to MATLAB as string matrix

%INPUT
%msdial: imported results from MSDIAL
%c_ms2: number of column in which imported file has the ms2 spectra
%name: name of the mgf output file. By default: "msdial_results.mgf"

if nargin < 3
    name = 'msdial_results.mgf';
end
msdial = msdial(2:end, 1:end);
rows = size(msdial,1);
file = fopen(name,'w');

for n = 1:rows
    feat = msdial(n,:);
    fprintf(file, '%s\n', 'BEGIN IONS');
    fprintf(file, 'SCANS=%i\n\n', n);
    fprintf(file, '%s\n\n', 'MSLEVEL=2');
    
    mz = feat(3);
    rt = str2double(feat(2))*60;
    ion = feat(5);
    ms2 = feat(c_ms2);
    ms2 = split(ms2,' ');
    if size(ms2,1) > 1
        ms2 = split(ms2, ':');
    elseif size(ms2,1) == 1
        ms2 = transpose(split(ms2, ':'));
    end
    max_int = max(str2double(ms2(:,2)));
    for i = 1:size(ms2,1)
        ms2(i,2) = str2double(ms2(i,2))/max_int;
    end

    fprintf(file, 'PEPMASS=%s\n\n', mz);
    fprintf(file, 'RTINSECONDS=%f\n\n', rt);
    fprintf(file, 'ION=%s\n', ion);
    for i = 1:size(ms2,1)
        fprintf(file, '%f %f\n', str2double(ms2(i,1)), ms2(i,2));
    end
    fprintf(file, '%s\n\n', 'END IONS');
end
fclose(file);
end