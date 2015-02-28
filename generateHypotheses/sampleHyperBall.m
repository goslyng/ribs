function [paramset, parameter_size]= sampleHyperBall(dim, res , nSampleTotal)



grid_sampling=1;

if grid_sampling
    
    for c=1:dim

        params{c} = unique([0:-res(c):-1 0:res(c):1]);

    end
    
    %         nComps = length(params);
    % 
    %     for c=1:nComps
    % 
    %         parameter_size(c) =  numel(params{c});
    % 
    %     end
    % 
    %     % clear paramset;
    %     total_parameter_size= prod(parameter_size);
    % 
    %     paramset = zeros(total_parameter_size,nComps);
    %     for c=1:nComps
    % 
    %         n1 = prod( parameter_size(1:c-1));
    %         n2 = prod( parameter_size(c+1:end));
    % 
    %         paramset(:,c) = repmat(reshape(repmat(params{c},[n1 1]),[],1),n2,1);
    % 
    %     end
    

    try

        paramset= generatePermutations( params );


        %discarding the samples outside the hyperball
        indx = logical(sqrt(sum(paramset.^2,2))>1);
        paramset(indx,:)=[];
        parameter_size = size(paramset,1);

    catch
        for x=1:length(params)
            y(x) = length(params{x});
        end
        [a, b] =sort(y,'descend');
        paramsetTotal=-99999*zeros(10000000,length(params));
        parameter_size_total=0;
        for x=1:a(1)
           paramsNew = { params{1:b(1)-1}  params{b(1)}(x) params{b(1)+1:end}};
           paramset = generatePermutations( paramsNew  );
           indx = logical(sqrt(sum(paramset.^2,2))>1);
           paramset(indx,:)=[];
           parameter_size = size(paramset,1);
           parameter_size_total_begin = parameter_size_total;
           parameter_size_total = parameter_size_total+parameter_size;
           paramsetTotal(parameter_size_total_begin+1:parameter_size_total,:) = paramset;
        end
        paramset = paramsetTotal(1:parameter_size_total,:);
        clear paramsetTotal;
        parameter_size=parameter_size_total;
    end
else

    nSamples = res;
    
   
    parameter_size=0;
    paramset=[];
    while parameter_size < nSampleTotal

        for c=1:dim


            params{c} = 2*rand(1,nSamples(c))-1;

        end
        %drawing samples from a hypercube
        [paramsetT, ~]= generatePermutations( params );


       %discarding the samples outside the hyperball
        indx = logical(sqrt(sum(paramsetT.^2,2))>1);
        paramsetT(indx,:)=[];

        paramset= [paramset; paramsetT];
        parameter_size = size(paramset,1);

    end
end
