//
// Created by IP3 on 15/12/2023.
//

#ifndef REFERENCE_USER_H
#define REFERENCE_USER_H

#include <string>

class User {
public:
    std::string cardNumber;
    std::string cardPassword;
    double initialBalance;

    User(const std::string& cardNumber, const std::string& cardPassword, double initialBalance);
};
#endif //REFERENCE_USER_H
