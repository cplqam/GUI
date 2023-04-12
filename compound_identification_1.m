function compounds = compound_identification_1(db, mz, ppm, thres_precursor)
%This function provides a chemical compound identification from ROIMCR
%results. 

%INPUT
%db: the database with the ms2 information (result from 'database2struct.m' for MS-DIAL database)
%mz: the result from 'mz_extraction.m'
%ppm: the m/z error between MSROI signals and the database signals
%thresh_precursor: the intesity threshold to consider an m/z value from MS1
%as a possible precursor ion

%OUTPUT
%compounds: thre identification results
    %1st column: MCR component
    %2nd column: the ionization with the max intensity precursior ion
    %3rd column: the results

compounds = {};

mz1 = {mz.ms1};
mz1 = transpose(mz1);


precursor = [db.PRECURSORMZ];
precursor_round = round(precursor,1);

r = size(mz1,1);
for n = 1:r
    display(['Identifying MCR component nº ',num2str(n)]);
    results_compounds = {};
    ms1 = mz1{n};
    ms1 = ms1{1};
    %Si hay valores
    position = find(ms1(:,2) >= thres_precursor*0.999);
    for i_q = 1:size(position,1)
        pos = position(i_q);
        
        ion = ms1(pos,1);
        intensity = ms1(pos,2);
        ion_round = round(ion,1);

        reduced_precursor = find(precursor_round == ion_round);
        new_db = db(reduced_precursor); %acotar con el error
        
        precursor_cand = [new_db.PRECURSORMZ];
        final_pos = [];
        ppm_results = [];
        for pc = 1:size(new_db,1)
            ms1_can = precursor_cand(pc);
            ppm_can = ppm_calculation_ident(ion,ms1_can);
            if ppm_can <= ppm
                final_pos = [final_pos,pc];
                ppm_results = [ppm_results,ppm_can];
            end
        end
        final_db = new_db(final_pos);
        final_db = intensity_normalization_spect(final_db);
        for s = 1:size(final_db,1)
            final_db(s).Precursor_ppm = ppm_results(s);
        end
        
        results_compounds{i_q,1} = ion;
        results_compounds{i_q,2} = intensity;      
        results_compounds{i_q,3} = final_db;
    end
    results_compounds = struct('MCR_PRECURSOR_ION', results_compounds(:,1), 'INTENSITY_PREC_ION', results_compounds(:,2), ...
        'IDENTIFICATIONS', results_compounds(:,3));
    for j = size(results_compounds,1):-1:1
        if isempty(results_compounds(j).MCR_PRECURSOR_ION)
            results_compounds(j) = [];
        end
    end
    compounds{n,1} = n;
    compounds{n,2} = results_compounds;
end
compounds = struct('MCR_COMPONENT_NUMBER',compounds(:,1), 'RESULTS',compounds(:,2)); 
end