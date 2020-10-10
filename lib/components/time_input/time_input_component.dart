import 'dart:async';
import 'package:angular/angular.dart';
import 'package:fo_components/components/fo_dropdown_list/fo_dropdown_option.dart';
import 'package:fo_components/components/fo_dropdown_select/fo_dropdown_select_component.dart';
import 'package:fo_components/components/fo_label/fo_label_component.dart';

@Component(
    selector: 'time-input',
    templateUrl: 'time_input_component.html',
    styleUrls: ['time_input_component.css'],
    directives: [FoDropdownSelectComponent, FoLabelComponent])
class TimeInputComponent implements OnDestroy {
  final StreamController<String> _timeController = StreamController<String>();

  final Map<String, List<FoDropdownOption>> hourOptions = {
    '': List.generate(
        24,
        (i) => FoDropdownOption()
          ..id = strTime(i)
          ..label = strTime(i),
        growable: false)
  };

  final Map<String, List<FoDropdownOption>> minuteOptions = {
    '': List.generate(
        60,
        (i) => FoDropdownOption()
          ..id = strTime(i)
          ..label = strTime(i),
        growable: false)
  };

  @Input()
  bool disabled = false;

  @Input()
  String label;

  @Input()
  String time;

  @Output('timeChange')
  Stream<String> get timeChange => _timeController.stream;

  String get selectedHour {
    try {
      return time == null ? '00' : time.substring(0, 2);
    }
    // ignore: avoid_catching_errors
    on RangeError catch (e) {
      print(e);
      return null;
    }
  }

  String get selectedMinute {
    try {
      return time == null ? '00' : time.substring(3, 5);
    }
    // ignore: avoid_catching_errors
    on RangeError catch (e) {
      print(e);
      return null;
    }
  }

  set selectedHour(String value) {
    final hour = value == null ? '00' : value;
    time = '$hour:$selectedMinute';

    _timeController.add(time);
  }

  set selectedMinute(String value) {
    final minute = value == null ? '00' : value;
    time = '$selectedHour:$minute';
    _timeController.add(time);
  }

  TimeInputComponent() {
    hourOptions.values.first[0].info = 'am';
    hourOptions.values.first[13].info = 'pm';
  }

  static String strTime(int time) => time < 10 ? '0$time' : '$time';

  @override
  void ngOnDestroy() {
    _timeController?.close();
  }
}
