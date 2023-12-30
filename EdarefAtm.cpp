#include <iostream>

#define DELAY 2
#define LARGEDELAY 100

enum State {
    IDLE,
    LANGUAGE,
    PASSWORD,
    HOME,
    WITHDRAW,
    DEPOSIT,
    SHOWBALANCE,
    SUFFICIENT,
    ADDBALANCE,
    SUBBALANCE,
    TRANSFER,
    TRANSFERINGMONEY,
    CHANGEPIN,
    RESET
};

class topLevelATM {
public:
    void processInput(bool insertCard, bool languageChosen, bool exit, bool homeIn,
                       int pin, int accNumber, int newPin,
                       int depositAmount, int withdrawAmount, int transferAmount,
                       int operation, int destinationAccountID);
    int getBalance() const ;
    std::string getOperation() const;
    std::string getCurrentState() const;
    void reset();


    

private:
    int current_state;
    int destacc, srcacc;
    int counter;
    int op;
    bool destAccFound;
    bool isValid, isSufficient, enterAmount, goHome;
    int accID[4] = {3, 2, 1, 0};
    int pins[4] = {0, 1, 2, 3};
    int balance[4] = {40, 0, 5, 50};


    void delay(int cycles);
};

void topLevelATM::reset() {
    current_state = RESET;
    isValid = false;
    isSufficient = false;
    enterAmount = false;
    goHome = false;
    counter = 0;
    destacc = 0;
    srcacc = -1;
    destAccFound = false;
}


void topLevelATM::delay(int cycles) {
    // Implement delay logic
}


int topLevelATM::getBalance() const {
     if (srcacc >= 0 && srcacc < 4) {
         return balance[srcacc];
     } else {
         // Handle the case where srcacc is invalid (-1)
         std::cout << "Did not verify user yet";
         return 0;  // or any other suitable value to indicate an error
     }
 }

std::string topLevelATM::getOperation() const {
    switch (op) {
        case 0: return "Withdraw";
        case 1: return "Deposit";
        case 2: return "ShowBalance";
        case 3 : return "Transfer";
        case 4 : return "Change Pin";

        default: return "Unknown";
    }
}

std::string topLevelATM::getCurrentState() const {
        switch (current_state) {
            case IDLE: return "IDLE";
            case LANGUAGE: return "LANGUAGE";
            case PASSWORD: return "PASSWORD";
            case HOME: return "HOME";
            case WITHDRAW: return "WITHDRAW";
            case DEPOSIT: return "DEPOSIT";
            case SHOWBALANCE: return "SHOWBALANCE";
            case SUFFICIENT: return "SUFFICIENT";
            case ADDBALANCE: return "ADDBALANCE";
            case SUBBALANCE: return "SUBBALANCE";
            case TRANSFER: return "TRANSFER";
            case TRANSFERINGMONEY: return "TRANSFERINGMONEY";
            case CHANGEPIN: return "CHANGEPIN";
            case RESET: return "RESET";
            default: return "Unknown";
        }
    }
void topLevelATM::processInput(bool insertCard, bool languageChosen, bool exit, bool homeIn,
                                int pin, int accNumber, int newPin,
                                int depositAmount, int withdrawAmount, int transferAmount,
                                int operation, int destinationAccountID) {
    switch (current_state) {
        case IDLE:
            if (insertCard) {
                std::cout << "Card inserted, moving to language\n";
                current_state = LANGUAGE;
            } else {
                std::cout << "Remaining Idle\n";
                current_state = IDLE;
            }
            break;

        case LANGUAGE:
            if (languageChosen) {
                std::cout << "Language Chosen, moving to password\n";
                current_state = PASSWORD;
            } else {
                std::cout << "Language NOT chosen, Remaining in language\n";
                current_state = LANGUAGE;
            }
            break;

        case PASSWORD:
            if (exit) {
                std::cout << "Exit called, moving to reset\n";
                reset();
            } else {
                std::cout << "No exit called in password\n";
                isValid = false;

                for (int index = 0; index < 4; ++index) {
                    if (pin == pins[index] && accID[index] == accNumber) {
                        isValid = true;
                        srcacc = index;
                        break;
                    }
                }

                if (isValid) {
                    std::cout << "Valid PIN, moving to home\n";
                    goHome = false;
                    current_state = HOME;
                } else {
                    std::cout << "Invalid PIN\n";
                    counter++;

                    if (counter == 3) {
                        std::cout << "Maximum attempts reached, moving to reset\n";
                        reset();
                    } else {
                        std::cout << "Remaining in password state\n";
                        current_state = PASSWORD;
                    }
                }
            }
            break;

        case HOME:
            delay(DELAY);
            std::cout << "Reached home\n";

            if (goHome) {
                std::cout << "Looping in home. Waiting for reset\n";
                current_state = HOME;
            } else {
                std::cout << "Choosing Operation\n";
                op = operation;

                switch (op) {
                    case 0:
                        std::cout << "OP chosen: WITHDRAW " << withdrawAmount << "\n";
                        current_state = WITHDRAW;
                        break;

                    case 1:
                        std::cout << "OP chosen: DEPOSIT " << depositAmount << "\n";
                        current_state = DEPOSIT;
                        break;

                    case 2:
                        std::cout << "OP Chosen: SHOW_BALANCE\n";
                        current_state = SHOWBALANCE;
                        break;

                    case 3:
                        std::cout << "OP CHOSEN: TRANSFER\n";
                        current_state = TRANSFER;
                        break;

                    case 4:
                        std::cout << "OP CHOSEN: CHANGE PIN TO " << newPin << "\n";
                        current_state = CHANGEPIN;
                        break;

                    default:
                        std::cout << "OP CHOSEN: ERROR, UNDEFINED STATE\n";
                        reset();
                        break;
                }
            }
            break;

        case WITHDRAW:
            std::cout << "Reached withdraw\n";
            if (homeIn)
                current_state = HOME;
            else if (exit)
                current_state = RESET;
            else {
                if (isValid) {
                    std::cout << "isValid Conditional passed in withdraw\n";
                    if (withdrawAmount > 0) {
                        enterAmount = true;
                        std::cout << "Enteramount conditional passed in withdraw\n";
                    } else {
                        enterAmount = false;
                        std::cout << "Enteramount conditional failed in withdraw\n";
                    }

                    if (enterAmount) {
                        std::cout << "Going to sufficient\n";
                        current_state = SUFFICIENT;
                    } else {
                        std::cout << "Not going to sufficient\n";
                        current_state = WITHDRAW;
                    }
                } else
                    current_state = RESET;
            }
            break;

        case DEPOSIT:
            std::cout << "Deposit Reached\n";
            if (homeIn)
                current_state = HOME;
            else if (exit)
                current_state = RESET;
            else {
                if (isValid) {
                    std::cout << "isValid Conditional passed in deposit\n";
                    if (depositAmount > 0) {
                        enterAmount = true;
                        std::cout << "Enteramount conditional passed in deposit\n";
                    } else {
                        enterAmount = false;
                        std::cout << "Enteramount conditional failed in deposit\n";
                    }

                    if (enterAmount)
                        current_state = ADDBALANCE;
                    else
                        current_state = DEPOSIT;
                } else
                    current_state = RESET;
            }
            break;

        case SHOWBALANCE:
            std::cout << "SHOW BALANCE REACHED\n";
            // Assuming Check_balance is an output, set its value here
            // Check_balance = balance[srcacc];
            goHome = true;
            current_state = HOME;
            break;

        case SUFFICIENT:
            std::cout << "Entered sufficient\n";
            if (withdrawAmount <= balance[srcacc]) {
                isSufficient = true;
                std::cout << "BALANCE IS SUFFICIENT, COMMENCING WITHDRAWAL\n";
            } else
                isSufficient = false;

            if (isSufficient)
                current_state = SUBBALANCE;
            else {
                std::cout << "ILLEGAL WITHDRAW OPERATION, INSUFFICIENT BALANCE\n";
                goHome = true;
                current_state = HOME;
            }
            break;

        case TRANSFER:
            std::cout << "ENTERED TRANSFER\n";
            if (isValid) {
                std::cout << "Is valid passed in transfer\n";
                current_state = TRANSFERINGMONEY;

                for (int j = 0; j < 4; ++j) {
                    if (accID[j] == destinationAccountID) {
                        destacc = j;
                        destAccFound = true;
                    }
                }

                if (!destAccFound) {
                    goHome = true;
                    std::cout << "ILLEGAL TRANSFER OPERATION, DEST ACCOUNT NOT FOUND, going home\n";
                    current_state = HOME;
                }
            } else {
                goHome = true;
                std::cout << "Is valid failed in transfer, going home\n";
                current_state = HOME;
            }
            break;

        case TRANSFERINGMONEY:
            if (balance[srcacc] >= transferAmount) {
                std::cout << "SRC amount bigger or equal to transfer amount, valid transfer\n";
                balance[srcacc] = balance[srcacc] - transferAmount;
                std::cout<<"balance in transfer : "<<balance[srcacc]<<std::endl;
                balance[destacc] += transferAmount;
            } else {
                std::cout << "Insufficient balance for transfer, going home\n";
            }
            goHome = true;

            current_state = HOME;

            // You don't need to set current_state = HOME here, as it will be set to HOME in the next iteration
            break;

        case ADDBALANCE:
            std::cout << "Reached addbalance\n";
            balance[srcacc] += depositAmount;
            goHome = true;
            current_state = HOME;
            break;

        case SUBBALANCE:
            std::cout << "Reached subbalance\n";
            balance[srcacc] -= withdrawAmount;
            goHome = true;
            current_state = HOME;
            break;

        case CHANGEPIN:
            std::cout << "Reached changePin\n";
            if (isValid) {
                std::cout << "Is valid passed in changePin\n";
                pins[srcacc] = newPin;
                goHome = true;
                current_state = HOME;
            } else {
                std::cout << "Is valid failed in changePin\n";
                goHome = true;
                current_state = HOME;
            }
            break;

        case RESET:
            reset();
            std::cout << "Reset called\n";
            current_state = IDLE;
            //reset();
            break;

        default:
            reset();
            break;
    }
    
    
}

int main() {
    topLevelATM atm;
    
    

//    void processInput(bool insertCard, bool languageChosen, bool exit, bool homeIn,
//                       int pin, int accNumber, int newPin,
//                       int depositAmount, int withdrawAmount, int transferAmount,
//                       int operation, int destinationAccountID);

//    int accID[4] = {3, 2, 1, 0};
//    int pins[4] = {0, 1, 2, 3};
//    int balance[4] = {40, 0, 5, 50};


    // Simulate multiple steps of state transitions
        for (int i = 0; i < 10; ++i) {

            std::cout<<"------------------------Show Balance ----------------"<<std::endl;
            std::cout << "Simulation Step: " << i + 1 << "\n";

            atm.processInput(true, true, false, false, 1, 2, 0, 0, 0, 0, 0, 0);


            // Print the balance after each step
            std::cout << "Current Balance: " << atm.getBalance() << "\n";

            std::cout << "Time=" << i << " Balance=" << atm.getBalance() << " Operation=" << atm.getOperation() << " State=" << atm.getCurrentState() << "\n";

            // Add a delay or wait for user input in a real application
        }


    atm.reset();




    
    


    // Simulate multiple steps of state transitions
        for (int i = 0; i < 10; ++i) {

            std::cout<<"------------------------Deposit 1 ----------------"<<std::endl;
            std::cout << "Simulation Step: " << i + 1 << "\n";

            atm.processInput(true, true, false, false, 0, 3, 1, 1, 0, 0, 1, 0);



            // Print the balance after each step
            std::cout << "Current Balance: " << atm.getBalance() << "\n";

            std::cout << "Time=" << i << " Balance=" << atm.getBalance() << " Operation=" << atm.getOperation() << " State=" << atm.getCurrentState() << "\n";

            // Add a delay or wait for user input in a real application
        }

    atm.reset();


    // Simulate multiple steps of state transitions
        for (int i = 0; i < 10; ++i) {

            std::cout<<"------------------------Withdraw  30 (ILLEGAL) ----------------"<<std::endl;
            std::cout << "Simulation Step: " << i + 1 << "\n";

            atm.processInput(true, true, false, false, 0, 3, 0, 0, 30, 0, 0, 0);



            // Print the balance after each step
            std::cout << "Current Balance: " << atm.getBalance() << "\n";

            std::cout << "Time=" << i << " Balance=" << atm.getBalance() << " Operation=" << atm.getOperation() << " State=" << atm.getCurrentState() << "\n";

            // Add a delay or wait for user input in a real application
        }

    atm.reset();



    // Simulate multiple steps of state transitions
        for (int i = 0; i < 15; ++i) {

            std::cout<<"------------------------transfer 5 from ACC 0011 TO 0010. 0010 HAS NO BAL AT START  ----------------"<<std::endl;
            std::cout << "Simulation Step: " << i + 1 << "\n";

            atm.processInput(true, true, false, false, 0, 3, 1, 0, 0, 10, 3, 2);





            // Print the balance after each step
            std::cout << "Current Balance: " << atm.getBalance() << "\n";

            std::cout << "Time=" << i << " Balance=" << atm.getBalance() << " Operation=" << atm.getOperation() << " State=" << atm.getCurrentState() << "\n";

            // Add a delay or wait for user input in a real application
        }

    atm.reset();

    
    
    //rANDOM TEST
    
//
//    srand(time(0));
//       int acc_number, WithDraw_Amount, Deposit_Amount, Transfer_amount, Destination_account_id,newpin;
//       for (int k = 0; k < 10000; k++)
//       {
//
//           atm.reset();
//           int random = rand() % 30;
//
//
//           if (random > 25)
//           {
//               acc_number = rand() % 16;
//           }
//           else
//           {
//               int Pin = rand() % 16;
//           }
//           int Operation = rand() % 6;
//           if (Operation == 0)
//           {
//               for (int l = 0; l < 32; l++)
//               {
//                   WithDraw_Amount = rand() % 64;
//               }
//           }
//           else if (Operation == 1)
//           {
//               for (int l = 0; l < 32; l++)
//               {
//                   Deposit_Amount = rand() % 64;
//               }
//           }
//           else if (Operation == 3)
//           {
//               for (int l = 0; l < 32; l++)
//               {
//                   Transfer_amount = rand() % 64;
//                   Destination_account_id = rand() % 6;
//               }
//           }
//           else if (Operation == 4)
//               newpin = rand() % 16;
//   for(int i = 0; i < 10 ;i++)
//           atm.processInput(true, true, false, false, (rand() % 5) , acc_number, newpin, Deposit_Amount, WithDraw_Amount, Transfer_amount, Operation, Destination_account_id);
//           std::cout << "Time: " << k << " Acc_number: " << acc_number
//               << " NewPin: " << newpin
//               << " Deposit_Amount: " << Deposit_Amount
//               << " Withdraw_Amount: " << WithDraw_Amount
//               << " Transfer_amount: " << Transfer_amount
//               << " Operation: " << Operation
//               << " Destination_account_id: " << Destination_account_id
//               << " Balance: " << atm.getBalance() << std::endl;
//
//       }
//


        return 0;
}
