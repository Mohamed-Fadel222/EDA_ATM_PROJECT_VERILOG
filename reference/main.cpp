#include <iostream>
#include <vector>
#include "User.h"
#include "ATM.h"

using namespace std;


int main() {
    vector<User> users = {
            {"1234567890123456", "1234", 1000.0},
            {"9876543210987654", "5678", 2000.0},
            {"0246823423203482", "2770", 8000.0},
            // Add more users as needed
    };

    for (const auto& user : users) {
        ATM atm(user.cardNumber, user.cardPassword, user.initialBalance);

        // Get the authenticated user from authenticate
        User authenticatedUser = atm.authenticate(users);

        if (authenticatedUser.cardNumber != "") {
            cout << "Authenticated as user " << authenticatedUser.cardNumber << endl;
            atm.performTransaction(users, authenticatedUser);
        } else {
            cout << "Authentication failed for user " << user.cardNumber << ". Exiting." << endl;
        }
    }

    return 0;
}
