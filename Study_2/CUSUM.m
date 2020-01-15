function CUSUM_scores = CUSUM(x,SS,s)
n = length(x);
CUSUM_scores = zeros(n,1);
for i = 2:n
    score = x(i);
    if score >= 300
        CUSUM_scores(i) = NaN;
    else
        if score > SS
            CUSUM_scores(i) = CUSUM_scores(i-1) - s;
        else
            CUSUM_scores(i) = CUSUM_scores(i-1) + (1-s);
        end
    end
end

        