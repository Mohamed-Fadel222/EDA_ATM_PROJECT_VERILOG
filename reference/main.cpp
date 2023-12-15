#include <iostream>
#include <vector>
using namespace std;

class ATM {
private:
    string cardNumber;
    string cardPassword;
    double balance;

public:
    ATM(const string& cardNumber, const string& cardPassword, double initialBalance)
            : cardNumber(cardNumber), cardPassword(cardPassword), balance(initialBalance) {}

    bool authenticate() {
        string enteredCardNumber, enteredPassword;

        cout << "Enter card number: ";
        cin >> enteredCardNumber;

        cout << "Enter card password: ";
        cin >> enteredPassword;

        return (enteredCardNumber == cardNumber && enteredPassword == cardPassword);
    }

    void deposit(double amount) {
        balance += amount;
        cout << "Deposit successful. New balance: " << balance << endl;
    }

    void withdraw(double amount) {
        if (amount > balance) {
            cout << "Insufficient funds!\nBalance unchanged" << endl;
        } else {
            balance -= amount;
            cout << "Withdrawal successful. New balance: " << balance << endl;
        }
    }

    void checkBalance() const {
        cout << "Current balance: " << balance << endl;
    }

    void performTransaction() {
        int choice;
        double amount;

        do {
            displayMenu();
            cout << "Enter your choice: ";
            cin >> choice;

            switch (choice) {
                case 1:
                    cout << "Enter deposit amount: ";
                    cin >> amount;
                    deposit(amount);
                    break;

                case 2:
                    cout << "Enter withdrawal amount: ";
                    cin >> amount;
                    withdraw(amount);
                    break;

                case 3:
                    checkBalance();
                    break;

                case 4:
                    cout << "Exiting ATM. Thank you!" << endl;
                    break;

                default:
                    cout << "Invalid choice. Please try again." << endl;
            }

        } while (choice != 4);
    }

    void displayMenu() const{
        cout << "\nATM Menu:\n";
        cout << "1. Deposit\n";
        cout << "2. Withdraw\n";
        cout << "3. Check Balance\n";
        cout << "4. Exit\n";
    }
};

class User {
public:
    string cardNumber;
    string cardPassword;
    double initialBalance;

    User(const string& cardNumber, const string& cardPassword, double initialBalance)
            : cardNumber(cardNumber), cardPassword(cardPassword), initialBalance(initialBalance) {}
};

int main() {
    // Create multiple instances of the User class with different data
    vector<User> users = {
            {"1234567890123456", "1234", 1000.0},
            {"9876543210987654", "5678", 2000.0},
            // Add more users as needed
    };

    // Create instances of the ATM class for each user
    for (const auto& user : users) {
        ATM atm(user.cardNumber, user.cardPassword, user.initialBalance);

        if (atm.authenticate()) {
            atm.performTransaction();
        } else {
            cout << "Authentication failed for user " << user.cardNumber << ". Exiting." << endl;
        }
    }
    return 0;
}
