%https://cn.mathworks.com/matlabcentral/answers/102051-how-do-i-pass-additional-parameters-to-the-constraint-and-objective-functions-in-the-optimization-to

function [c ,ceq]= contraint_equality(y,init_opt_value,sys_input,model,train)
    c =0;
    input_dim  = model.x_dim;
    input = [] ;
    yszie = max(size(y));
    
%     for i = 1 : max(size(y))
%         if (i -1) > 0
%            if(i <= input_dim -2 ) 
%                 input = [ flipud(y(1:i-1)) ; flipud(init_opt_value(i:input_dim-2)) ; flipud(sys_input(i:i+1))];
%            else
%                 input = [ flipud(y(1:i-1)) ; flipud(sys_input(i:i+1))];
%            end
%         else
%             init_opt_value
%              flipud(init_opt_value(1:input_dim-2) )
%              flipud(sys_input(i:i+1))
%              input = [ flipud(init_opt_value(1:input_dim-2) ); flipud(sys_input(i:i+1))];
%         end
%         ceq(i) = y(i) - identification_model(model,input, train);
%     end
        for i = 1 : max(size(y))
        
            if (i -1) > 0
               if i<= input_dim -2 
                    input = [ flipud(y(1:i-1)) ; flipud(init_opt_value(i:input_dim-3)) ; flipud(sys_input(i:i+2))];
               else
                    input = [ flipud(y(1:i-1)) ; flipud(sys_input(i:i+2))];
               end
            else
                 input = [ flipud(init_opt_value(1:input_dim-3) ); flipud(sys_input(i:i+2))];
            end
            ceq(i) = y(i) - identification_model(model,input, train);
    end
end