function [c,ceq]= nonlcons_mimo_fmincon(y,init_opt_value,sys_input,model,train)
    alpha = model.alpha;
    b = model.b;
    sigma = model.sigma;
    input_dim = model.input_dim;
%    y,init_opt_value,sys_input,model,train
    input = [] ;

    len = size(train,1);
    c =[];
    for i = 1 : len
%         i
        if i ~= 1
%             [1 i-1 i size(init_opt_value) i i+1 ]
            input = [ flipud(y(1:i-1)') ; flipud(init_opt_value(i:end)); flipud(sys_input(i:i+1))];
        else
%             [0 0 i size(init_opt_value) i i+1]
            input = [ flipud(init_opt_value(i:end)); flipud(sys_input(i:i+1))];
        end
        
        ceq(i) = y(i) - identification_model_mimo(alpha,b,sigma,input, train);
    end
end