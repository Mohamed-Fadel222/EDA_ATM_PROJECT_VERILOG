module mainmodule(
    input clk,
    input rst,
    input [3:0] PIN_NUMBER,
    input [3:0] AccountID,
    input [7:0] Deposit_amt,
    input [7:0] Withdraw_amt,
    input [2:0] Operation,
    input Language_Choosen,
    input isCardinserted,
    input [3:0] New_PIN,   		
    input Exit,
    output reg [7:0] currentBalance
);

parameter IDLE = 4'b0000;
parameter insertcard = 4'b0001;
parameter Choose_Language = 4'b0010;
parameter EnterPIN = 4'b0011;
parameter chooseOP = 4'b0100;
parameter withdraw = 4'b0101;
parameter deposit = 4'b0110;
parameter transfer = 4'b0111;
parameter Changepin = 4'b1000;
parameter showbalance = 4'b1001;
parameter reset = 4'b1111;

reg [3:0] currentstate;
reg [3:0] nextstate;
reg [2:0] i;
reg [1:0] WP_Counter=2'b00;
reg [7:0] Money2Bdeposit;
reg [7:0] Money2Bwithdrawn;
reg [7:0] transferedmoney;
reg AuthSucceded;
reg [2:0] opcode; // determine the operations like deposit, withdraw, check balance, transfer...etc

// Account database initialization
reg [3:0] PIN [3:0];
reg [3:0] AccountInfo [3:0];
reg [7:0] Balance [3:0];
initial begin
    AccountInfo[0] = 4'b0000; 
    AccountInfo[1] = 4'b0001; 
    AccountInfo[2] = 4'b0010; 
    AccountInfo[3] = 4'b0011; 
    PIN[0] = 4'b0000;
    PIN[1] = 4'b0001;
    PIN[2] = 4'b0010;
    PIN[3] = 4'b0011;
    Balance[0]=8'b11110000;
    Balance[1]=8'b10101010;
    Balance[2]=8'b00001111;
    Balance[3]=8'b11111111;	
end

always @(posedge clk or posedge rst)
begin
    if (rst)
        currentstate <= reset;
    else
        currentstate <= nextstate;
end

always @(*) begin
    // Default next state
    nextstate = currentstate;

    // FSM logic based on current state
    case (currentstate)
        IDLE: begin
            if (isCardinserted)
                nextstate = insertcard;
             
        end
        insertcard: begin
            // Logic for insertcard state
            // Check card, move to Choose_Language state, etc.
            nextstate = Choose_Language;
        end
        Choose_Language: begin
            // Logic for Choose_Language state
            // Choose language options, move to EnterPIN state, etc.
            nextstate = EnterPIN;
        end
        // Implement other states similarly
        // Remember to add conditions and state transitions for other states and operations
        EnterPIN: begin
            if (Exit) nextstate=IDLE;
            else nextstate=EnterPIN;
            for (i=0;i<4;i=i+1)begin
               if (AccountID==AccountInfo[i]&&PIN_NUMBER==PIN[i]) AuthSucceded=1'b1;
                else AuthSucceded=1'b0;
                if (AuthSucceded)
          	nextstate=chooseOP;
          else begin 
              WP_Counter=WP_Counter+1'b1;
              if (WP_Counter==2'b11)
              nextstate=reset;
         end
      end  
end   
        
        chooseOP: begin
            opcode=Operation;
            if (opcode==3'b000)nextstate=IDLE;
            else if (opcode==3'b001)nextstate=deposit;
            else if (opcode==3'b010)nextstate=withdraw;
	   // else if (opcode==3'b011)nextstate=IDLE;
            else if (opcode==3'b100)nextstate=Changepin;	
           // else if (opcode==3'b101)nextstate=IDLE;
            else nextstate=reset;
        end
        deposit: begin
            Money2Bdeposit=Deposit_amt;
            Balance[i]=Balance[i]+Money2Bdeposit;
            currentBalance=Balance[i];
            nextstate=chooseOP;

        end
        withdraw: begin
    Money2Bwithdrawn = Withdraw_amt;
    if (Balance[i] >= Money2Bwithdrawn) begin
        Balance[i] = Balance[i] - Money2Bwithdrawn;
        assign currentBalance = Balance[i];
        nextstate = chooseOP;
    end else begin
        nextstate = reset; // Insufficient balance, transition to reset state
    end
        end
	 Changepin: begin
            if (Exit)
                nextstate = IDLE; // Exit from changing PIN

            // Logic for changing PIN
            if (AccountID == AccountInfo[i] && PIN_NUMBER == PIN[i] && Operation == 3'b100) begin
                // Conditions met for changing PIN
                PIN[i] = New_PIN; // Update the PIN
                nextstate = IDLE; // Transition to IDLE state after PIN change
            end else begin
                // Incorrect credentials or operation for changing PIN
                nextstate = Changepin; // Remain in the same state
            end
        end
        // Implement logic for other states similarly
        // ...
        reset: begin
            // Logic for reset state
            // Resetting the system or initializing variables
        end
        default: begin
            // Default case
            // Handle unexpected conditions or states
        end
    endcase
end

// Other module logic (not part of FSM)
// ...

endmodule

