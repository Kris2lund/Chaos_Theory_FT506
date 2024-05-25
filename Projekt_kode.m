    clc, clear
    y0 = [0 0];
    tspan = [0 100000];
    opts = odeset('Events', @events,'RelTol',1e-8,'AbsTol',1e-9); 
    [t, y, te, ye, ie] = ode45(@f, tspan, y0, opts);    
    
    

    figure(1);
    % Angle plot
    subplot('Position',[0.75,0.6,0.2,0.3]);
    plot(t, y(:, 1));
    xlabel('t (s)')
    ylabel('\theta (rad)')
    title('Angle plot');

    % Phase plot
    subplot('Position',[0.75,0.1,0.2,0.3]);
    plot(y(:, 1), y(:, 2));
    xlabel('\theta (rad)')
    ylabel('\omega (rad/s)')
    title('Phase space diagram');

    % Poincaré plot
    subplot('Position',[0.1,0.1,0.6,0.8]);
    plot(ye(floor(end/2):end, 1), ye(floor(end/2):end, 2), '.', 'MarkerSize', 4);
    xlabel('\theta (rad)')
    ylabel('\omega (rad/s)')
    xlim([-5 5])
    title('Poincaré plot');
 

    

function dydt = f(t, y)
    r = 0.048; 
    g = 9.82; 
    m_L = 1.48502e-2; 
    m_D = 1.2192e-1; 
    gam = 0.5e-4; 
    kappa = 2.33e-3; 
    a = 2e-3; 
    omega = 5.556; 
    I = 1/2*m_D*r^2+m_L*r^2; 
    
    
    
 
    dydt = [y(2); (-gam*y(2) - kappa*y(1) + m_L*g*r*sin(y(1)) + a*cos(omega*t)) / I]; 
end
 
function [value,isterminal,direction] = events(t, y)
    omega = 5.556;
    value = cos(omega*t); 
    isterminal = 0; 
    direction = 1;  
end