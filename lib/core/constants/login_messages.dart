import 'package:flutter/material.dart';

class LoginMessages with ChangeNotifier {
  LoginMessages({
    this.userHint,
    this.passwordHint = defaultPasswordHint,
    this.confirmPasswordHint = defaultConfirmPasswordHint,
    this.forgotPasswordButton = defaultForgotPasswordButton,
    this.loginButton = defaultLoginButton,
    this.signupButton = defaultSignupButton,
    this.recoverPasswordButton = defaultRecoverPasswordButton,
    this.recoverPasswordIntro = defaultRecoverPasswordIntro,
    this.recoverPasswordDescription = defaultRecoverPasswordDescription,
    this.goBackButton = defaultGoBackButton,
    this.confirmPasswordError = defaultConfirmPasswordError,
    this.recoverPasswordSuccess = defaultRecoverPasswordSuccess,
    this.flushbarTitleError = defaultFlushbarTitleError,
    this.flushbarTitleSuccess = defaultFlushbarTitleSuccess,
    this.signUpSuccess = defaultSignUpSuccess,
    this.providersTitleFirst = defaultProvidersTitleFirst,
    this.providersTitleSecond = defaultProvidersTitleSecond,
    this.additionalSignUpSubmitButton = defaultAdditionalSignUpSubmitButton,
    this.additionalSignUpFormDescription = defaultAdditionalSignUpFormDescription,
    this.confirmSignupIntro = defaultConfirmSignupIntro,
    this.confirmationCodeHint = defaultConfirmationCodeHint,
    this.confirmationCodeValidationError = defaultConfirmationCodeValidationError,
    this.resendCodeButton = defaultResendCodeButton,
    this.resendCodeSuccess = defaultResendCodeSuccess,
    this.confirmSignupButton = defaultConfirmSignupButton,
    this.confirmSignupSuccess = defaultConfirmSignupSuccess,
    this.confirmRecoverIntro = defaultConfirmRecoverIntro,
    this.recoveryCodeHint = defaultRecoveryCodeHint,
    this.recoveryCodeValidationError = defaultRecoveryCodeValidationError,
    this.setPasswordButton = defaultSetPasswordButton,
    this.confirmRecoverSuccess = defaultConfirmRecoverSuccess,
    this.recoverCodePasswordDescription = defaultRecoverCodePasswordDescription,
  });

  static const defaultPasswordHint = 'Password';
  static const defaultConfirmPasswordHint = 'Confirm Password';
  static const defaultForgotPasswordButton = 'Forgot Password?';
  static const defaultLoginButton = 'LOGIN';
  static const defaultSignupButton = 'SIGNUP';
  static const defaultRecoverPasswordButton = 'RECOVER';
  static const defaultRecoverPasswordIntro = 'Reset your password here';
  static const defaultRecoverPasswordDescription = 'We will send your plain-text password to this email account.';
  static const defaultRecoverCodePasswordDescription = 'We will send a password recovery code to your email.';
  static const defaultGoBackButton = 'BACK';
  static const defaultConfirmPasswordError = 'Password do not match!';
  static const defaultRecoverPasswordSuccess = 'An email has been sent';
  static const defaultFlushbarTitleSuccess = 'Success';
  static const defaultFlushbarTitleError = 'Error';
  static const defaultSignUpSuccess = 'An activation link has been sent';
  static const defaultProvidersTitleFirst = 'or login with';
  static const defaultProvidersTitleSecond = 'or';
  static const defaultAdditionalSignUpSubmitButton = 'SUBMIT';
  static const defaultAdditionalSignUpFormDescription ='Please fill in this form to complete the signup';
  static const defaultConfirmRecoverIntro = 'The recovery code to set a new password was sent to your email.';
  static const defaultRecoveryCodeHint = 'Recovery Code';
  static const defaultRecoveryCodeValidationError = 'Recovery code is empty';
  static const defaultSetPasswordButton = 'SET PASSWORD';
  static const defaultConfirmRecoverSuccess = 'Password recovered.';
  static const defaultConfirmSignupIntro = 'A confirmation code was sent to your email. ' 'Please enter the code to confirm your account.';
  static const defaultConfirmationCodeHint = 'Confirmation Code';
  static const defaultConfirmationCodeValidationError = 'Confirmation code is empty';
  static const defaultResendCodeButton = 'Resend Code';
  static const defaultResendCodeSuccess = 'A new email has been sent.';
  static const defaultConfirmSignupButton = 'CONFIRM';
  static const defaultConfirmSignupSuccess = 'Account confirmed.';

  /// Hint text of the userHint [TextField]
  /// Default will be selected based on userType
  final String? userHint; 
  final String additionalSignUpSubmitButton; /// Additional signup form button's label 
  final String additionalSignUpFormDescription; /// Description in the additional signup form  
  final String passwordHint;/// Hint text of the password [TextField]  
  final String confirmPasswordHint; /// Hint text of the confirm password [TextField] 
  final String forgotPasswordButton; /// Forgot password button's label 
  final String loginButton; /// Login button's label 
  final String signupButton; /// Signup button's label 
  final String recoverPasswordButton; /// Recover password button's label 
  final String recoverPasswordIntro; /// Intro in password recovery form 
  final String recoverPasswordDescription; /// Description in password recovery form, shown when the onConfirmRecover callback is not provided 
  final String goBackButton; /// Go back button's label. Go back button is used to go back to to login/signup form from the recover password form 
  final String confirmPasswordError; /// The error message to show when the confirm password not match with the original password 
  final String recoverPasswordSuccess; /// The success message to show after submitting recover password 
  final String flushbarTitleError; /// Title on top of Flushbar on errors 
  final String flushbarTitleSuccess; /// Title on top of Flushbar on successes 
  final String signUpSuccess; /// The success message to show after signing up 
  final String providersTitleFirst; /// The string shown above the Providers buttons 
  final String providersTitleSecond; /// The string shown above the Providers icons 
  final String confirmRecoverIntro; /// The intro text for the confirm recover password card 
  final String recoveryCodeHint; /// Hint text of the password recovery code [TextField] 
  final String recoveryCodeValidationError; /// The validation error message  to show for an empty recovery code 
  final String setPasswordButton; /// Set password button's label for password recovery confirmation 
  final String confirmRecoverSuccess; /// The success message to show after confirming recovered password 
  final String confirmSignupIntro; /// The intro text for the confirm signup card 
  final String confirmationCodeHint; /// Hint text of the confirmation code for confirming signup 
  final String confirmationCodeValidationError; /// The validation error message to show for an empty confirmation code 
  final String resendCodeButton; /// Resend code button's label 
  final String resendCodeSuccess; /// The success message to show after resending confirmation code 
  final String confirmSignupButton; /// Confirm signup button's label 
  final String confirmSignupSuccess; /// The success message to show after confirming signup
  final String recoverCodePasswordDescription; /// Description in password recovery form, shown when the onConfirmRecover callback is provided
}