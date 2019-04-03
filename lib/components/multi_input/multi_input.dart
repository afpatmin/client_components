import 'dart:async';

import 'package:angular/angular.dart';

@Component(
  selector: 'multi-input',
  templateUrl: 'multi_input.html',
)
class MultiInputComponent implements OnDestroy {
  final StreamController<List<String>> _valueChangeController =
      StreamController<List<String>>();

  @Input()
  String label;

  @Input()
  List<String> value = [];

  @Output('valueChange')
  Stream<List<String>> get valueChange => _valueChangeController.stream;

  @override
  void ngOnDestroy() {
    _valueChangeController.close();
  }
}
