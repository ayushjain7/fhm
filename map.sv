module map(input logic clk);
typedef int element[2];

int g, lp, sp, x, xs, spn, nsp, lpn, s, nlp, fx, c1_sp, cons_lp, t, wait_variable, nspc;
element c0, le, nil, nc, se, nle;
logic ready_g, valid_g, ready_c0, valid_c0, ready_stackWrite, valid_stackWrite,
    ready_listRead, valid_listRead, ready_pattern_match, valid_pattern_match,
    ready_c1, valid_c1, valid_lp, valid_x, valid_xs, valid_result, result,
    valid_sp, ready_c1_x, ready_c1_sp, valid_spn, valid_nil, ready_listWrite,
    valid_listWrite, valid_lpn, ready_stackRead, valid_stackRead, valid_s,
    valid_nsp, final_result, valid_final_result, valid_f, ready_cons_lp, 
    ready_cons_fx, valid_cons, ready_f, ready_nsp, ready_sp, ready_spt,
    valid_c1_sp, ready_c1_result, valid_result_g, valid_result_c1,
    ready_pattern_match2, result2, valid_result2, valid_cons_lp, ready_lp_c0_c1,
    ready_lpn, ready_t, valid_t, ready_nlp, ready_result2, valid_nspc, ready_nspc;

int stack[6], resultList[6];
int list[6];

initial begin
    list[0] <= 0; list[1] <= 1; list[2] <= 2;
    list[3] <= 3; list[4] <= 4; list[5] <= 5;
    g <= 0; lp <= 5; sp <= 0;
    c0<=C0(g, ready_c0, valid_c0);
    stack[0]<=c0[0]; sp <= c0[1] + 1;
    ready_stackWrite <= 1; valid_sp <= 1; ready_c1_result <= 1; valid_lp <= 1;
    valid_result <= 0;
    ready_pattern_match <= 1; ready_c1_x <= 1; ready_c1_sp <= 1; ready_nsp <= 1;
    ready_g <= 1; ready_spt <= 1; ready_sp <= 1; ready_pattern_match2 <= 1;
    ready_f <= 1; ready_t <= 1; ready_cons_lp <= 1; ready_nlp <= 1;
    ready_result2 <= 1; ready_nspc <= 1; ready_lpn <= 1;

end

function element C0(int g, inout logic ready, inout logic valid);
    int ret[2];
    ready <= 1;
    valid<=1;
    ret[0] = 0;
    ret[1] = 0;
    return ret;
endfunction

function int next(int g, inout logic ready, inout logic valid);
    ready <= 1;
    valid <= 1;
    return 0;
endfunction

function int stackWrite(element value, inout logic ready, inout logic valid);
    stack[value[1]]<=value[0];
    ready <= 1;
    valid <= 1;
    return value[1] + 1;
endfunction

function element stackRead(int location, inout logic ready, inout logic valid);
    int ret[2];
    ready <= 1;
    valid <= 1;
    ret[0] = stack[location];
    ret[1] = location - 1;
    return ret;
endfunction

function int listWrite(int value[1:0], inout logic ready, inout logic valid);
    resultList[value[1]]<=value[0];
    ready <= 1;
    valid <= 1;
    return value[1] + 1;
endfunction

function element listRead(int location, inout logic ready, inout logic valid);
    int ret[2];
    ready <= 1;
    valid <= 1;
    ret[0] = location;
    ret[1] = location-1;
    return ret;
endfunction

function element C1(int value, int loc, inout logic valid, inout logic ready_value, inout logic ready_loc);
    int ret[2];
    valid <= 1;
    ready_value <= 1;
    ready_loc <= 1;
    ret[0] = value;
    ret[1] = loc;
    return ret;
endfunction

function element cons(int value, int loc, inout logic valid, inout logic ready_value, inout logic ready_loc);
    int ret[2];
    valid<=1;
    ready_value <= 1;
    ready_loc <= 1;
    ret[0] = value;
    ret[1] = loc;
    return ret;
endfunction

function element Nil(int g);
    int ret[2];
    ret[0] = 0; ret[1] = 0;
    return ret;
endfunction

function void pattern_match(element le, inout int x, inout logic valid_x, inout int l, inout logic valid_l, inout logic result, inout logic valid_result, inout logic ready_pattern_match);
    
    if (le[1] == -1) begin
        result<=0;
        x <= 0;
        valid_x <= 0;
        l <= 0;
        valid_l <= 0;
        ready_pattern_match <= 1;
        valid_result <= 1;
    end
    else begin
        result <= 1;
        x <= le[0];
        valid_x <= 1;
        l <= le[1];
        valid_l <= 1;
        ready_pattern_match <= 1;
        valid_result <= 1;
    end
endfunction

//call function
always_ff @(posedge clk) begin
    if (ready_c0 && ready_g && valid_g)
        g <= next(g, ready_g, valid_g);

    if (ready_pattern_match && valid_lp) begin
        le <= listRead(lp, ready_listRead, valid_listRead);
        valid_lp <= 0;
        ready_pattern_match <= 0;
    end

    if (valid_listRead && ready_c1_x && ready_listRead && ready_c1_result) begin
        pattern_match(le, x, valid_x, lp, valid_lp, result, valid_result, ready_pattern_match);
        ready_c1_x <= 0;
        ready_g <= 0;
        ready_c1_result <= 0;
        ready_listRead <= 0;
        valid_listRead <= 0;
    end

    if (valid_result) begin
        valid_result <= 0;
        valid_result_g <= 1;
        valid_result_c1 <= 1;
    end
    if (valid_result_g) begin
        valid_result_g <= 0;
        if (result) begin
            if (valid_g && ready_g)
                g <= g;
        end
    end
    if (valid_result_c1) begin
        if (result) begin
            if (valid_sp && ready_c1_sp) begin
                c1_sp <= sp;
                valid_c1_sp <= 1;
                ready_c1_result <= 1;
                ready_spt <= 1;
                valid_sp <= 0;
                ready_c1_sp <= 0;
                valid_result_c1 <= 0;
            end
        end
        else begin
            spn <= sp - 1;
            valid_spn <= 1;
            nil <= Nil(g);
            valid_nil <= 1;
            valid_result_c1 <= 0;
        end
    end
    if (valid_c1_sp && valid_x && ready_stackWrite) begin
        nc <= C1(x, c1_sp, valid_c1, ready_c1_x, ready_c1_sp);
        ready_stackWrite <= 0;
        valid_c1_sp <= 0;
        valid_x <= 0;
    end
    if (valid_stackWrite && ready_spt) begin
        sp <= nsp;
        ready_sp <= 1;
        valid_sp <= 1;
        valid_stackWrite <= 0;
        ready_spt <= 0;
    end 
    if (valid_nil && ready_nlp) begin
        nlp <= listWrite(nil, ready_listWrite, valid_listWrite);
        valid_nil <= 0;
        ready_nlp <= 0;
    end
    if (valid_c1 && ready_sp) begin
        nsp<=stackWrite(nc, ready_stackWrite, valid_stackWrite);
        ready_sp <= 0;
        valid_c1 <= 0;
    end
end

//cont function
always_ff @(posedge clk) begin
    if (ready_pattern_match2 && valid_spn) begin
        se <= stackRead(spn, valid_stackRead, ready_stackRead);
        ready_pattern_match2 <= 0;
        valid_spn <= 0;
    end
    if (valid_stackRead && ready_f && ready_nspc && ready_result2) begin
        pattern_match(se, s, valid_s, nspc, valid_nspc, result2, valid_result2, ready_pattern_match2);
        ready_result2 <= 0;
        valid_stackRead <= 0;
        ready_f <= 0;
        ready_nspc <= 0;
    end
    if (result2 && valid_nspc && ready_stackRead) begin
        spn <= nspc;
        ready_nspc <= 1;
        valid_spn <= 1;
        valid_nspc <= 0;
        ready_stackRead <= 0;
    end
    if (valid_result2 && valid_lpn) begin
        if (result2) begin
            if (ready_cons_lp) begin
                cons_lp <= lpn;
                valid_cons_lp <= 1;
                valid_result2 <= 0;
                valid_lpn <= 0;
                ready_cons_lp <= 0;
                ready_lpn <= 1;
                ready_result2 <= 1;
            end
        end
        else begin
            final_result <= lpn;
            valid_final_result <= 1;
            valid_lpn <= 0;
            valid_result2 <= 0;
            ready_result2 <= 1;
        end
    end
    if (valid_listWrite && ready_lpn) begin
        lpn <= nlp;
        ready_lpn <= 0;
        valid_lpn <= 1;
        valid_listWrite <= 0;
        ready_nlp <= 1;
    end
    if (valid_f && valid_cons_lp && ready_listWrite) begin
        nle <= cons(fx, cons_lp, valid_cons, ready_cons_fx, ready_cons_lp);
        valid_f <= 0;
        valid_cons_lp <= 0;
        ready_listWrite <= 0;
    end
    if (valid_cons && ready_nlp) begin
        nlp <= listWrite(nle, ready_listWrite, valid_listWrite);
        valid_cons <= 0;
        ready_nlp <= 0;
    end

//function fx
    if (valid_s && ready_t) begin
        valid_s <= 0;
        ready_t <= 0;
        ready_f <= 1;
        t <= s;
        valid_t <= 1;
        wait_variable <= 1;
    end
    else if (wait_variable == 2 && valid_t) begin
        valid_f <= 1;
        ready_t <= 1;
        fx <= t + 2;
        valid_t <= 0;
        wait_variable <= 0;
    end
    else if (ready_t == 0)
        wait_variable <= wait_variable + 1;
end


endmodule
