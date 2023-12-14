`timescale 1ns / 1ps

module ATM_TestBench();

	reg clk;
	reg rst;
	reg [3:0] Pin;
	reg [5:0] Deposit_Amount;
	reg [5:0] WithDraw_Amount;
	reg [1:0] Operation;
	wire [7:0] FinalBalance, Check_balance;
	reg Insert_card, Language_chosen  ,exit, home_in;
	integer i, Choice, Random, No_Operation;

	MainModule Test(.clk(clk),
			.rst(rst),
			.Pin(Pin),
			.Deposit_Amount(Deposit_Amount),
			.WithDraw_Amount(WithDraw_Amount),
			.Operation(Operation),
			.FinalBalance(FinalBalance),
			.Check_balance(Check_balance),
			.Insert_card(Insert_card),
			.Language_chosen(Language_chosen),
			.exit(exit),
			.home_in(home_in));

	always #12 clk = !clk;
	
	initial begin
	
		clk = 0;
		rst = 0;
		Pin = 0;
		Deposit_Amount = 0;
		WithDraw_Amount = 0;
		Operation = 0;
		Insert_card = 0;
		Language_chosen = 0;
		exit = 0;
		No_Operation = 0;
		Random = 0;
		home_in = 0;
		i = 0;
		Choice =0;

	//	#50 rst=1;
		// #50 rst=0;
		// Test Successful 
		for(i = 0 ; i < 1000; i = i+1)
			begin
			
			#25 Insert_card = 1;
			#25 Language_chosen = 1;
			#25 Pin = 4'b1111;
			Random = {$random}%30;
			if(Random > 25)
				Pin = {$random}%16;

			No_Operation = 1+{$random}%5;
			#6
			while(No_Operation > 2'b00) begin
				if(No_Operation == 1'b1)
					#25 Operation = 2'b11;
				else begin
					#25 Operation = {$random}%3;
					if(Operation == 2'b00) begin
						#25 WithDraw_Amount = {$random}%64;
						
						while(WithDraw_Amount>Check_balance) begin
							#50 Choice = {$random}%40;
							
							if(Choice < 30)
								#25 WithDraw_Amount = {$random}%64;
							else begin
								#25 home_in = 1'b1;
								WithDraw_Amount = 0;
								#25 home_in = 1'b0;
							end
						end
					end
					else if(Operation == 2'b01) begin
						#25 Deposit_Amount = {$random}%32;
					end
				end
			
			#25 No_Operation = No_Operation + 3'b001;
			end
		end

		$display("First Stage Passed");

/*
		#50 rst = 1;
		#50 rst = 0;
		
		#50 Insert_card = 1; Language_chosen = 1;
		#50 Pin = 4'b1111;
			Operation = 1;
		#50 Deposit_Amount = 10;
		#50 Operation = 2;
		#100
		#200
		#50 rst = 1;
		rst = 0;
		#50 Insert_card = 1; Language_chosen = 1;
		#50 Pin = 4'b1111;
		
			Operation = 0;
		#50 WithDraw_Amount = 20;
		#50 Operation = 2;
		#50 rst = 1;
		rst = 0;
		#50 Operation = 3;
		
		
		$display("Last Stage Passed");
		
		$stop; */
	end
      
endmodule
