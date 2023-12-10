
`timescale 1ns / 1ps
module MainModule(
    input clk,
	input rst,
    input [3:0] Pin,
input [5:0] Deposit_Amount,
input [5:0] WithDraw_Amount,
	
input [1:0] Operation,
output reg[7:0] FinalBalance, Check_balance,// ?????????
	input Insert_card, Language_chosen  ,exit, home	 //InsertCard,LanguageChosen,Exit
    );


reg [3:0] pin_number = 4'b1111;	//default pass
reg [7:0] balance = 8'd30;
reg [3:0] next_state;
reg [3:0] current_state;
reg [1:0] Counter = 2'b00;
reg [1:0] op;
reg	isvalid= 1'b0,issufficent= 1'b0, Enteramount =1'b0, gohome=1'b0; //ValidPass,BalanceCheck,EnteredAmount, home

parameter  IDLE = 4'b0000,
			 language = 4'b0001,
			password = 4'b0010,
			home  = 4'b0011,
			withdraw  = 4'b0100,
			deposit  = 4'b0101,
			balance = 4'b0110,
			check_balance  = 4'b0111,
			add_balance  = 4'b1000,
			sub_balance = 4'b1001,
			reset = 4'b1111;	
				
always @( posedge clk or posedge rst)
	begin
		if (rst)
			begin
				current_state <= reset;
			end
		else	current_state <= next_state;
	end
	
always@(*)
	begin
		Check_balance = balance;
		case (current_state)
			IDLE:	if(Insert_card) 
					next_state = language;
					else 
					next_state = IDLE;
	
			language: if(Language_chosen) 
					next_state = password;
				 else 
					next_state = language;
			
			password: 
				begin
					if(exit)
						next_state = reset;
					else 
						next_state = password;
					if(Pin==pin_number) 
						isvalid = 1'b1;
					else 
						isvalid = 1'b0;
					if(isvalid)

 					  begin 
						next_state = home; 				
						end
					else 
						begin
							Counter = Counter + 1'b1;
							next_state = password; //added to be checked
							if(Counter == 2'b11)
								next_state = reset;
						end
				end

 