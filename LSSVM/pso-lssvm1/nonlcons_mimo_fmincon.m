function [c,ceq]= nonlcons_mimo_fmincon(y,init_opt_value,sys_input,model,train)
     alpha = model.alpha;
    b = model.b;
    sigma = model.sigma;
    input_dim = model.input_dim;
%    y,init_opt_value,sys_input,model,train
    input = [] ;

 
    c =[];
    for i = 1 : max(size(y))
        
        if (i -1) > 0
           if(i <= input_dim -2 ) 
        
                input = [ flipud(y(1:i-1)') ; flipud(init_opt_value(i:input_dim-3)) ; flipud(sys_input(i:i+2))];
              
           else
                input = [ flipud(y(1:i-1)') ; flipud(sys_input(i:i+2))];
           end
        else
             input = [ flipud(init_opt_value(1:input_dim-3) ); flipud(sys_input(i:i+2))];
        end
        
        ceq(i) = y(i) - identification_model_mimo(alpha,b,sigma,input, train);
    end
end