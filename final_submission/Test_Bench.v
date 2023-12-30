`timescale 1ns / 1ns

module TestBenchATM;
    reg clk, rst;
    reg [3:0] Pin, acc_number, newpin;
    reg [5:0] Deposit_Amount, WithDraw_Amount, Transfer_amount;
    reg [2:0] Operation;
    reg Insert_card, Language_chosen, exit, home_in, password_entered;
    wire [7:0] Check_balance;
	 wire [3:0] current_state;
	 reg [3:0] Destination_account_id;


    topLevelATM uut (
        .clk(clk),
        .rst(rst),
        .Pin(Pin),
        .acc_number(acc_number),
        .newpin(newpin),
        .Deposit_Amount(Deposit_Amount),
        .WithDraw_Amount(WithDraw_Amount),
        .Transfer_amount(Transfer_amount),
        .Operation(Operation),
        .Check_balance(Check_balance),
        .Insert_card(Insert_card),
        .Language_chosen(Language_chosen),
        .exit(exit),
        .home_in(home_in),
		.current_state(current_state),
		.Destination_account_id(Destination_account_id),
		.password_entered(password_entered)
    );
	
	
	//--------------------RANDOM TESTING VARIABLES---------------------------//
	integer rand;
	integer k;
	integer l;
	
	//---------------------------------------------------------------------//
	
	
    //--------------------- Clock generation---------------------------------//
    initial begin
        clk = 0;
        forever
		begin
	 	#1 clk = ~clk; //PERIOD OF 2 NS, 0.5 GHz CLOCK
		end
    end
	//-------------------------------------------------------------------//

    // Initial stimulus
    initial begin
	
	
	
	  ///RESET /////
        rst = 1; 
        Insert_card = 0;
        Language_chosen = 0;
        exit = 0;
        home_in = 0;
		password_entered = 0;
        #10 rst = 0;
	/////////////////////




	//////SHOW BALANCE - DIRECTED TEST 1//////
	Insert_card = 1;
        Language_chosen = 1;
        Pin = 4'b0000; acc_number = 4'b0011;
        Operation = 3'b010;
        Deposit_Amount = 6'b011000;
        WithDraw_Amount = 2'd10;
        Transfer_amount = 6'b010010;
        newpin = 4'b1010;
		Destination_account_id = 4'b0000;
		password_entered = 1;
	///////////////////////////////


	/////RESET - DIRECTED TEST 2/////////////////
	#100 rst = 1; 
        Insert_card = 0;
        Language_chosen = 0;
        exit = 0;
        home_in = 0;
        #10 rst = 0;
		password_entered = 0;
	////////////////////////////

    //////WITHDRAW 12   - DIRECTED TEST 3///////////
       Insert_card = 1;
        Language_chosen = 1;
        Pin = 4'b0000; acc_number = 4'b0011;
        Operation = 3'b000;
        Deposit_Amount = 6'b011000;
        WithDraw_Amount = 8'd12;
        Transfer_amount = 6'b010010;
        newpin = 4'b1010;
		Destination_account_id = 4'b0000;
		password_entered = 1;


	////////////////////////////////////////////
	
	///////////RESET//////////////

        #100 rst = 1; 
        Insert_card = 0;
        Language_chosen = 0;
        exit = 0;
        home_in = 0;
        #10 rst = 0;
		password_entered = 0;
	////////////////////////////////
	
	
	
	//////////SHOW BALANCE//////////////
	Insert_card = 1;
        Language_chosen = 1;
        Pin = 4'b0000; acc_number = 4'b0011;
        Operation = 3'b010;
        Deposit_Amount = 6'b011000;
        WithDraw_Amount = 8'd10;
        Transfer_amount = 6'b010010;
        newpin = 4'b1010;		
		Destination_account_id = 4'b0000;
		password_entered = 1;
	//////////////////////////////////////
	
	/////////RESET//////////////

   	 #100 rst = 1; 
        Insert_card = 0;
        Language_chosen = 0;
        exit = 0;
        home_in = 0;
        #10 rst = 0;
		password_entered = 0;
	////////////////////////////
	

    //////////Deposit 1 -  DIRECTED TEST 4//////////////////
        Insert_card = 1;
        Language_chosen = 1;
        Pin = 4'b0000; acc_number = 4'b0011;
        Operation = 3'b001;
        Deposit_Amount = 8'd1;
        WithDraw_Amount = 8'd10;
        Transfer_amount = 6'b010010;
        newpin = 4'b1010;
		Destination_account_id = 4'b0000;
		password_entered = 1;
	/////////////////////////////////////////////////////
	
	
	//////////RESET////////////////////

   	 #100 rst = 1; 
        Insert_card = 0;
        Language_chosen = 0;
        exit = 0;
        home_in = 0;
        #10 rst = 0;
		password_entered = 0;
	/////////////////////////////////////
	
	
	//////////////////////SHOW BALANCE////////////////
	Insert_card = 1;
     Language_chosen = 1;
     Pin = 4'b0000; acc_number = 4'b0011;
     Operation = 3'b010;
     Deposit_Amount = 6'b011000;
     WithDraw_Amount = 8'd10;
     Transfer_amount = 6'b010010;
     newpin = 4'b1010;
	 Destination_account_id = 4'b0000;
	 password_entered = 1;
	////////////////////////////////////////////////////
	
	
	//////////////RESET//////////////
        #100 rst = 1; 
        Insert_card = 0;
        Language_chosen = 0;
        exit = 0;
        home_in = 0;
        #10 rst = 0;
		password_entered = 0;
	/////////////////////////////////
		
		
	///////////WITHDRAW 30, ILLEGAL - DIRECTED TEST 5/////////////////
        Insert_card = 1;
        Language_chosen = 1;
        Pin = 4'b0000; acc_number = 4'b0011;
        Operation = 3'b000;
        Deposit_Amount = 8'd1;
        WithDraw_Amount = 8'd30;  //more than current,  30 > 29
        Transfer_amount = 6'b010010;
        newpin = 4'b1010;
		Destination_account_id = 4'b0000;
		password_entered = 1;
	////////////////////////////////////////////////////////////////
		
		
	/////////////////RESET////////////////////
		#100 rst = 1; 
        Insert_card = 0;
        Language_chosen = 0;
        exit = 0;
        home_in = 0;
        #10 rst = 0;
		password_entered = 0;
	//////////////////////////////////////////
	
	////////SHOW BALANCE////////////////////
	 Insert_card = 1;
     Language_chosen = 1;
     Pin = 4'b0000; acc_number = 4'b0011;
     Operation = 3'b010;
     Deposit_Amount = 6'b011000;
     WithDraw_Amount = 8'd10;
     Transfer_amount = 6'b010010;
     newpin = 4'b1010;
	 Destination_account_id = 4'b0000;
	 password_entered = 1;
	///////////////////////////////////////
	
		/////////////////RESET////////////////////
		#100 rst = 1; 
        Insert_card = 0;
        Language_chosen = 0;
        exit = 0;
        home_in = 0;
        #10 rst = 0;
		password_entered = 0;
	//////////////////////////////////////////
	
	///////////////transfer 5 from ACC 0011 TO 0010. 0010 HAS NO BAL AT START - DIRECTED TEST 6///////
	Insert_card = 1;
    Language_chosen = 1;
    Pin = 4'b0000; acc_number = 4'b0011;
    Operation = 3'b011;
    Deposit_Amount = 6'b011000;
    WithDraw_Amount = 8'd10;
    Transfer_amount = 8'd5;
    newpin = 4'b1010;
	Destination_account_id = 4'b0010;
	password_entered = 1;
	///////////////////////////////////////
	
	

	
	/////////////////RESET////////////////////
		#100 rst = 1; 
        Insert_card = 0;
        Language_chosen = 0;
        exit = 0;
        home_in = 0;
        #10 rst = 0;
		password_entered = 0;
	//////////////////////////////////////////
	
	////////SHOW BALANCE////////////////////
	 Insert_card = 1;
     Language_chosen = 1;
     Pin = 4'b0000; acc_number = 4'b0011;
     Operation = 3'b010;
     Deposit_Amount = 6'b011000;
     WithDraw_Amount = 8'd10;
     Transfer_amount = 6'b010010;
     newpin = 4'b1010;
	 Destination_account_id = 4'b0000;
	 password_entered = 1;
	///////////////////////////////////////
	
	/////////////////RESET////////////////////
		#100 rst = 1; 
        Insert_card = 0;
        Language_chosen = 0;
        exit = 0;
        home_in = 0;
        #10 rst = 0;
		password_entered = 0;
	//////////////////////////////////////////
	
	////////SHOW BALANCE OF ACC 0010 AFTER TRANSFER - DIRECTED TEST 6 PART 2////////////////////
	 Insert_card = 1;
     Language_chosen = 1;
     Pin = 4'b0001; acc_number = 4'b0010;
     Operation = 3'b010;
     Deposit_Amount = 6'b011000;
     WithDraw_Amount = 8'd10;
     Transfer_amount = 6'b010010;
     newpin = 4'b1010;
	 Destination_account_id = 4'b0000;
	 password_entered = 1;
	///////////////////////////////////////
	
	/////////////////RESET////////////////////
		#100 rst = 1; 
        Insert_card = 0;
        Language_chosen = 0;
        exit = 0;
        home_in = 0;
        #10 rst = 0;
		password_entered = 0;
	//////////////////////////////////////////
	
	///////////////TRANFER WITH INSUFFICIENT FUNDS - DIRECTED TEST 7 ///////
	Insert_card = 1;
    Language_chosen = 1;
    Pin = 4'b0001; acc_number = 4'b0010;
    Operation = 3'b011;
    Deposit_Amount = 6'b011000;
    WithDraw_Amount = 8'd10;
    Transfer_amount = 8'd20;
    newpin = 4'b1010;
	Destination_account_id = 4'b0000;
	password_entered = 1;
	///////////////////////////////////////
	
		///////////RESET//////////////

        #100 rst = 1; 
        Insert_card = 0;
        Language_chosen = 0;
        exit = 0;
        home_in = 0;
        #10 rst = 0;
		password_entered = 0;
	////////////////////////////////
	
	///////////////SELF TRANSFER - DIRECTED TEST 8 ///////
	Insert_card = 1;
    Language_chosen = 1;
    Pin = 4'b0001; acc_number = 4'b0010;
    Operation = 3'b011;
    Deposit_Amount = 6'b011000;
    WithDraw_Amount = 8'd10;
    Transfer_amount = 8'd1; //LEGAL AMOUNT
    newpin = 4'b1010;
	Destination_account_id = 4'b0010;
	password_entered = 1;
	///////////////////////////////////////
	
		///////////RESET//////////////

        #100 rst = 1; 
        Insert_card = 0;
        Language_chosen = 0;
        exit = 0;
        home_in = 0;
        #10 rst = 0;
		password_entered = 0;
	////////////////////////////////
	
	
    /////////////// transfer 5 from ACC 0011 TO 1111. 1111 DOES NOT EXIST- DIRECTED TEST 9///////
	$display("CASE STARTS HERE----------------------------------------------------------------");
	Insert_card = 1;
    Language_chosen = 1;
    Pin = 4'b0000; acc_number = 4'b0011;
    Operation = 3'b011;
    Deposit_Amount = 6'b011000;
    WithDraw_Amount = 8'd10;
    Transfer_amount = 8'd5;
    newpin = 4'b1010;
	Destination_account_id = 4'b0111;
	password_entered = 1;
	///////////////////////////////////////
	
	/////////////////RESET////////////////////
		#100 rst = 1; 
        Insert_card = 0;
        Language_chosen = 0;
        exit = 0;
        home_in = 0;
        #10 rst = 0;
		password_entered = 0;
	//////////////////////////////////////////
	
		////////SHOW BALANCE////////////////////
	 Insert_card = 1;
     Language_chosen = 1;
     Pin = 4'b0000; acc_number = 4'b0011;
     Operation = 3'b010;
     Deposit_Amount = 6'b011000;
     WithDraw_Amount = 8'd10;
     Transfer_amount = 6'b010010;
     newpin = 4'b1010;
	 Destination_account_id = 4'b0000;
	 password_entered = 1;
	///////////////////////////////////////
		
	/////////////////RESET////////////////////
		#100 rst = 1; 
        Insert_card = 0;
        Language_chosen = 0;
        exit = 0;
        home_in = 0;
        #10 rst = 0;
		password_entered = 0;
	//////////////////////////////////////////
	
	
	//PASSWORD NOT ENTERED LOOPS / CARD NOT INSERTED / EXIT CALLED
	
	////////SHOW BALANCE  ---  INCORRECT PIN TEST - DIRECTED TEST 10////////////////////
	 Insert_card = 1;
     Language_chosen = 1;
     Pin = 4'b0001; acc_number = 4'b0011; //ATTEMPT 1
     Operation = 3'b010;
     Deposit_Amount = 6'b011000;
     WithDraw_Amount = 8'd10;
     Transfer_amount = 6'b010010;
     newpin = 4'b1010;
	 Destination_account_id = 4'b0000;
	 password_entered = 1;
	 
	 #10 Pin = 4'b0011; //ATTEMPT 2
	 
	 #10 Pin = 4'b0111; //ATTEMPT 3
	///////////////////////////////////////
	
	/////////////////RESET////////////////////
		#100 rst = 1; 
        Insert_card = 0;
        Language_chosen = 0;
        exit = 0;
        home_in = 0;
        #10 rst = 0;
		password_entered = 0;
	//////////////////////////////////////////
	
	
	////////CHANGE PIN - - DIRECTED TEST 11////////////////////
	 Insert_card = 1;
     Language_chosen = 1;
     Pin = 4'b0000; acc_number = 4'b0011;
     Operation = 3'b100;
     Deposit_Amount = 6'b011000;
     WithDraw_Amount = 8'd10;
     Transfer_amount = 6'b010010;
     newpin = 4'b1010;
	 Destination_account_id = 4'b0000;
	 password_entered = 1;
	///////////////////////////////////////
	
		/////////////////RESET////////////////////
		#100 rst = 1; 
        Insert_card = 0;
        Language_chosen = 0;
        exit = 0;
        home_in = 0;
        #10 rst = 0;
		password_entered = 0;
	//////////////////////////////////////////
	
	////////SHOW BALANCE////////////////////
	 Insert_card = 1;
     Language_chosen = 1;
     Pin = 4'b1010; acc_number = 4'b0011;
     Operation = 3'b010;
     Deposit_Amount = 6'b011000;
     WithDraw_Amount = 8'd10;
     Transfer_amount = 6'b010010;
     newpin = 4'b1010;
	 Destination_account_id = 4'b0000;
	 password_entered = 1;
	///////////////////////////////////////
	
	/////////////////RESET////////////////////
		#100 rst = 1; 
        Insert_card = 0;
        Language_chosen = 0;
        exit = 0;
        home_in = 0;
        #10 rst = 0;
		password_entered = 0;
	//////////////////////////////////////////
	
////////CHANGE PIN - RESERVED PIN  - DIRECTED TEST 12////////////////////
	 Insert_card = 1;
     Language_chosen = 1;
     Pin = 4'b1010; acc_number = 4'b0011;
     Operation = 3'b100;
     Deposit_Amount = 6'b011000;
     WithDraw_Amount = 8'd10;
     Transfer_amount = 6'b010010;
     newpin = 4'b1111;
	 Destination_account_id = 4'b0000;
	 password_entered = 1;
	///////////////////////////////////////
	
	/////////////////RESET////////////////////
		#100 rst = 1; 
        Insert_card = 0;
        Language_chosen = 0;
        exit = 0;
        home_in = 0;
        #10 rst = 0;
		password_entered = 0;
	//////////////////////////////////////////
	
	////////SHOW BALANCE  - PASS NOT ENTERED - DIRECTED TEST - 13////////////////////
	 Insert_card = 1;
     Language_chosen = 1;
     Pin = 4'b1010; acc_number = 4'b0011;
     Operation = 3'b010;
     Deposit_Amount = 6'b011000;
     WithDraw_Amount = 8'd10;
     Transfer_amount = 6'b010010;
     newpin = 4'b1010;
	 Destination_account_id = 4'b0000;
	 password_entered = 0;
	 
	 #500 	 password_entered = 1; //PASS ENTERED LATER

	///////////////////////////////////////
	
	
	
	
	
	
	$display("Targeted test finished");	
   
	///////// Start_Randomized_test/////////
	
	#1 rst =1;
	#1 rst =0;
	for (k =0 ; k <10000;k =k +1)
	begin
		//////////RESET////////////////////
        #1 rst = 1; 
        Insert_card = 0;
        Language_chosen = 0;
        exit = 0;
        home_in = 0;
        #1 rst = 0;
        password_entered = 0;
    /////////////////////////////////////
		#1 Insert_card = 1;
		Language_chosen=1;
		password_entered = 1;
		
		
		rand={$random}%30;
		if (rand >25)
			begin
			#5 acc_number={$random}%16;
			end
		else 
			begin
			#5 Pin={$random}%16;
			end
				
		Operation={$random}%6;

		if (Operation==0)
			begin
			for (l=0;l<32;l=l+1)
				begin
				#5 WithDraw_Amount = {$random}%64;
				end
			end
		else if (Operation==1)
			begin
			for (l=0;l<32;l=l+1)
				begin
				#5 Deposit_Amount = {$random}%64;
				end
			end
		
		else if (Operation==3)
			begin
			for (l=0;l<8;l=l+1)
				begin
				#5 Transfer_amount = {$random}%64;
				#5 Destination_account_id={$random}%6;
				end
			end	
		else if (Operation==4)
			begin
			#5 newpin={$random}%16;
			end	
			
		
			
			
		
		
		
		
		end
	$display("Randomized test finished");
	$finish;
	end	
	
	
	
//psl assert always(rst==1->!exit)@(posedge clk);
    // Monitoring signals
    
    always @( posedge clk) $display("Time=%0t Balance=%d Operation=%b State=%b", $time, Check_balance, Operation, current_state);
		
endmodule
