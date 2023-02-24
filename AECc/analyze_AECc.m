%based on Jenny Nij-Bijvank and Ilse Nauta's scripts
%AECc_beta_total.mat contains variable "AECc_be_tot(nr_subjects,AECc_corr_in_244_BNA_regions,AECc_corr_in_244_BNA_regions";

load('AECc_beta_total.mat') %load file that holds the AECc for one frequencyband for all subjects
%correct for negative values
AECc_beta_corr = (AECc_be_tot+1)/2;
%visual check;
  mean_AECc_beta_perROI = squeeze(mean(mean(AECc_beta_corr,1),2));
  figure; imagesc(squeeze(mean_AECc_beta_perROI(:,:))); colorbar

%make a variable the same size of AECc_be_tot
AECc_beta_diag = zeros(437,10,224,224); 
%set diagonal to "Not a number"
%there is a difference between 0 and NaN after analyses, especially when avaraging a small number of ROI's
nr_subjects=437;
nr_epochs=10;  
  for i=1:nr_subjects
    for j=1:nr_epochs
        AECc_beta_diag(i,j,:,:)=squeeze(AECc_beta_corr (i,j,:,:)).*~eye(size(squeeze(AECc_beta_corr (i,j,:,:))));
    end 
end
AECc_beta_diag(AECc_beta_diag == 0 )=NaN;
clear i k j
%avarage over epochs:
AECc_beta_mean=squeeze(mean(AECc_beta_diag,2,"omitnan"));
%optional: save between steps:
%save("AECc_beta_mean_over_all_epochs.mat","AECc_beta_mean",'-v7.3')
%load('AECc_beta_mean_over_all_epochs.mat')
%%whole brain connectivity
AECc_beta_whole_brain_connectivity=squeeze(mean(mean(AECc_beta_mean,2,"omitnan"),3,"omitnan"));
save("AECc_beta_whole_brain_connectivity.mat","AECc_beta_whole_brain_connectivity",'-v7.3')
%%
% connectivity between default mode network and whole brain
AECc_beta_mean_DMN_WB = AECc_beta_mean(:,[3 5 6 11 13 14 23 33 34 35 41 42 43 44 51 52 79 80 81 83 84 87 88 95 121 122 141 144 153 154 175 176 179 181 187 188],:);
AECc_beta_mean_DMN_WB=mean(mean(AECc_beta_mean_DMN_WB,2,"omitnan"),3,"omitnan");
%visual check again:
% figure; imagesc(squeeze(AECc_beta_mean_DMN_WB(:,:,:))); colorbar
save("AECc_beta_global_dmn_results.mat","AECc_beta_mean_DMN_WB","AECc_beta_whole_brain_connectivity")
%copy and paste results into your database..!
