import 'dart:async';

import 'package:angular/angular.dart';
import 'package:fo_components/components/fo_text_input/fo_text_input_component.dart';

@Component(
    selector: 'multi-input',
    templateUrl: 'multi_input_component.html',
    directives: [FoTextInputComponent])
class MultiInputComponent implements OnDestroy {
  final StreamController<List<String>> _valueChangeController =
      StreamController<List<String>>();

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
