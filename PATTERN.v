//############################################################################
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//   File Name   : PATTERN.v
//   Module Name : PATTERN
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//############################################################################

`ifdef RTL_TOP
    `define CYCLE_TIME 5.5
`endif

`ifdef GATE_TOP
    `define CYCLE_TIME 5.5
`endif

module PATTERN (
    // Output signals
    clk, rst_n, in_valid, in_time,
    // Input signals
    out_valid, out_display, out_day
);

// ===============================================================
// Input & Output Declaration
// ===============================================================
output reg clk, rst_n, in_valid;
output reg [30:0] in_time;
input out_valid;
input [3:0] out_display;
input [2:0] out_day;

// ===============================================================
// Parameter & Integer Declaration
// ===============================================================
real CYCLE = `CYCLE_TIME;

//================================================================
// Wire & Reg Declaration
//================================================================
integer i_pat, i, j, k, t, a, idx;
integer latency;
integer pat_num;
integer f_in_input, f_ans;
reg [30:0] input_time;
reg [3:0] golden_display [13:0];
reg [2:0] golden_day;
//================================================================
// Clock
//================================================================
initial clk = 0;
always #(CYCLE/2.0) clk = ~clk;

//================================================================
// Initial
//================================================================
initial begin
    f_in_input = $fopen("../00_TESTBED/input.txt", "r");
    f_ans = $fopen("../00_TESTBED/ans.txt", "r");
    a = $fscanf(f_in_input, "%d", pat_num);

    reset_task;
    for(i_pat = 0; i_pat < pat_num; i_pat = i_pat + 1) begin
        input_task;
        compute_ans_task;
        wait_out_valid_task;
        check_ans_task;
        check_out_valid_task;
        $display("\033[0;34mPASS PATTERN NO.%4d,\033[m \033[0;32mexecution cycle : %3d\033[m",i_pat ,latency);
    end
    YOU_PASS_task;
end

//================================================================
// TASK
//================================================================
task reset_task; begin
    rst_n = 'b1;
    in_valid = 'b0;
    in_time = 'bx;

    force clk = 0;

    #CYCLE; rst_n = 0;
    #CYCLE; rst_n = 1;
    if(out_valid !== 1'b0 || out_display !=='b0 || out_day !== 'b0)begin
		$display("************************************************************");   
        $display("                          FAIL!                              ");   
        $display("*  Output signal should be 0 after initial RESET  at %8t   *",$time);
        $display("************************************************************");
        repeat(2) #CYCLE;
        $finish;
	end
    #CYCLE; release clk;
end endtask

task input_task; begin
    a = $fscanf(f_in_input, "%d", input_time);
    t = $urandom_range(2, 4);
    repeat(t) @(negedge clk);
    in_valid = 1'b1;
    in_time = input_time;
    @(negedge clk)
    in_valid = 1'b0;
    in_time = 'bx;
end endtask

task compute_ans_task; begin
    for(i=0; i<14; i=i+1)begin
        a = $fscanf(f_ans, "%d", golden_display[i]);
    end
    a = $fscanf(f_ans, "%d", golden_day);
end endtask

task wait_out_valid_task; begin
    latency = 0;
    while(out_valid !== 1'b1)begin
        latency = latency + 1;
        if( latency == 10000) begin
            $display("********************************************************");     
            $display("                          FAIL!                              ");
            $display("*  The execution latency are over 2000 cycles  at %8t   *",$time);//over max
            $display("********************************************************");
	        repeat(2)@(negedge clk);
	        $finish;
        end
        @(negedge clk);
    end
end endtask

task check_ans_task; begin
    for(i=0;i<14;i=i+1)begin
        if(out_display != golden_display[i])begin
            $display ("------------------------------------------------------------------------------------------------------------------------------------------");
			$display ("                                                                      FAIL!                                                               ");
			$display ("                                                                 Golden dispaly :          %d                                             ",golden_display[i]); //show ans
			$display ("                                                                 Your display :            %d                              ", out_display); //show output
			$display ("------------------------------------------------------------------------------------------------------------------------------------------");
			repeat(9) @(negedge clk);
			$finish;
        end
        else if(out_day != golden_day)begin
            $display ("------------------------------------------------------------------------------------------------------------------------------------------");
			$display ("                                                                      FAIL!                                                               ");
			$display ("                                                                 Golden day :          %d                                             ",golden_day); //show ans
			$display ("                                                                 Your day :            %d                              ", out_day); //show output
			$display ("------------------------------------------------------------------------------------------------------------------------------------------");
			repeat(9) @(negedge clk);
			$finish;
        end
        @(negedge clk);
    end
end endtask

task check_out_valid_task; begin
    if(out_valid !== 1'b0)begin
        $display ("------------------------------------------------------------------------------------------------------------------------------------------");
        $display ("                                                                      FAIL!                                                               ");
        $display ("                                                     out_valid should only be high for one cycle                                          "); 
        $display ("------------------------------------------------------------------------------------------------------------------------------------------");
        repeat(9) @(negedge clk);
        $finish;
    end
end endtask

task YOU_PASS_task; begin
    $display ("--------------------------------------------------------------------");
    $display ("                         Congratulations!                           ");
    $display ("                  You have passed all patterns!                     ");
    $display ("--------------------------------------------------------------------");  
    repeat(2)@(negedge clk);
    $finish;
end endtask

endmodule
