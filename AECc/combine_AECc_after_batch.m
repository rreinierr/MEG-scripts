%Samenvoegen
cd( location of files)
AECc_ah_tot = zeros(437,10,224,224);
load('AECc_alphahigh_1_100.mat')
AECc_ah_tot(1:100,:,:,:)=AECc_alphahigh(1:100,:,:,:);
load('AECc_alphahigh_101_200.mat')
AECc_ah_tot(101:200,:,:,:)=AECc_alphahigh(101:200,:,:,:);
load('AECc_alphahigh_201_300.mat')
AECc_ah_tot(201:300,:,:,:)=AECc_alphahigh(201:300,:,:,:);
load('AECc_alphahigh_301_400.mat')
AECc_ah_tot(301:400,:,:,:)=AECc_alphahigh(301:400,:,:,:);
%etc.....
save("AECc_alphahigh_total.mat","AECc_ah_tot",'-v7.3')
