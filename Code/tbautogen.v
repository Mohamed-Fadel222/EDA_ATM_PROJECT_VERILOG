`timescale 1ns/1ps



module topLevelATM_tb;

	reg clk;
	reg rst;
	reg [3:0] Pin;
	reg [3:0] acc_number;
	reg [3:0] newpin;
	reg [5:0] Deposit_Amount;
	reg [5:0] WithDraw_Amount;
	reg [5:0] Transfer_amount;
	reg [2:0] Operation;
	reg [3:0] Destination_account_id;
	wire [3:0] current_state;
	wire [7:0] Check_balance;
	reg Insert_card;
	reg Language_chosen;
	reg exit;
	reg home_in;
	reg password_entered;
topLevelATM topLevelATM_tb (
	.clk(clk),
	.rst(rst),
	.Pin(Pin),
	.acc_number(acc_number),
	.newpin(newpin),
	.Deposit_Amount(Deposit_Amount),
	.WithDraw_Amount(WithDraw_Amount),
	.Transfer_amount(Transfer_amount),
	.Operation(Operation),
	.Destination_account_id(Destination_account_id),
	.current_state(current_state),
	.Check_balance(Check_balance),
	.Insert_card(Insert_card),
	.Language_chosen(Language_chosen),
	.exit(exit),
	.home_in(home_in),
	.password_entered(password_entered)
);



	integer i;

initial begin
	clk = 0;
	forever begin #5 clk = ~clk;
end
end
initial begin
	#2 // Initial delay
	//======================================================
	// BAs Test
	//======================================================

$display("----------BLOCKING ASSIGNMENT TESTS----------");	// BA Test for RHS: Pin
	Pin = 4'b0011;
	#2
	Pin = 4'b0001;
	#2
	Pin = 4'b0111;
	#2
	Pin = 4'b0101;
	#2
	Pin = 4'b0000;
	#2
	rst = 1;
	#2
	rst = 0;
	#2
	#2
	// BA Test for RHS: Operation
	Operation = 3'b111;
	#2
	Operation = 3'b100;
	#2
	Operation = 3'b110;
	#2
	Operation = 3'b001;
	#2
	Operation = 3'b000;
	#2
	rst = 1;
	#2
	rst = 0;
	#2
	#2
	// BA Test for RHS: balance[srcacc]-Transfer_amount
	Transfer_amount = 6'b001010;
	#2
	Transfer_amount = 6'b101100;
	#2
	Transfer_amount = 6'b101101;
	#2
	Transfer_amount = 6'b101011;
	#2
	Transfer_amount = 6'b001101;
	#2
	rst = 1;
	#2
	rst = 0;
	#2
	#2
	// BA Test for RHS: balance[i] + Deposit_Amount
	Deposit_Amount = 6'b110000;
	#2
	Deposit_Amount = 6'b011001;
	#2
	Deposit_Amount = 6'b100101;
	#2
	Deposit_Amount = 6'b111101;
	#2
	Deposit_Amount = 6'b111111;
	#2
	rst = 1;
	#2
	rst = 0;
	#2
	#2
	// BA Test for RHS: balance[i] - WithDraw_Amount
	WithDraw_Amount = 6'b010110;
	#2
	WithDraw_Amount = 6'b110011;
	#2
	WithDraw_Amount = 6'b101010;
	#2
	WithDraw_Amount = 6'b100110;
	#2
	WithDraw_Amount = 6'b110111;
	#2
	rst = 1;
	#2
	rst = 0;
	#2
	#2
	// BA Test for RHS: newpin
	newpin = 4'b1001;
	#2
	newpin = 4'b1110;
	#2
	newpin = 4'b0000;
	#2
	newpin = 4'b0100;
	#2
	newpin = 4'b0101;
	#2
	rst = 1;
	#2
	rst = 0;
	#2
	#2
	//======================================================
	//======================================================
	// NBAs Test
	//======================================================

$display("----------NON BLOCKING ASSIGNMENT TESTS----------");	//======================================================
	//======================================================
	// Random and Specific Case Test
	//======================================================

$display("----------RANDOM CASE TESTS----------");
$display("----------SPECIFIC CASE TESTS----------");	//======================================================
	//======================================================
	// If Statements Test
	//======================================================

$display("----------IF TESTS----------");	// If Statement Test for IFMEMBERS: ['rst']
	rst = 1'b1;
	#2
	rst = 1'b0;
	#2
	rst = 1;
	#2
	rst = 0;
	#2
	#2
	// If Statement Test for IFMEMBERS: ['Insert_card']
	Insert_card = 1'b1;
	#2
	Insert_card = 1'b0;
	#2
	rst = 1;
	#2
	rst = 0;
	#2
	#2
	// If Statement Test for IFMEMBERS: ['Language_chosen']
	Language_chosen = 1'b1;
	#2
	Language_chosen = 1'b0;
	#2
	rst = 1;
	#2
	rst = 0;
	#2
	#2
	// If Statement Test for IFMEMBERS: ['password_entered', 'pinInStorage', 'Pin', 'Pin', 'b1111']
	Pin = 4'b1001;
	#2
	Pin = 4'b0010;
	#2
	Pin = 4'b0001;
	#2
	Pin = 4'b1111;
	#2
	Pin = 4'b1100;
	#2
	rst = 1;
	#2
	rst = 0;
	#2
	#2
	// If Statement Test for IFMEMBERS: ['password_entered', 'pinInStorage', 'Pin', 'Pin', 'b1111']
	password_entered = 1'b1;
	#2
	password_entered = 1'b0;
	#2
	rst = 1;
	#2
	rst = 0;
	#2
	#2
	// If Statement Test for IFMEMBERS: ['exit']
	exit = 1'b1;
	#2
	exit = 1'b0;
	#2
	rst = 1;
	#2
	rst = 0;
	#2
	#2
	// If Statement Test for IFMEMBERS: ['Pin', 'Pins', 'index', 'acc_ID', 'index', 'acc_number']
	acc_number = 4'b1111;
	#2
	acc_number = 4'b0101;
	#2
	acc_number = 4'b1011;
	#2
	acc_number = 4'b0111;
	#2
	acc_number = 4'b1000;
	#2
	rst = 1;
	#2
	rst = 0;
	#2
	#2
	// If Statement Test for IFMEMBERS: ['home_in']
	home_in = 1'b1;
	#2
	home_in = 1'b0;
	#2
	rst = 1;
	#2
	rst = 0;
	#2
	#2
	// If Statement Test for IFMEMBERS: ['WithDraw_Amount']
	WithDraw_Amount = 6'b110110;
	#2
	WithDraw_Amount = 6'b111100;
	#2
	WithDraw_Amount = 6'b011111;
	#2
	WithDraw_Amount = 6'b101110;
	#2
	WithDraw_Amount = 6'b001101;
	#2
	rst = 1;
	#2
	rst = 0;
	#2
	#2
	// If Statement Test for IFMEMBERS: ['Deposit_Amount']
	Deposit_Amount = 6'b100101;
	#2
	Deposit_Amount = 6'b011111;
	#2
	Deposit_Amount = 6'b000101;
	#2
	Deposit_Amount = 6'b101010;
	#2
	Deposit_Amount = 6'b001000;
	#2
	rst = 1;
	#2
	rst = 0;
	#2
	#2
	// If Statement Test for IFMEMBERS: ['acc_ID', 'index', 'Destination_account_id']
	Destination_account_id = 4'b1111;
	#2
	Destination_account_id = 4'b0000;
	#2
	Destination_account_id = 4'b1011;
	#2
	Destination_account_id = 4'b0110;
	#2
	Destination_account_id = 4'b1010;
	#2
	rst = 1;
	#2
	rst = 0;
	#2
	#2
	// If Statement Test for IFMEMBERS: ['balance', 'srcacc', 'Transfer_amount']
	Transfer_amount = 6'b101000;
	#2
	Transfer_amount = 6'b010110;
	#2
	Transfer_amount = 6'b010101;
	#2
	Transfer_amount = 6'b001100;
	#2
	Transfer_amount = 6'b011110;
	#2
	rst = 1;
	#2
	rst = 0;
	#2
	#2
	// If Statement Test for IFMEMBERS: ['isvalid', 'newpin', 'b1111']
	newpin = 4'b0100;
	#2
	newpin = 4'b0011;
	#2
	newpin = 4'b1101;
	#2
	newpin = 4'b0000;
	#2
	newpin = 4'b0101;
	#2
	rst = 1;
	#2
	rst = 0;
	#2
	#2
	//======================================================
	//======================================================
	// Logical Test
	//======================================================

$display("----------LOGICAL OPERATOR TESTS----------");	// Logical Test for Member: Pin
	Pin = 4'b1100;
	#2
	Pin = 4'b1000;
	#2
	Pin = 4'b1011;
	#2
	Pin = 4'b0000;
	#2
	Pin = 4'b1110;
	#2
	rst = 1;
	#2
	rst = 0;
	#2
	#2
	//======================================================
	//======================================================
	// Random Test Loop
	//======================================================

$display("----------FULLY RANDOM TEST LOOP----------");		for (i = 0; i < 100000 ; i = i + 1) begin
			rst = {$random} % 2;
			#2;
			Pin = {$random} % 16;
			#2;
			acc_number = {$random} % 16;
			#2;
			newpin = {$random} % 16;
			#2;
			Deposit_Amount = {$random} % 64;
			#2;
			WithDraw_Amount = {$random} % 64;
			#2;
			Transfer_amount = {$random} % 64;
			#2;
			Operation = {$random} % 8;
			#2;
			Destination_account_id = {$random} % 16;
			#2;
			Insert_card = {$random} % 2;
			#2;
			Language_chosen = {$random} % 2;
			#2;
			exit = {$random} % 2;
			#2;
			home_in = {$random} % 2;
			#2;
			password_entered = {$random} % 2;
			#2;
		end
$stop;
end
	//======================================================
	// Monitor Block
	//======================================================
	initial begin
		$monitor("Time = %0t current_state = %b Check_balance = %b", $time , current_state, Check_balance);	end

endmodule