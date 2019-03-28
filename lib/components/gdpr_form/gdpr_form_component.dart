import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_components/material_button/material_button.dart';
import 'package:angular_components/material_checkbox/material_checkbox.dart';
import 'package:angular_components/material_input/material_input.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:fo_components/components/fo_modal/fo_modal_component.dart';
import 'package:fo_components/components/fo_select/fo_select_component.dart';
import 'package:fo_components/validators/fo_validators.dart';
import 'package:fo_model/fo_model.dart';
import 'package:intl/intl.dart';

@Component(
    selector: 'gdpr-form',
    templateUrl: 'gdpr_form_component.html',
    styleUrls: [
      'gdpr_form_component.css'
    ],
    directives: [
      FoModalComponent,
      formDirectives,
      FoSelectComponent,
      MaterialButtonComponent,
      MaterialCheckboxComponent,
      materialInputDirectives,
      NgIf
    ],
    pipes: [])
class GdprFormComponent implements OnDestroy {
  final ControlGroup form;
  bool termsChecked = false;
  bool sent = false;
  final GdprModel model = GdprModel();
  final List<FoModel> options;
  final StreamController<bool> openController = StreamController();
  final StreamController<GdprModel> _submitController = StreamController();
  final String msgGdprFormInfo = Intl.message(
      'This form is used for inquiries regarding your rights in accordance with Data Protection Regulation 2016/79.<br /><br />We save the details you provide in accordance with article 17.3.<br /><br />This information is sent to the support contact who registered your details and is logged by the service provider.',
      name: 'gdpr_form_info',
      desc: 'Text displayed over the GDPR issue form');
  final String msgReadMore = Intl.message('read more', name: 'read_more');
  final String msgFirstname = Intl.message('firstname', name: 'firstname');
  final String msgLastname = Intl.message('lastname', name: 'lastname');
  final String msgPhone = Intl.message('phone', name: 'phone');
  final String msgEmail = Intl.message('email', name: 'email');
  final String msgSend = Intl.message('send', name: 'send');
  final String msgGdprFormCompleted = Intl.message(
      '<h1>Thank you!</h1><p>Your inquiry has been now been sent, and we will take necessary actions and reply to you as soon as we can.</p>',
      name: 'gdpr_form_completed_message',
      desc:
          'Displayed to the user after submitting the gdpr form, can be basic html');
  final String msgIssue =
      Intl.plural(1, one: 'issue', other: 'issues', args: [1], name: 'issue');
  final String msgComments = Intl.plural(2,
      one: 'comment', args: [2], other: 'comments', name: 'comment');
  final String gdprFormAccept = Intl.message(
      'I hereby consent that above details are stored while the case is processed',
      name: 'gdpr_form_accept',
      desc:
          'Label next to checkbox that the user must check in order to submit an issue');

  @Input()
  bool open = false;

  @Input()
  String readMoreLink;
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
        }),
        options = [
          FoModel()
            ..id = Intl.message('I want to know my personal details',
                name: 'gdpr_fetch_my_info'),
          FoModel()
            ..id = Intl.message(
                'I want to access my personal details in a portable data',
                name: 'gdpr_fetch_my_info_portable'),
          FoModel()
            ..id = Intl.message('I wish to change/update my information',
                name: 'gdpr_change_my_info'),
          FoModel()
            ..id = Intl.message(
                'I wish to limit how my data is being processed',
                name: 'gdpr_limit_my_data_processing'),
          FoModel()
            ..id = Intl.message(
                'I wish to oppose how my data is being processed',
                name: 'gdpr_oppose_my_data_processing'),
          FoModel()
            ..id = Intl.message('I wish to erase all my data',
                name: 'gdpr_erase_me')
        ];

  @Output('submit')
  Stream<GdprModel> get onSubmit => _submitController.stream;

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
}

class GdprModel {
  String firstname;
  String lastname;
  String phone;
  String email;
  String comments;
  String selected_issue = 'gdpr_fetch_my_info';

  Map<String, String> toJson() => {
        'firstname': firstname,
        'lastname': lastname,
        'phone': phone,
        'email': email,
        'comments': comments,
        'selected_issue': selected_issue
      };
}
