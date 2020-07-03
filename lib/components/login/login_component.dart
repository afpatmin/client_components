import 'dart:async';
import 'dart:html' as html;

import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:fo_components/components/fo_button/fo_button_component.dart';
import 'package:fo_components/components/fo_modal/fo_modal_component.dart';
import 'package:fo_components/components/fo_text_input/fo_text_input_component.dart';
import 'package:fo_components/pipes/capitalize_pipe.dart';
import 'package:intl/intl.dart';

@Component(
    selector: 'login',
    styleUrls: ['login_component.css'],
    templateUrl: 'login_component.html',
    directives: [
      FoButtonComponent,
      FoModalComponent,
      formDirectives,
      FoTextInputComponent,
      coreDirectives
    ],
    pipes: [CapitalizePipe])
class LoginComponent implements OnDestroy {
  String token = '';
  bool visible = true;
  String inputType = 'password';
  String passwordButtonIcon = 'visibility';

  final StreamController<LoginEvent> _onLoginController = StreamController();

  final StreamController<String> _onRecoverPasswordController =
      StreamController();

  final StreamController<UpdatePasswordEvent> _onUpdatePasswordController =
      StreamController();

  final StreamController<String> onStateChangeController = StreamController();

  final Map<String, String> stateLabels;

  @Input()
  String username;

  @Input()
  String password;

  @Input()
  String errorMessage;

  @Input()
  bool showForgotPassword = true;

  @Input()
  String label;

  String state = 'login';

  @Input()
  String titleImageUrl;

  @Input()
  String altUrl;

  @Input()
  String altUrlTitle;

  @Input()
  bool loading = false;

  final String msgUsername = Intl.message('username', name: 'username');

  final String msgPassword = Intl.message('password', name: 'password');
  final String msgSend = Intl.message('send', name: 'send');
  final String msgSave = Intl.message('save', name: 'save');
  final String msgBack = Intl.message('back', name: 'back');
  final String msgLogin = Intl.message('login', name: 'login');
  final String msgNewPassword =
      Intl.message('new password', name: 'new_password');
  final String msgToken = Intl.message('token', name: 'token');
  final String msgForgotPassword =
      Intl.message('forgot password', name: 'forgot_password');
  final String msgForgotPasswordDescription = Intl.message(
      'Enter your username and press send to begin resetting your password.',
      name: 'forgot_password_description',
      desc:
          'Direction on steps to take if the user wishes to restore his password.');
  final String msgResetPasswordDescription = Intl.message(
      'We have sent an email with a reset key to you. Paste it below to update your password.',
      name: 'reset_password_description',
      desc: 'Displayed to the user after having requested a new password.');
  LoginComponent()
      : stateLabels = {
          'forgot_password':
              Intl.message('forgot password', name: 'forgot_password'),
          'login': Intl.message('login', name: 'login'),
          'reset_password':
              Intl.message('reset password', name: 'reset_password'),
        } {
    //setState('login');
  }
  @Output('login')
  Stream<LoginEvent> get onLoginOutput => _onLoginController.stream;

  @Output('recoverPassword')
  Stream<String> get onRecoverPasswordOutput =>
      _onRecoverPasswordController.stream;

  @Output('stateChange')
  Stream<String> get onStateChangeOutput => onStateChangeController.stream;

  @Output('updatePassword')
  Stream<UpdatePasswordEvent> get onUpdatePasswordOutput =>
      _onUpdatePasswordController.stream;

  @override
  void ngOnDestroy() {
    _onLoginController.close();
    _onRecoverPasswordController.close();
    _onUpdatePasswordController.close();
    onStateChangeController.close();
  }

  void onLogin() {
    _onLoginController.add(LoginEvent()
      ..username = username
      ..password = password);
  }

  void onLoginKeyDown(html.KeyboardEvent e) {
    if (e.keyCode == html.KeyCode.ENTER ||
        e.keyCode == html.KeyCode.MAC_ENTER) {
      e.preventDefault();
      if (username != null &&
          username.isNotEmpty &&
          password != null &&
          password.isNotEmpty) {
        onLogin();
      }
    }
  }

  void onRecoverPassword() {
    _onRecoverPasswordController.add(username);
  }

  void onRecoverPasswordKeyUp(html.KeyboardEvent e) {
    if (e.keyCode == html.KeyCode.ENTER ||
        e.keyCode == html.KeyCode.MAC_ENTER) {
      onRecoverPassword();
    }
  }

  void onUpdatePassword() {
    _onUpdatePasswordController.add(UpdatePasswordEvent()
      ..username = username
      ..password = password
      ..token = token);
    setState('login');
  }

  void setState(String newState) {
    state = newState;
    errorMessage = null;
    onStateChangeController.add(state);
  }

  void toggleInputType() {
    if (inputType == 'password') {
      inputType = 'text';
      passwordButtonIcon = 'visibility_off';
    } else {
      inputType = 'password';
      passwordButtonIcon = 'visibility';
    }
  }
}

class LoginEvent {
  String username;
  String password;
}

class UpdatePasswordEvent {
  String username;
  String password;
  String token;
}
