function compounds = compound_identification_3(db, mz, ppm, ppm_ms2, thres, ionization, thres_precursor)
%This function provides a chemical compound identification from ROIMCR
%results. Auxiliar functions: 'intensity_normalization.m',
%'ppm_calculation_ident.m', 'score_calculation.m' and spectra_matching.m

%INPUT
%db: the database with the ms2 information (result from 'database2struct.m' for MS-DIAL database)
%mz: the result from 'mz_extraction.m'
%ppm: the m/z error between MSROI signals and the database signals
%thres: the score threshold of the match
%inonization: the experimental ionization (1 for positive and 2 for
%negative)
%thresh_precursor: the intesity threshold to consider an m/z value from MS1
%as a possible precursor ion

%OUTPUT
%compounds: thre identification results
    %1st column: MCR component
    %2nd column: the ionization with the max intensity precursior ion
    %3rd column: the results

compounds = {};
if ionization == 1
    mz1 = {mz.ms1_pos};
    mz1 = transpose(mz1);
    mz2 = {mz.ms2_pos};
    mz2 = transpose(mz2);
elseif ionization == 2
    mz1 = {mz.ms1_neg};
    mz1 = transpose(mz1);
    mz2 = {mz.ms2_neg};
    mz2 = transpose(mz2);
else
    error('Select ionization positive or negative (1 or 2)')
end
% emp_sig = input('If the signals of some MCR component have low intensity, do you want to use the normalized signals? 1/0 (yes/no): ');
emp_sig = 1;

precursor = [db.PRECURSORMZ];
precursor_round = round(precursor,1);

r = size(mz1,1);
for n = 1:r
    display(['Identifying MCR component nº ',num2str(n)]);
    results_compounds = {};
    ms1 = mz1{n};
    ms1 = ms1{2};
    ms2 = mz2{n};
    ms2 = ms2{2};
    tf = isempty(ms1);
    tf2 = isempty(ms2);
    %Si hay valores
    if tf == 1
        if emp_sig == 1
            ms1 = mz1{n};
            ms1 = ms1{4};
        end
    end

    if tf2 == 1
        if emp_sig == 1
            ms2 = mz2{n};
            ms2 = ms2{4};
        end
    end
    position = find(ms1(:,2) >= thres_precursor*1000);
    for i_q = 1:size(position,1)
        pos = position(i_q);
        try
            ion = ms1(pos,1);
            intensity = ms1(pos,2)/1000;
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
        
            scores = [];
            dif = [];
            correlation = [];
            pvalue = [];
            if size(final_db,1) > 0
                for c = 1:size(final_db,1)
                    candidate = final_db(c);
                    ms2_c = candidate.MS2;
                    [s, d, rho,pv] = score_calculation_spect(ms2_c, ms2,ppm_ms2); % Estudiar esta función, algo falla
                    scores = [scores;s];
                    dif = [dif;d];
                    correlation = [correlation; rho];
                    pvalue = [pvalue; pv];
                end
                scores_finales = [];
                for s = 1:size(scores,1)
                    if scores(s) > thres
                        scores_finales = [scores_finales;s];
                    end
                end
                final_db = final_db(scores_finales);
                ppm_results = ppm_results(scores_finales);

                for s = 1:size(scores_finales,1)
                    final_db(s).Similarity = scores(scores_finales(s));
                    final_db(s).Difference = dif(scores_finales(s));
                    final_db(s).Correlation = correlation(scores_finales(s));
                    final_db(s).p_value = pvalue(scores_finales(s));
                    final_db(s).Precursor_ppm = ppm_results(s);
                end
            end
        catch
            compounds{n,1} = mz(n).Max_signal;
            continue
        end
        
        results_compounds{i_q,1} = ion;
        results_compounds{i_q,2} = intensity;
        try
            results_compounds{i_q,3} = ms2(:,1:2);
        catch
            results_compounds{i_q,3} = ms2;
        end
        results_compounds{i_q,4} = final_db;
    end
    results_compounds = struct('MCR_PRECURSOR_ION', results_compounds(:,1), 'INTENSITY_PREC_ION', results_compounds(:,2), ...
        'MCR_MS2',  results_compounds(:,3),'IDENTIFICATIONS', results_compounds(:,4));
    for j = size(results_compounds,1):-1:1
        if isempty(results_compounds(j).MCR_PRECURSOR_ION)
            results_compounds(j) = [];
        end
    end
    compounds{n,1} = n;
    compounds{n,2} = mz(n).Max_signal;
    compounds{n,3} = results_compounds;
end
compounds = struct('MCR_COMPONENT_NUMBER',compounds(:,1), 'MAX_SIGNAL', compounds(:,2), 'RESULTS',compounds(:,3)); 
end