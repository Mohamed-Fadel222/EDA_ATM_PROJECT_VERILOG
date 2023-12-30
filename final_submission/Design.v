`timescale 1ns / 1ns

`define DELAY #2
`define LARGEDELAY #100
module topLevelATM(
	input clk,
	input rst,
	input [3:0] Pin,acc_number,newpin,
	input [5:0] Deposit_Amount,
	input [5:0] WithDraw_Amount,Transfer_amount,
	input [2:0] Operation,
	input [3:0] Destination_account_id,
	output reg [3:0] current_state,
	output reg[7:0] Check_balance,// after show balance operation
	input Insert_card, Language_chosen  ,exit, home_in, password_entered	 //InsertCard,LanguageChosen,Exit
    );


//reg [3:0] pin_number = 4'b1111; <DEPRACATED , SEE pinInStorage>	
//reg [7:0] balance = 8'd30; <DEPRACATED>


//--------------------------------------INTERNAL REGISTERS & FLAGS ---------------------------------------------------//
reg [3:0] next_state;
reg [1:0] destacc,srcacc;
reg [1:0] Counter = 2'b00;
reg [2:0] op;
reg dest_acc_found = 0;
reg	isvalid= 1'b0,issufficent= 1'b0, Enteramount =1'b0, gohome=1'b0; //ValidPass,BalanceCheck,EnteredAmount, home


//------------------------------------------STATES------------------------//
parameter  IDLE = 4'b0000,
			language = 4'b0001,
			password = 4'b0010,
			home  = 4'b0011,
			withdraw  = 4'b0100,
			deposit  = 4'b0101,
			showbalance = 4'b0110,
			sufficient  = 4'b0111,
			add_balance  = 4'b1000,
			sub_balance = 4'b1001,
			transfer=4'b1010,
                        transferingmoney=4'b1011,
                        changePin=4'b1100,
			reset = 4'b1111;	


//------------------------ACCOUNT STORAGE----------------------------//
reg [3:0] acc_ID[0:3];
reg [3:0] Pins[0:3];
reg [7:0] balance [0:3];
reg [3:0] pinInStorage = 4'b1111; //default pin, do not use in POPULATION-------------------///

//------------------------------------------------------------------//

//-------------------------------ACCOUNT POPULATION-------------------///
initial begin
    acc_ID[0] = 4'b0011; Pins[0] = 4'b0000;  balance[0] = 8'd40;
    acc_ID[1] = 4'b0010; Pins[1] = 4'b0001;  balance[1] = 8'd00;
    acc_ID[2] = 4'b0001; Pins[2] = 4'b0010;  balance[2] = 8'd5;
    acc_ID[3] = 4'b0000; Pins[3] = 4'b0011;  balance[3] = 8'd50;
    end
//-------------------------------------------------------------------///

//----------------------------------STATE TRANSITION MACHINE----------------------------//
				
always @( posedge clk or posedge rst)
	begin
		if (rst)
			begin
				current_state <= reset;
			end
		else current_state <= next_state;
	end
//-------------------------------------------------------------------------------------//
	
//--------------------------------LOOP integers--------------------------------------//
integer i;	//SRC ACCOUNT
integer index; //LOOP 
//integer j; //DEST ACCOUNT <DEPRACATED, SEE INDEX>
//---------------------------------------------------------------------------------//


//----------------------------------------------FINITE STATE MACHINE-----------------------------------//
always@(*)
	begin

		
		case (current_state)
		
		
		
			IDLE:	
					if(Insert_card) begin
					$display ("card inserted, moving to language");
					next_state = language;
					end
					else begin
					$display ("Remaining Idle");
			
					next_state = IDLE;
					end

			language: if(Language_chosen) 
					begin
					next_state = password;
					$display ("Language Chosen, moving to password");
					end
				 else begin 
					next_state = language;
					$display ("language NOT chosed, Remaining in language");
					end
					

			password: 	
					
				
					if(password_entered && pinInStorage != Pin && Pin != 4'b1111) begin //PASS ENTERED, PIN CHANGED FROM LAST TIME, PIN NOT RESERVED 1111
						pinInStorage=Pin;
						if(exit) //EXIT
						begin
						$display ("exit called, moving to reset");
						next_state = reset;
						end //EXIT
						else 	
						begin //ELSE LOOP
							$display ("No exit called in password");
							
							next_state = password;
							
							for (index=0;index<4;index=index+1)
					
								begin//FOR LOOP
									if (Pin == Pins[index] && acc_ID[index] == acc_number) 
									begin //INNER IF
									isvalid=1'b1;
									i = index;
									end//INNER IF
								end//FOR LOOP
						
					
							if ( isvalid) 
								next_state=home;                             
							else                                               
	                                                       
								begin//SECOND ELSE
									Counter = Counter + 1'b1;
									$display("PIN %b incorrect, attempt number %d",pinInStorage ,Counter);
									next_state = password; //added to be checked
									if(Counter == 2'b11)
									begin //FINAL IF
									next_state = home;
									gohome = 1'b1;
									$display("PIN failed 3 times, going home, awaiting reset");
									end//FINAL IF
								end//SECOND ELSE
						end //ELSE LOOP
					end //PASS ENTERED
					else begin
					next_state = password;
					$display("LOOPING IN PASSWORD, awaiting RESET OR PIN CHANGE, OR PASS ENTRY");
					end
	

			home:					    
				begin
				
					`DELAY
					$display ("Reached home");
					if(gohome)
					begin
					next_state = home;
					$display ("Looping in home. waiting for reset");
					end
					
					else 
					begin
						
						$display ("choosing Operation");
						op = Operation;
					
						if(op == 3'b000)begin
						next_state = withdraw;
						$display ("OP chosen :  WITHDRAW %d",WithDraw_Amount);
						end
						
						else if(op == 3'b001)begin
						next_state = deposit;
						$display ("OP chosen: DEPOSIT %d", Deposit_Amount);
						end
						
						else if(op == 3'b010)begin
						$display ("OP Chosen : SHOW_BALANCE ....");
						next_state = showbalance;
						end
						else if(op == 3'b011)begin 
						next_state=transfer;
						$display ("OP CHOSEN, transfer");
						end
						else if(op == 3'b100)begin 
						next_state=changePin;
						$display ("OP CHOSEN: CHANGE PIN TO %d", newpin);
						end
						else begin
						next_state = reset;
						$display ("OP CHOSED : ERROR, UNDEFINED STATE");
						end
					end
					
				end

			withdraw:
				
			
			
			
			
				begin
					$display ("Reached withdraw");
					if(home_in) next_state = home;
					else if(exit)next_state = reset;
					else
					
					begin
					
						if(isvalid)
						begin 
						
						$display ("isValid Conditional passed in withdraw");

                                if(WithDraw_Amount  > 0) 
									begin
									Enteramount = 1'b1; 
									$display ("Enteramount conditional passed in withdraw");
									end

								else 
									begin 
									Enteramount = 1'b0;
									$display ("Enteramount conditional failed in withdraw");
									end

								if(Enteramount) 
									begin
									next_state = sufficient;
									$display ("Going to sufficient");
									end

								else 
									begin
									$display("Not going to sufficient");
									next_state = withdraw; 
									end
                                                
                        end
                        else next_state=reset;
					end 
					
				end
				
				
				
				
			deposit: 
				begin
					$display ("Deposit Reached");
					
					if(home_in) next_state = home;
					
					else if (exit) next_state = reset;
					
					else
					
					begin
					
						if(isvalid)
						begin
							$display ("isValid Conditional passed in deposit");
							if(Deposit_Amount > 0) begin
							Enteramount = 1'b1; 
							$display ("Enteramount conditional passed in deposit");
							end
							
							else begin 
							Enteramount = 1'b0;
							$display ("Enteramount conditional failed in deposit");
							end
							
							if(Enteramount) next_state = add_balance;
							else next_state = deposit;
						end
                        else next_state=reset;
					end 
				end
			
			
			
			showbalance:
				begin
					$display ("SHOW BALANCE REACHED");
					Check_balance = balance[i];
					gohome = 1'b1;
					next_state = home;
				end



			sufficient:
			
				begin
				$display ("Entered sufficient");

					if(WithDraw_Amount <= balance[i])begin
					issufficent = 1'b1;
					$display ("BALANCE IS SUFFICIENT, COMMENCING WITHDRAWL");
					end
					
					
					else issufficent = 1'b0;
					if(issufficent) next_state = sub_balance;
					else begin
					$display ("ILLEGAL WITHDRAW OPERATION, INSUFFICIENT BALANCE");
					gohome = 1'b1;
					next_state = home; //TO BE SET TO home
					end
				end




            transfer:
			
				begin //INITIAL
					$display ("ENTERED TRANSFER");
					if (isvalid)
					begin //ISVALID
								$display ("Is valid passed in transfer");
								next_state=transferingmoney;
								srcacc = i;
						
								for (index=0;index<4;index=index+1)begin //FOR
								
					
								
									if (acc_ID[index] == Destination_account_id)
									begin //INNER IF
									destacc = index;
									dest_acc_found = 1'b1;
									end//INNER IF
									
								end//FOR
								
								if(~dest_acc_found) begin //CHECK FOUND IF
								gohome = 1'b1;
								next_state = home; //TO BE SET TO home
								$display ("ILLEGAL TRANSFER OPERATION, DEST ACCOUNT NOT FOUND, going home");
								end //CHECK FOUND I
								
								
							
						
						
						
					end //ISVALID	
					else 
					begin//ELSE
					gohome = 1'b1;
					next_state = home; //TO BE SET TO home
					$display ("Is valid failed in transfer, going home");
					end//ELSE
            
                end//initial
				
				
				
				
			transferingmoney:
			
				begin 
					if (balance[srcacc]>=Transfer_amount)
					begin 
						$display ("SRC amount bigger or equal to transfer amount, valid transfer");
						if(srcacc != destacc)
						begin
						balance[srcacc]=balance[srcacc]-Transfer_amount;
						balance[destacc]=balance[destacc]+Transfer_amount;
						end
						else $display("SELF TRANSFER, ILLEGAL OPERATION, going home");
					end
					else 
					
					begin
					$display("SRC amount smaller than transfer amount, ILLEGAL TRANSFER, going home, awaiting reset");
					end
					
					begin
					gohome = 1'b1;
					next_state = home; //TO BE SET TO home		
					end
					
				end
			
			
			
			
			
			add_balance: 
				begin
				 $display ("Reached addbalance");

					balance[i] = balance[i] + Deposit_Amount;
					gohome = 1'b1;
					next_state = home; //TO BE SET TO home
				end

			sub_balance:
			
			
				begin
					$display ("Reached subbalance");
					balance[i] = balance[i] - WithDraw_Amount;
					gohome = 1'b1;
					next_state = home; //TO BE SET TO home
				end
				
				
			changePin:
			
			begin
				$display ("Reached changePin");
			     if(isvalid && newpin != 4'b1111)
				
					begin
					 $display ("Is valid passed in changePin");
						Pins[i]=newpin;
						gohome = 1'b1;
						next_state = home; //TO BE SET TO home
					end
					else begin
					$display ("is valid failed in changePin, or reserved pin chosen");
						gohome = 1'b1;
					next_state = home; //TO BE SET TO home
					end
			end

			reset:
				begin
					$display ("reset called");
					next_state = IDLE;
					isvalid = 1'b0; issufficent = 1'b0; Enteramount = 1'b0; gohome = 1'b0;
					Counter = 2'b00; destacc = 2'b00; srcacc = 2'b00; dest_acc_found = 1'b0; pinInStorage = 4'b1111;
					
				end

			default:
				begin
					next_state = reset;
					
				end

		endcase
	end

endmodule
