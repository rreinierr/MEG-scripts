function AEC = ae_corr(data)
% compute the AEC

M = size(data,2); % no channels/ROIs
AEC = zeros(M,M);
htx = hilbert(data); 
htx(end-10:end,:)=[];htx(1:10,:)=[];
envelope_x = abs(htx);

for i = 1:M
    x = data(:,i);
    for j = 1:M
        if i~=j
            y = data(:,j);
            [b,bint,r] = regress(y,x);  % pairwise leakage correction
            hty = hilbert(r);
            hty(end-10:end)=[];hty(1:10)=[];
            envelope_y = abs(hty);    
            
            % correlation between envelopes
            AEC(i,j) = corr(envelope_x(:,i),envelope_y);
        end
    end
end
   AEC = (AEC + AEC')/2;         
end
