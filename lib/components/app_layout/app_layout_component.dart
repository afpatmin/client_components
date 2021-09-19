import 'dart:async';
import 'dart:html' as html;

import 'package:angular/angular.dart';
import 'package:angular/security.dart' as security;
import 'package:angular_components/material_button/material_button.dart';
import 'package:angular_components/material_icon/material_icon.dart';
import 'package:angular_components/material_list/material_list.dart';
import 'package:angular_components/material_list/material_list_item.dart';
import 'package:angular_components/material_tooltip/material_tooltip.dart';
import 'package:angular_router/angular_router.dart';
import 'package:fo_components/components/fo_modal/fo_modal_component.dart';
import 'package:fo_components/pipes/capitalize_pipe.dart';
import 'package:intl/intl.dart';

@Component(
    selector: 'app-layout',
    styleUrls: ['app_layout_component.css'],
    templateUrl: 'app_layout_component.html',
    directives: [
      coreDirectives,
      FoModalComponent,
      MaterialButtonComponent,
      MaterialIconComponent,
      MaterialListComponent,
      MaterialListItemComponent,
      MaterialTooltipDirective,
      routerDirectives,
    ],
    pipes: [CapitalizePipe])
class AppLayoutComponent implements OnDestroy, AfterViewInit {
  @ViewChild('listContent')
  html.Element listContent;

  @ViewChild('list')
  html.Element list;

  bool showScrollIndicator = false;

  bool animating = false;

  final security.DomSanitizationService _domSanitizationService;

  final Router router;

  final StreamController<bool> _onExpandedChangeController = StreamController();

  final int miniWidth = 40;

  FoSidebarItem _activeItem;
  @Input()
  String backgroundColor = '#666';
  @Input()
  String header = 'Menu';

  @Input()
  String paddingTop = '85px';

  @Input()
  bool expanded = false;

  @Input()
  int width = 200;

  @Input()
  List<FoSidebarCategory> categories = <FoSidebarCategory>[];

  @Input()
  security.SafeResourceUrl instructionsUrl;
  @Input()
  bool instructionsModalVisible = false;
  AppLayoutComponent(this.router, this._domSanitizationService) {
    router.onRouteActivated.listen(_onRouteActivated);
  }
  @Output('expandedChange')
  Stream<bool> get onExpandedChangeOutput => _onExpandedChangeController.stream;
  String get pageHeader => _activeItem?.label;

  String get pageIcon => _activeItem?.icon;

  String get sidebarWidth => (expanded) ? '${width}px' : '${miniWidth}px';

  String calcIFrameHeight() =>
      ((html.window.innerWidth * 0.6) * 0.615).round().toString();

  String calcIFrameWidth() => (html.window.innerWidth * 0.6).toString();

  String instructions() => Intl.message('Instruktioner');

  bool isActive(FoSidebarItem item) => item == _activeItem;

  @override
  void ngAfterViewInit() {
    Future.delayed(const Duration(milliseconds: 100)).then((_) {
      showScrollIndicator = listContent.clientHeight > list.clientHeight;
      list.onScroll.first.then((_) {
        showScrollIndicator = false;
      });
    });
  }

  @override
  void ngOnDestroy() {
    _onExpandedChangeController.close();
  }

  void scrollNavToBottom() {
    list.scrollTo(0, list.clientHeight);
  }

  void toggleExpanded() {
    expanded = !expanded;

    animating = true;
    Timer(const Duration(milliseconds: 100), () => animating = false);

    _onExpandedChangeController.add(expanded);
  }

  void _onRouteActivated(RouterState state) {
    _activeItem = null;

    var path = state.path; //.path.replaceAll('/', '').replaceAll('#', '');
    if (path == null || path.isEmpty) {
      path = 'index.html';
    }

    for (final category in categories) {
      _activeItem = category.items
          .firstWhere((i) => path.contains(i.url), orElse: () => null);

      if (_activeItem == null) {
        instructionsUrl = null;
      } else {
        instructionsUrl = _activeItem?.instructionsUrl == null
            ? null
            : _domSanitizationService
                .bypassSecurityTrustResourceUrl(_activeItem.instructionsUrl);
        break;
      }
    }
  }
}

class FoSidebarCategory {
  final List<FoSidebarItem> items;

  String title;
  FoSidebarCategory(this.title, this.items);
}

class FoSidebarItem {
  final String url;

  String label;
  final String icon;
  final String instructionsUrl;
  FoSidebarItem(this.url, this.label, this.icon, [this.instructionsUrl]);
}
