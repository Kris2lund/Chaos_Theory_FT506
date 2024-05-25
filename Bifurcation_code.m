    clc, clear

omega = linspace(4,7,250);
figure(1)
y0 = [0 1];
for i = 1:length(omega)
    g = @(t, y) f(t, y, omega(i));
    h = @(t, y) events(t, y, omega(i));

    tspan = [0 100];
    opts = odeset('Events', h, 'RelTol',10e-10,'AbsTol',10e-12);
    [t, y, te, ye, ie] = ode45(g, tspan, y0, opts);    
    y0 = y(end,:);

    % Bifurcation plot
    plot(omega(i), ye(floor(end/2):end, 2), '.', 'MarkerSize', 2, 'color', 'k');
    hold on
    title('Bifurcation plot');
    xlabel('\omega_d [rad/s]')
    ylabel('\omega [rad/s]')
end
hold off


function dydt = f(t, y, omega)

    r = 0.048; 
    g = 9.82; 
    m_L = 1.48502e-2; 
    m_D = 1.2192e-1; 
    gam = 0.6e-4; 
    kappa = 1.51e-3; 
    
    a = 0.002; 

    I = 1/2*m_D*r^2+m_L*r^2; 

    dydt = [y(2); (-gam*y(2) - kappa*y(1) + m_L*g*r*sin(y(1)) + a*cos(omega*t)) / I];

end
 
function [value,isterminal,direction] = events(t,y, omega)
    value = cos(omega*t); 
    isterminal = 0; 
    direction = 1; 
end
