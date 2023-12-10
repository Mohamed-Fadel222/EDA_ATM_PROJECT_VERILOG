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
reg [1:0] WP_Counter=2'b00;

reg AuthSucceded;
reg [2:0] opcode; // determine the operations like deposit, withdraw, check balance, transfer...etc

// Account database initialization
reg [3:0] PIN ;


    
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
		else 
                nextstate = IDLE;
        end
        insertcard: begin
            // Logic for insertcard state
            // Check card, move to Choose_Language state, etc.
            nextstate = Choose_Language;
        end
        Choose_Language: begin
            if (Language_Choosen)
                
           nextstate = EnterPIN;
        end
        // Implement other states similarly
        // Remember to add conditions and state transitions for other states and operations
        

    EnterPIN: begin
          if (Exit) nextstate=IDLE;
          else nextstate=EnterPIN;
          if (PIN==PIN_NUMBER) AuthSucceded=1'b1;
    	  else AuthSucceded=1'b0;
          if (AuthSucceded)begin
          nextstate=chooseOP;
          end 
          else begin 
              WP_Counter=WP_Counter+1'b1;
              if (WP_Counter==2'b11)
              nextstate=reset;

      end 
end    

   chooseOP: begin  //add the logic of Choose operation
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

