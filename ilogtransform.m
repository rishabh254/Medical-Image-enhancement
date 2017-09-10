function z = ilogtransform(g)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
                %log transform
[M,N]=size(g);
factor=1.0;
        for x = 1:M
            for y = 1:N
                m=double(abs(g(x,y)));
                z(x,y)=exp(m/factor)-1;
            end
        end
        
end

