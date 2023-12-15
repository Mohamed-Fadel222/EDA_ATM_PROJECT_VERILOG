//
// Created by IP3 on 15/12/2023.
//

#include "ATM.h"
#include "User.h"  // Assuming you have a User class

using namespace std;

ATM::ATM(const string& cardNumber, const string& cardPassword, double initialBalance)
        : cardNumber(cardNumber), cardPassword(cardPassword), balance(initialBalance) {}

User ATM::authenticate(const vector<User>& users) const {
    string enteredCardNumber, enteredPassword;

    cout << "Enter card number: ";
    cin >> enteredCardNumber;

    cout << "Enter card password: ";
    cin >> enteredPassword;

    // Search for the user with the given credentials
    for (const auto& user : users) {
        if (user.cardNumber == enteredCardNumber && user.cardPassword == enteredPassword) {
            return user;
        }
    }

    // Return a default-constructed user if not found (you can handle this case differently)
    return User("", "", 0.0);
}


void ATM::deposit(User user, double amount) {
    balance += amount;
    cout << "Deposit successful. New balance: " << balance << endl;
}

void ATM::withdraw(double amount) {
    if (amount > balance) {
        cout << "Insufficient funds!\nBalance unchanged" << endl;
    } else {
        balance -= amount;
        cout << "Withdrawal successful. New balance: " << balance << endl;
    }
}

void ATM::transferFunds(ATM& recipient, double amount) {
    if (amount > balance) {
        cout << "Insufficient funds for transfer!\nTransfer failed.\nBalance unchanged" << endl;
    } else {
        balance -= amount;
        recipient.deposit(amount, 0);
        cout << "Funds transferred successfully. New balance: " << balance << endl;
    }
}

void ATM::changePIN(const string& newPIN) {
    cardPassword = newPIN;
    cout << "PIN changed successfully." << endl;
}

void ATM::checkBalance() const {
    cout << "Current balance: " << balance << endl;
}

void ATM::performTransaction(std::vector<User> &users, User user) {
    int choice;
    double amount;
    string newPIN;

    do {
        displayMenu();
        cout << "Enter your choice: ";
        cin >> choice;

        switch (choice) {
            case 1:
            {
                cout << "Enter deposit amount: ";
                cin >> amount;
                deposit(user, amount);
                break;
            }

            case 2:
            {
                cout << "Enter withdrawal amount: ";
                cin >> amount;
                withdraw(amount);
                break;
            }

            case 3:
                checkBalance();
                break;

            case 4:
            {
                cout << "Enter recipient card number: ";
                string recipientCardNumber;
                cin >> recipientCardNumber;
                for (auto& recipient : users) {
                    if (recipient.cardNumber == recipientCardNumber) {
                        cout << "Enter transfer amount: ";
                        cin >> amount;
                        transferFunds(reinterpret_cast<ATM &>(recipient), amount);
                        break;
                    }
                }
                break;
            }

            case 5:
            {
                cout << "Enter new PIN: ";
                cin >> newPIN;
                changePIN(newPIN);
                break;
            }

            case 6:
                cout << "Exiting ATM. Thank you!" << endl;
                break;

            default:
                cout << "Invalid choice. Please try again." << endl;
        }

    } while (choice != 6);
}

void ATM::displayMenu() const {
    cout << "\nATM Menu:\n";
    cout << "1. Deposit\n";
    cout << "2. Withdraw\n";
    cout << "3. Check Balance\n";
    cout << "4. Transfer Funds\n";
    cout << "5. Change PIN\n";
    cout << "6. Exit\n";
}
