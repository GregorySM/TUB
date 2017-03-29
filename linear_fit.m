function [m,n] = linear_fit(x,y,return_invers,plot_conrad);

%% function returns linear coefficients for input data; 
%% returns coefficient of invers function, if return_invers ==1

    P = polyfit(x,y,1);
    m = P(1);
    n = P(2);
    
    if plot_conrad == 1 
        yfit = m*x+n;
        plot(x,yfit,'g');
    end

    if return_invers == 1
        n = (-1)*n/m;
        
        m = 1/m;
        
        
        if plot_conrad == 1 
            
            plot(m*y+n,y,'r');
        end
        
    end

return
end