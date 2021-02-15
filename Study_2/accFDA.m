function acc = accFDA(Data)

Z               = Data.Z0;
K               = Data.K;
n               = length(K) - 1;
J               = zeros(1,n);
N               = length(Z(1,:));
zmean           = mean(Z);
zmeank          = zeros(length(K),N);
Sb              = zeros(N,N);
Sw              = zeros(N,N);
for i=1:length(K)
    if i==1
        i0      = 1;
        i1      = K(1);
    else
        i0      = i0+K(i);
        i1      = i1+K(i);
    end
    zmeank(i,:) = mean(Z(i0:i1,:));
    Sb          = Sb + K(i)*(zmeank(i,:)' - zmean')*(zmeank(i,:) - zmean);
    Sw          = Sw + K(i)*cov(Z(i0:i1,:));
end
M               = pinv(Sw)*Sb;
P               = zeros(N,n);
for i=1:n
    p           = M(:,1)/norm(M(:,1));
    error       = 100;
    while error > 1e-10
        pk      = M*p;
        if i > 1
            pk  = (eye(N) - (P(:,1:i-1)/(P(:,1:i-1)'*P(:,1:i-1)))*P(:,1:i-1)')*pk;
        end
        s       = norm(pk);
        pk      = pk/s;
        error   = norm(pk - p);
        p       = pk;
    end
    P(:,i)      = p;
    J(i)        = ( p' * Sb * p ) / ( p' * Sw * p );
end
T               = Z * P;
idx1 = 1:K(1);
idx2 = K(1)+1:K(1)+K(2);
y1_mean = mean(T(idx1,:));
y2_mean = mean(T(idx2,:));
correct_No = 0;
for i = 1:size(T,1)
    y1_dist = norm(T(i,:)-y1_mean);
    y2_dist = norm(T(i,:)-y2_mean);
    [~,idx_class] = min([y1_dist,y2_dist]);
    if i <= K(1)
        label = 1;
    elseif i <= K(1)+K(2)
        label = 2;
    else
        label = 3;
    end
    if idx_class == label
        correct_No = correct_No+1;
    end         
end
acc = correct_No/size(T,1);

