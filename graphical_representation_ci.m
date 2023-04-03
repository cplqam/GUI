function graphical_representation(results_identif, component, signal, metabolite)
%This function provides a graphical representation to compare MS2 spectra

%INPUT
%results_identif: results from 'compound_identification.m' function
%component: the number of the MS2 MCR component we want to compare
%signal: the identified precursor ion in the MCR component
%metabolite: the position of the metabolite candidate to be identified 

query = results_identif(component).RESULTS.MCR_MS2;
candid = results_identif(component).RESULTS(signal).IDENTIFICATIONS(metabolite).MS2;
candid(:,2) = -1*candid(:,2);

[nouX1,XF,nouY1,YF] = mirror_plot_ci(query,candid,'n');
end