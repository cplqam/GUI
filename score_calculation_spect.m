function [similarity,difference,rho, pval] = score_calculation_spect(cand, query,ppm)

if size(cand,1) > 50
    cand = sortrows(cand,2,'descend');
    cand = cand(1:20,:);
    cand = sortrows(cand,1,"ascend");
end
if size(query,1) > 20
    query = sortrows(query,2,'descend');
    query = query(1:20,:);
    query = sortrows(query,1,"ascend");
end

final_q = spectra_matching_ci(cand,query,ppm);
final_c = spectra_matching_ci(query,cand,ppm);

scalar_p = dot(final_c(:,2),final_q(:,2));
modules = norm(final_c(:,2))*norm(final_q(:,2));
score = scalar_p/modules;
similarity = score * 1000;
difference = sqrt(1-score^2) * 1000;

[rho,pval] = corr(final_c(:,2),final_q(:,2));

end