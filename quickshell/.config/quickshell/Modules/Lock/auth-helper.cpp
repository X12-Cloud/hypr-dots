#include <iostream>
#include <string>
#include <fstream>
#include <unistd.h>
#include <sys/types.h>
#include <pwd.h>
#include <shadow.h>
#include <crypt.h>

// Debug log helper since stderr won't show up in quickshell's default view
void log_debug(const std::string& msg) {
    std::ofstream log("/tmp/qs-auth-debug.log", std::ios::app);
    if (log.is_open()) {
        log << msg << "\n";
    }
}

int main() {
    std::string input_password;
    if (!std::getline(std::cin, input_password)) {
        log_debug("Failed to read from stdin.");
        return 1;
    }

    // Strip any unexpected trailing carriage returns or newlines
    if (!input_password.empty() && input_password.back() == '\r') {
        input_password.pop_back();
    }

    uid_t uid = getuid();
    struct passwd* pw = getpwuid(uid);
    if (!pw) {
        log_debug("Failed to resolve user uid: " + std::to_string(uid));
        return 1;
    }
    std::string username = pw->pw_name;
    log_debug("Attempting auth for user: " + username);

    // Read the shadow file record
    struct spwd* shadow_entry = getspnam(username.c_str());
    if (!shadow_entry) {
        log_debug("Error: Cannot access shadow entries. Missing setuid root permission? Current UID: " + std::to_string(geteuid()));
        return 1;
    }

    // Hash and verify
    char* hashed_input = crypt(input_password.c_str(), shadow_entry->sp_pwdp);
    if (!hashed_input) {
        log_debug("Crypt engine failed to compute hash.");
        return 1;
    }

    if (std::string(hashed_input) == shadow_entry->sp_pwdp) {
        log_debug("Authentication successful.");
        return 0;
    }

    log_debug("Password mismatch.");
    return 1;
}
