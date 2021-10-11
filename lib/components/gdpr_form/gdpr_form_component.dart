import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:fo_components/components/fo_button/fo_button_component.dart';
import 'package:fo_components/components/fo_check/fo_check_component.dart';
import 'package:fo_components/components/fo_dropdown_select/fo_dropdown_select_component.dart';
import 'package:fo_components/components/fo_modal/fo_modal_component.dart';
import 'package:fo_components/components/fo_text_input/fo_text_input_component.dart';
import 'package:fo_components/components/fo_text_input/fo_textarea_input_component.dart';
import 'package:fo_components/pipes/capitalize_pipe.dart';
import 'package:fo_components/validators/fo_validators.dart';
import 'package:intl/intl.dart';

@Component(
    selector: 'gdpr-form',
    templateUrl: 'gdpr_form_component.html',
    styleUrls: ['gdpr_form_component.css'],
    directives: [
      FoModalComponent,
      formDirectives,
      FoButtonComponent,
      FoDropdownSelectComponent,
      FoTextAreaInputComponent,
      FoTextInputComponent,
      FoCheckComponent,
      NgIf
    ],
    pipes: [CapitalizePipe],
    changeDetection: ChangeDetectionStrategy.OnPush)
class GdprFormComponent implements OnDestroy {
  final ControlGroup form;
  bool termsChecked = false;
  bool sent = false;
  final GdprModel model = GdprModel();
  Map<String, List<FoDropdownOption>> options = {};
  final StreamController<bool> openController = StreamController();
  final StreamController<GdprModel> _submitController = StreamController();
  bool _open = false;

  @Input()
  String? readMoreLink;

  GdprFormComponent()
      : form = ControlGroup({
          'firstname': Control()
            ..validator = Validators.compose(
                [Validators.required, Validators.maxLength(50)]),
          'lastname': Control()
            ..validator = Validators.compose(
                [Validators.required, Validators.maxLength(50)]),
          'phone': Control()
            ..validator = Validators.compose([
              Validators.required,
              FoValidators.phoneNumber,
              Validators.maxLength(15)
            ]),
          'email': Control()
            ..validator = Validators.compose([
              Validators.required,
              FoValidators.email,
              Validators.maxLength(128)
            ]),
          'comments': Control()
            ..validator = Validators.compose([Validators.maxLength(1000)])
        });

  String get msgChangeMyInfo =>
      Intl.message('I wish to change/update my information',
          name: 'msgChangeMyInfo');
  String get msgComments => Intl.message('comments', name: 'msgComments');
  String get msgEmail => Intl.message('email', name: 'msgEmail');

  String get msgEraseMe =>
      Intl.message('I wish to erase all my data', name: 'msgEraseMe');
  String get msgFetchMyInfo =>
      Intl.message('I want to know my personal details',
          name: 'msgFetchMyInfo');
  String get msgFetchMyInfoPortable =>
      Intl.message('I want to access my personal details in a portable data',
          name: 'msgFetchMyInfoPortable');
  String get msgFirstname => Intl.message('firstname', name: 'msgFirstname');
  String get msgGdprFormAccept => Intl.message(
      'I hereby consent that above details are stored while the case is processed',
      name: 'msgGdprFormAccept',
      desc:
          'Label next to checkbox that the user must check in order to submit an issue');
  String get msgGdprFormCompleted => Intl.message(
      '<h1>Thank you!</h1><p>Your inquiry has been now been sent, and we will take necessary actions and reply to you as soon as we can.</p>',
      name: 'msgGdprFormCompleted',
      desc:
          'Displayed to the user after submitting the gdpr form, can be basic html');
  String get msgGdprFormInfo => Intl.message(
      'This form is used for inquiries regarding your rights in accordance with Data Protection Regulation 2016/79.<br /><br />We save the details you provide in accordance with article 17.3.<br /><br />This information is sent to the support contact who registered your details and is logged by the service provider.',
      name: 'msgGdprFormInfo',
      desc: 'Text displayed over the GDPR issue form');
  String get msgIssue => Intl.message('issue', name: 'msgIssue');

  String get msgLastname => Intl.message('lastname', name: 'msgLastname');

  String get msgLimitMyDataProcessing =>
      Intl.message('I wish to limit how my data is being processed',
          name: 'msgLimitMyDataProcessing');

  String get msgOpposeMyDataProcessing =>
      Intl.message('I wish to oppose how my data is being processed',
          name: 'msgOpposeMyDataProcessing');

  String get msgPhone => Intl.message('phone', name: 'msgPhone');

  String get msgReadMore => Intl.message('read more', name: 'msgReadMore');

  String get msgSend => Intl.message('send', name: 'msgSend');

  @Output('submit')
  Stream<GdprModel> get onSubmit => _submitController.stream;

  bool get open => _open;

  @Input()
  set open(bool v) {
    options = {
      '': [
        FoDropdownOption('gdpr_fetch_my_info', msgFetchMyInfo),
        FoDropdownOption('gdpr_fetch_my_info_portable', msgFetchMyInfoPortable),
        FoDropdownOption('gdpr_change_my_info', msgChangeMyInfo),
        FoDropdownOption(
            'gdpr_limit_my_data_processing', msgLimitMyDataProcessing),
        FoDropdownOption(
            'gdpr_oppose_my_data_processing', msgOpposeMyDataProcessing),
        FoDropdownOption('gdpr_erase_me', msgEraseMe)
      ]
    };
    _open = v;
  }

  @Output('openChange')
  Stream<bool> get openChange => openController.stream;

  @override
  void ngOnDestroy() {
    openController.close();
  }

  void submit() {
    _submitController.add(model);
    sent = true;
  }

  void toggleOpen(bool event) {
    open = event;
    openController.add(event);
  }
}

class GdprModel {
  String firstname;
  String lastname;
  String phone;
  String email;
  String comments;
  String selected_issue = 'gdpr_fetch_my_info';

  GdprModel({
    this.firstname = '',
    this.lastname = '',
    this.phone = '',
    this.email = '',
    this.comments = '',
  });

  Map<String, String> toJson() => {
        'firstname': firstname,
        'lastname': lastname,
        'phone': phone,
        'email': email,
        'comments': comments,
        'selected_issue': selected_issue
      };
}
