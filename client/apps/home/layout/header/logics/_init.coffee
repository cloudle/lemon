logics.homeHeader = {}

logics.homeHeader.loginErrors = [
  matchFailed        = { reason: "Match failed",        message: 'messages.matchFailed',       isPasswordError: false}
  userNotFound       = { reason: "User not found",      message: 'messages.userNotFound',  isPasswordError: false}
  incorrectPassword  = { reason: "Incorrect password",  message: 'messages.incorrectPassword',  isPasswordError: true }
]