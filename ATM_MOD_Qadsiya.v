module mainmodule(
    input clk,
    input rst,
    input [3:0] PIN_NUMBER,
    input [3:0] AccountID,
    input [7:0] Deposit_amt,
    input [7:0] Withdraw_amt,
    input Language_Choosen,
    input isCardinserted,
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

reg AuthSucceded;
reg [2:0] opcode; // determine the operations like deposit, withdraw, check balance, transfer...etc

// Account database initialization
reg [3:0] PIN [3:0];
reg [3:0] AccountInfo [3:0];
initial begin
    AccountInfo[0] = 4'b0000; 
    AccountInfo[1] = 4'b0001; 
    AccountInfo[2] = 4'b0010; 
    AccountInfo[3] = 4'b0011; 
    PIN[0] = 4'b0000;
    PIN[1] = 4'b0001;
    PIN[2] = 4'b0010;
    PIN[3] = 4'b0011;
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
            // Logic for EnterPIN state
            // Transition to other states based on PIN input, etc.
            nextstate = chooseOP;
        end
        chooseOP: begin
            // Logic for chooseOP state
            // Define operations like deposit, withdraw, etc.
            // Transition to respective states based on operations
        end
        deposit: begin
            // Logic for deposit state
            // Process deposit operation
        end
        withdraw: begin
            // Logic for withdraw state
            // Process withdraw operation
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

