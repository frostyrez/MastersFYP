function MVs = test_fcn_2(MVs)

for j = 1:4
    for i = 1:length(MVs)
        if MVs(i,j) > 8.624
            MVs(i,j) = 8.624;
        elseif MVs(i,j) < -6.176
            MVs(i,j) = -6.176;
        end
    end
end

end