import 'dart:async';
import 'package:intl/intl.dart';
import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:fo_components/components/fo_button/fo_button_component.dart';
import 'package:fo_components/components/fo_text_input/fo_text_input_component.dart';
import 'package:fo_components/pipes/capitalize_pipe.dart';

@Component(
    selector: 'multi-input',
    templateUrl: 'multi_input_component.html',
    styleUrls: [
      'multi_input_component.css'
    ],
    directives: [
      formDirectives,
      FoButtonComponent,
      FoTextInputComponent,
      NgFor
    ],
    pipes: [
      CapitalizePipe
    ])
class MultiInputComponent implements OnDestroy {
  final StreamController<List<String>> _valueChangeController =
      StreamController<List<String>>();

  final String msgAdd = Intl.message('add', name: 'add');

  void onAdd() {
    value ??= [];
    value.add(model);
    model = '';
    _valueChangeController.add(value);
  }

  void onRemove(String v) {
    value.remove(v);
    _valueChangeController.add(value);
  }

  void onChange(Object event) {
    print(event);
  }

  String model;

  @Input()
  String label;

  @Input()
  bool disabled = false;

  @Input()
  List<String> value = [];

  @Output('valueChange')
  Stream<List<String>> get valueChange => _valueChangeController.stream;

  @override
  void ngOnDestroy() {
    _valueChangeController.close();
  }
}
