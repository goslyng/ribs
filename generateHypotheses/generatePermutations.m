function [ paramset, total_parameter_size] = generatePermutations( params )
%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes here

    nComps = length(params);

    for c=1:nComps

        parameter_size(c) =  numel(params{c});

    end

    % clear paramset;
    total_parameter_size= prod(parameter_size);
    display(['No Paramset: ' num2str(total_parameter_size)]);
    paramset = zeros(total_parameter_size,nComps);
    for c=1:nComps

        n1 = prod( parameter_size(1:c-1));
        n2 = prod( parameter_size(c+1:end));

        paramset(:,c) = repmat(reshape(repmat(params{c},[n1 1]),[],1),n2,1);

    end
end

