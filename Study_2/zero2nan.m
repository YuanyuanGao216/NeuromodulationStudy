function Hb_nan = zero2nan(Hb)

index = find(sum(Hb)==0);
Hb(:,index) = nan;
Hb_nan = Hb;