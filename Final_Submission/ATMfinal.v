
`timescale 1ns / 1ps

`define DELAY #2
module MainModule(
	input clk,
	input rst,
	input [3:0] Pin,acc_number,newpin,
	input [5:0] Deposit_Amount,
	input [5:0] WithDraw_Amount,Transfer_amount,
	input [2:0] Operation,
	output reg[7:0] FinalBalance, Check_balance,// ?????????
	input Insert_card, Language_chosen  ,exit, home_in	 //InsertCard,LanguageChosen,Exit
    );


//reg [3:0] pin_number = 4'b1111;	//default pass
//reg [7:0] balance = 8'd30;
reg [3:0] next_state;
reg [3:0] current_state;
reg [1:0] destacc,srcacc; 
reg [1:0] Counter = 2'b00;
reg [2:0] op;
reg	isvalid= 1'b0,issufficent= 1'b0, Enteramount =1'b0, gohome=1'b0; //ValidPass,BalanceCheck,EnteredAmount, home

parameter  IDLE = 4'b0000,
			language = 4'b0001,
			password = 4'b0010,
			home  = 4'b0011,
			withdraw  = 4'b0100,
			deposit  = 4'b0101,
			updbalance = 4'b0110,
			check_balance  = 4'b0111,
			add_balance  = 4'b1000,
			sub_balance = 4'b1001,
			transfer=4'b1010,
                        transferingmoney=4'b1011,
                        changePin=4'b1100,
			reset = 4'b1111;	

reg [3:0] acc_ID[0:3];
  reg [3:0] Pins[0:3];

initial begin
    acc_ID[0] = 4'b0011; Pins[0] = 4'b0000;
    acc_ID[1] = 4'b0010; Pins[1] = 4'b0001;
    acc_ID[2] = 4'b0001; Pins[2] = 4'b0010;
    acc_ID[3] = 4'b0000; Pins[3] = 4'b0011;
    end


				
always @( posedge clk or posedge rst)
	begin
		if (rst)
		
		
		
			begin
				current_state <= reset;
			end
			
			
		else current_state <= next_state;
		
		
		
	end

reg [7:0] balance [0:3];
initial begin
    
     balance[0] = 8'd40;
     balance[1] = 8'd00;
     balance[2] = 8'd5;
     balance[3] = 8'd50;
     

  end
	
integer i;	
always@(*)
	begin

		
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
					for (i=0;i<4;i=i+1)begin
						if (Pin==Pins[i]&&acc_ID[i]==acc_number) isvalid=1'b1;
							if ( isvalid) 
           							next_state=home;                             
             							else                                               
	                                                       
						begin
							Counter = Counter + 1'b1;
							next_state = password; //added to be checked
							if(Counter == 2'b11)
								next_state = reset;
						end
                                     end
				end

			home:					    
				begin
					`DELAY
					op = Operation; //in verification force user to exit as we don't have time
					if(op == 3'b000) next_state = withdraw;
					else if(op == 3'b010) next_state = deposit;
					else if(op == 3'b010) next_state = updbalance;
					else if(op == 3'b011) next_state=transfer;
                                        else if(op == 3'b100) next_state=changePin;
                                        
					else next_state = reset;
				end

			withdraw:
				begin
					if(home_in) next_state = home;
					else 
					begin
					if(isvalid)
					begin 
                                        if(WithDraw_Amount  > 0) Enteramount = 1'b1; 
					else Enteramount = 1'b0;
					if(Enteramount) next_state = sub_balance;
					else next_state = withdraw;
                                                
                                          end
                                       else next_state=reset;
					end 
				end
			deposit: begin
				if(home_in) next_state = home;
					else 
					begin
					if(isvalid)
				begin
					if(Deposit_Amount > 0) Enteramount = 1'b1; 
					else Enteramount = 1'b0;
					if(Enteramount) next_state = add_balance;
					else next_state = deposit;
				end
                                        else next_state=reset;
				end 
				end

			updbalance:
				begin
					Check_balance = balance[i];
					next_state = home;
				end

			check_balance:
				begin
					if(WithDraw_Amount <= balance[i]) issufficent = 1'b1;
					else issufficent = 1'b0;
					if(issufficent) next_state = sub_balance;
					else next_state = home;
				end

                        transfer:
                              begin 
				if (isvalid)
			        next_state=transferingmoney;
				else 
			        next_state=home;
                              end 
			transferingmoney:begin 
			if (balance[srcacc]>=Transfer_amount)
			begin 
			 balance[srcacc]=balance[srcacc]-Transfer_amount;
			 balance[destacc]=balance[destacc]+Transfer_amount;
		        end
			else
			next_state=home;						 
			end
			add_balance: 
				begin
					balance[i] = balance[i] + Deposit_Amount;
					next_state = home;
				end

			sub_balance:
				begin
					balance[i] = balance[i] - WithDraw_Amount;
					next_state = home; //TO BE SET TO home
				end
			changePin:begin
			     if(isvalid)
				 begin
				 Pins[i]=newpin;
				 next_state=home;
				 end
				 else
				 next_state=home;
				end

			reset:
				begin
					next_state = IDLE;
					isvalid = 1'b0; issufficent = 1'b0; Enteramount = 1'b0; gohome = 1'b0;
					Counter = 2'b00;
					
				end

			default:
				begin
					next_state = reset;
					
				end

		endcase
	end

endmodule


 
