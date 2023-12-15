//
// Created by IP3 on 15/12/2023.
//

#ifndef REFERENCE_ATM_H
#define REFERENCE_ATM_H

#include <iostream>
#include <vector>

class User;

class ATM {
private:
    std::string cardNumber;
    std::string cardPassword;
    double balance;

public:
    ATM(const std::string& cardNumber, const std::string& cardPassword, double initialBalance);

    User authenticate(const std::vector<User>& users) const;

    void deposit(User amount, double d);

    void withdraw(double amount);

    void transferFunds(ATM& recipient, double amount);

    void changePIN(const std::string& newPIN);

    void checkBalance() const;

    void performTransaction(std::vector<User> &users, User user);

    void displayMenu() const;
};

#endif //REFERENCE_ATM_H
