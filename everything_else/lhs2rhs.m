function [LHS, RHS] = lhs2rhs(operators, Delta, name_of_quadratization)
% test P(3->2)-DC1, P-(3->2)DC2, P-(3->2)KKR, ZZZ-TI-CBBK, PSD-CBBK,
% PSD-OT, and PSD-CBBK
% operators shold be in the form of 'xyz'
%
% e.g.    [LHS, RHS] = lhs2rhs('xyz',1e10,'P(3->2)-DC2')
%         refers to quadratize x1*y2*z3 using P(3->2)-DC2 with Delta = 1e10

    if operators(1) == '-'
      operators = operators(2:end);
      coefficient = -1;
    else
      coefficient = 1;
    end
    n = strlength(operators);
    S = cell(n);
    x = [0 1 ; 1 0]; y = [0 -1i ; 1i 0]; z = [1 0 ; 0 -1];

    if strcmp(name_of_quadratization, 'P(3->2)-DC2') || strcmp(name_of_quadratization, 'P(3->2)DC2')
        assert(n == 3, 'P(3->2)-DC2 requires a 3-local term, please only give 3 operators.');
        for ind = 1:n
            if operators(ind) == 'x'
                S{ind} = kron(kron(eye(2^(ind-1)),x),eye(2^(n+1-ind)));
            elseif operators(ind) == 'y'
                S{ind} = kron(kron(eye(2^(ind-1)),y),eye(2^(n+1-ind)));
            elseif operators(ind) == 'z'
                S{ind} = kron(kron(eye(2^(ind-1)),z),eye(2^(n+1-ind)));
            end
        end
        xa = kron(eye(8),x); za = kron(eye(8),z);

        alpha = (1/2)*Delta;
        alpha_s = coefficient*((1/4)*(Delta^(2/3)) - 1);
        alpha_z = (1/2)*Delta;
        alpha_ss = Delta^(1/3);
        alpha_sz = coefficient*(1/4)*(Delta^(2/3));
        alpha_sx = Delta^(2/3);

        LHS = coefficient*S{1}*S{2}*S{3};
        RHS = alpha*eye(16) + alpha_s*S{3} + alpha_z*za + alpha_ss*((S{1} + S{2})^2) + alpha_sx*(S{1}*xa + S{2}*xa) + alpha_sz*za*S{3};

    elseif strcmp(name_of_quadratization, 'P(3->2)-KKR') || strcmp(name_of_quadratization, 'P(3->2)KKR')
        assert(n == 3, 'P(3->2)-KKR requires a 3-local term, please only give 3 operators.');
        for ind = 1:n
            if operators(ind) == 'x'
                S{ind} = kron(kron(eye(2^(ind-1)),x),eye(2^(n+3-ind)));
            elseif operators(ind) == 'y'
                S{ind} = kron(kron(eye(2^(ind-1)),y),eye(2^(n+3-ind)));
            elseif operators(ind) == 'z'
                S{ind} = kron(kron(eye(2^(ind-1)),z),eye(2^(n+3-ind)));
            end
        end
        xa1 = kron(kron(eye(8),x),eye(4)); xa2 = kron(kron(eye(16),x),eye(2)); xa3 = kron(eye(32),x);
        za1 = kron(kron(eye(8),z),eye(4)); za2 = kron(kron(eye(16),z),eye(2)); za3 = kron(eye(32),z);

        alpha = -(1/8)*(Delta);
        alpha_ss = -(1/6)*(Delta)^(1/3);
        alpha_sx = (1/6)*(Delta)^(2/3);
        alpha_zz = (1/24)*(Delta);
 %      have not add coefficient
        LHS = S{1}*S{2}*S{3};
        RHS = alpha*eye(2^(n+3)) + alpha_ss*(S{1}^2 + S{2}^2 + S{3}^2) + alpha_sx*(S{1}*xa1 + S{2}*xa2 + S{3}*xa3) + alpha_zz*(za1*za2 + za1*za3 + za2*za3);

    elseif strcmp(name_of_quadratization, 'P(3->2)KKR-A') % no coefficient needed
        assert(n == 3, 'P(3->2)KKR-A requires a 3-local term, please only give 3 operators.');
        for ind = 1:n
            if operators(ind) == 'x'
                S{ind} = kron(kron(eye(2^(ind-1)),x),eye(2^(n+3-ind)));
            elseif operators(ind) == 'y'
                S{ind} = kron(kron(eye(2^(ind-1)),y),eye(2^(n+3-ind)));
            elseif operators(ind) == 'z'
                S{ind} = kron(kron(eye(2^(ind-1)),z),eye(2^(n+3-ind)));
            end
        end
        xa1 = kron(kron(eye(8),x),eye(4)); xa2 = kron(kron(eye(16),x),eye(2)); xa3 = kron(eye(32),x);
        za1 = kron(kron(eye(8),z),eye(4)); za2 = kron(kron(eye(16),z),eye(2)); za3 = kron(eye(32),z);

        alpha = (3/4)*(Delta);
        alpha_ss = (Delta)^(1/3);
        alpha_sx = -(Delta)^(2/3);
        alpha_zz = -(1/4)*(Delta);

        LHS = -6*S{1}*S{2}*S{3};
        RHS = alpha*eye(64) + 3*alpha_ss*eye(64) + alpha_sx*(S{1}*xa1 + S{2}*xa2 + S{3}*xa3) + alpha_zz*(za1*za2 + za1*za3 + za2*za3);

    elseif strcmp(name_of_quadratization, 'P(3->2)-DC1') || strcmp(name_of_quadratization, 'P(3->2)DC1')
        assert(n == 3, 'P(3->2)-DC1 requires a 3-local term, please only give 3 operators.');
        for ind = 1:n
            if operators(ind) == 'x'
                S{ind} = kron(kron(eye(2^(ind-1)),x),eye(2^(n+3-ind)));
            elseif operators(ind) == 'y'
                S{ind} = kron(kron(eye(2^(ind-1)),y),eye(2^(n+3-ind)));
            elseif operators(ind) == 'z'
                S{ind} = kron(kron(eye(2^(ind-1)),z),eye(2^(n+3-ind)));
            end
        end
        xa1 = kron(kron(eye(8),x),eye(4)); xa2 = kron(kron(eye(16),x),eye(2)); xa3 = kron(eye(32),x);
        za1 = kron(kron(eye(8),z),eye(4)); za2 = kron(kron(eye(16),z),eye(2)); za3 = kron(eye(32),z);

        alpha = (1/8)*Delta;
        alpha_ss = (1/6)*(Delta)^(1/3);
        alpha_sx = (-1/6)*(Delta)^(2/3);
        alpha_zz = (-1/24)*Delta;
%       have not add coefficient
        LHS = S{1}*S{2}*S{3};
        RHS = alpha*eye(2^(n+3)) + alpha_ss*(S{1}^2 + S{2}^2 + S{3}^2) + alpha_sx*(S{1}*xa1 + S{2}*xa2 + S{3}*xa3) + alpha_zz*(za1*za2 + za1*za3 + za2*za3);

   elseif strcmp(name_of_quadratization, 'ZZZ-TI-CBBK')
        assert(n == 3, 'ZZZ-TI-CBBK requires a 3-local term, please only give 3 operators.');
        for ind = 1:n
            assert(operators(ind) == 'z', 'ZZZ-TI-CBBK requires a ZZZ term.');
            S{ind} = kron(kron(eye(2^(ind-1)),z),eye(2^(n+1-ind)));
        end

        xa = kron(eye(8),x);
        za = kron(eye(8),z);

        alpha_I = (1/2)*(Delta + ((coefficient/6)^(2/5))*(Delta^(3/5)) + 6*((coefficient/6)^(4/5))*(Delta^(1/5)) );
        alpha_zi = (-1/2)*(( ((7/6)*coefficient) + ( ((coefficient/6)^(3/5))*(Delta^(2/5))) ) - ( (coefficient/6)*(Delta^4) )^(1/5));
        alpha_zj = alpha_zi;
        alpha_zk = alpha_zi;
        alpha_za = (-1/2)*( Delta - (((coefficient/6)^(2/5))*(Delta^(3/5))) );
        alpha_xa = ( (coefficient/6)*(Delta^4) )^(1/5);
        alpha_zzia = (-1/2)*( ( (7/6)*coefficient + ((coefficient/6)^(3/5))*(Delta^(2/5)) ) + ( (coefficient/6)*(Delta^4) )^(1/5) );
        alpha_zzja = alpha_zzia;
        alpha_zzka = alpha_zzja;
        alpha_zzij = 2*((coefficient/6)^(4/5))*((Delta)^(1/5));
        alpha_zzik = alpha_zzij;
        alpha_zzjk = alpha_zzij;

        LHS = S{1}*S{2}*S{3};
        RHS = alpha_I*eye(16) + alpha_zi*S{1} + alpha_zj*S{2} + alpha_zk*S{3} + alpha_za*za + alpha_xa*xa + alpha_zzia*S{1}*za + alpha_zzja*S{2}*za + alpha_zzka*S{3}*za + alpha_zzij*S{1}*S{2} + alpha_zzik*S{1}*S{3} + alpha_zzjk*S{2}*S{3};

    elseif strcmp(name_of_quadratization, 'PSD-CBBK')
        assert(n >= 5, 'PSD-CBBK requires at least a 5-local term, please give at least 5 operators.');
        for ind = 1:n
            if operators(ind) == 'x'
                S{ind} = kron(kron(eye(2^(ind-1)),x),eye(2^(n+1-ind)));
            elseif operators(ind) == 'y'
                S{ind} = kron(kron(eye(2^(ind-1)),y),eye(2^(n+1-ind)));
            elseif operators(ind) == 'z'
                S{ind} = kron(kron(eye(2^(ind-1)),z),eye(2^(n+1-ind)));
            end
        end

        n_a = ceil(n/2);

        A = eye(2^(n+1)); B = eye(2^(n+1));
        for ind = 1:n_a
            A = A*S{ind};
        end

        for ind = n_a + 1:n
            B = B*S{ind};
        end
        za = kron(eye(2^n),z);
        xa = kron(eye(2^n),x);

        LHS = coefficient*A*B;
        RHS = (Delta)*((1*eye(2^(n+1)) - za)/2) + abs(coefficient)*((1*eye(2^(n+1)) + za)/2) + sqrt( abs(coefficient)*Delta/2 )*(sign(coefficient)*A - B)*xa;

    elseif strcmp(name_of_quadratization, 'PSD-OT')
        assert(n >= 4, 'PSD-OT requires at least a 4-local term, please give at least 4 operators.');
        for ind = 1:n
            if operators(ind) == 'x'
                S{ind} = kron(kron(eye(2^(ind-1)),x),eye(2^(n+1-ind)));
            elseif operators(ind) == 'y'
                S{ind} = kron(kron(eye(2^(ind-1)),y),eye(2^(n+1-ind)));
            elseif operators(ind) == 'z'
                S{ind} = kron(kron(eye(2^(ind-1)),z),eye(2^(n+1-ind)));
            end
        end

        A = eye(2^(n+1)); B = eye(2^(n+1));
        n_a = ceil(n/2);

        for ind = 1:n_a
            A = A*S{ind};
        end

        for ind = n_a + 1:n
            B = B*S{ind};
        end
        za = kron(eye(2^n),z);
        xa = kron(eye(2^n),x);

        LHS = coefficient*A*B;
        RHS = Delta*((1*eye(2^(n+1)) - za)/2) + (coefficient/2)*(A^2 + B^2) + sqrt( coefficient*Delta/2 )*(-A + B)*xa;

    elseif strcmp(name_of_quadratization, 'P(3->2)CBBK') || strcmp(name_of_quadratization, 'P(3->2)-CBBK')
        assert(n == 3, 'P(3->2)-CBBK requires a 3-local term, please only give 3 operators.');
        for ind = 1:n
            if operators(ind) == 'x'
                S{ind} = kron(kron(eye(2^(ind-1)),x),eye(2^(n+1-ind)));
            elseif operators(ind) == 'y'
                S{ind} = kron(kron(eye(2^(ind-1)),y),eye(2^(n+1-ind)));
            elseif operators(ind) == 'z'
                S{ind} = kron(kron(eye(2^(ind-1)),z),eye(2^(n+1-ind)));
            end
        end

        za = kron(eye(8),z);
        xa = kron(eye(8),x);

        kappa = sign(coefficient)*((coefficient/2)^(1/3))*(Delta^(3/4));
        lambda = ((coefficient/2)^(1/3))*(Delta^(3/4));
        mu = ((coefficient/2)^(1/3))*(Delta^(1/2));

        LHS = coefficient*S{1}*S{2}*S{3};
        RHS = (Delta*eye(16) + mu*S{3})*((1*eye(16) - za)/2) + (kappa*S{1} + lambda*S{2})*xa ...
        + (1/Delta)*(kappa^2 + lambda^2)*((1*eye(16) + za)/2) + (2*kappa*lambda/Delta)*S{1}*S{2} - (1/(Delta^2))*(kappa^2 + lambda^2)*mu*S{3}*((1*eye(16) + za)/2) ...
        - (2*kappa*lambda/(Delta^3))*sign(coefficient)*( (kappa^2 + lambda^2)*((1*eye(16) + za)/2) + (2*kappa*lambda*S{1})*S{2} );

    elseif strcmp(name_of_quadratization, 'P(3->2)-OT') || strcmp(name_of_quadratization, 'P(3->2)OT')
        assert(n == 3, 'P(3->2)-OT requires a 3-local term, please only give 3 operators.');
        for ind = 1:n
            if operators(ind) == 'x'
                S{ind} = kron(kron(eye(2^(ind-1)),x),eye(2^(n+1-ind)));
            elseif operators(ind) == 'y'
                S{ind} = kron(kron(eye(2^(ind-1)),y),eye(2^(n+1-ind)));
            elseif operators(ind) == 'z'
                S{ind} = kron(kron(eye(2^(ind-1)),z),eye(2^(n+1-ind)));
            end
        end

        za = kron(eye(8),z);
        xa = kron(eye(8),x);

        LHS = coefficient*S{1}*S{2}*S{3};
        RHS = (Delta/2)*eye(16) + ((Delta^(1/3))*(coefficient^(2/3))/2)*(S{1})^2 + ((Delta^(1/3))*(coefficient^(2/3))/2)*(S{2})^2- ((Delta^(2/3))*(coefficient^(1/3))/2)*S{3} ...
            - (Delta/2)*za - ((Delta^(1/3))*(coefficient^(2/3)))*S{1}*S{2} + (coefficient/2)*(S{1}^2)*S{3} + (coefficient/2)*(S{2}^2)*S{3} + (Delta^(2/3))*(coefficient^(1/3)/2)*S{3}*za ...
            - ((Delta^(2/3))*(coefficient^(1/3))/sqrt(2))*S{1}*xa + ((Delta^(2/3))*(coefficient^(1/3))/sqrt(2))*S{2}*xa;

    else
        disp('cannot find this method');
        LHS = []; RHS = [];
    end
end
