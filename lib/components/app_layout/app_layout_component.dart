import 'dart:async';
import 'dart:html' as html;

import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';
import 'package:fo_components/components/fo_icon/fo_icon_component.dart';
import 'package:fo_components/pipes/capitalize_pipe.dart';

@Component(
    selector: 'app-layout',
    styleUrls: ['app_layout_component.css'],
    templateUrl: 'app_layout_component.html',
    directives: [
      coreDirectives,
      routerDirectives,
      FoIconComponent,
    ],
    pipes: [CapitalizePipe])
class AppLayoutComponent implements OnDestroy, AfterViewInit {
  @ViewChild('listContent')
  html.Element? listContent;

  @ViewChild('list')
  html.Element? list;

  bool showScrollIndicator = false;

  bool animating = false;

  final Router router;

  final StreamController<bool> _onExpandedChangeController = StreamController();

  final int miniWidth = 40;

  FoSidebarItem? _activeItem;

  @Input()
  String backgroundColor = '#666';

  @Input()
  String header = 'Menu';

  @Input()
  String paddingTop = '0px';

  @Input()
  bool expanded = false;

  @Input()
  int width = 200;

  @Input()
  List<FoSidebarCategory> categories = <FoSidebarCategory>[];

  AppLayoutComponent(this.router) {
    router.onRouteActivated.listen(_onRouteActivated);
  }

  @Output('expandedChange')
  Stream<bool> get onExpandedChangeOutput => _onExpandedChangeController.stream;

  String? get pageHeader => _activeItem?.label;

  String? get pageIcon => _activeItem?.icon;

  String get sidebarWidth => (expanded) ? '${width}px' : '${miniWidth}px';

  String calcIFrameHeight() =>
      ((html.window.innerWidth! * 0.6) * 0.615).round().toString();

  String calcIFrameWidth() => (html.window.innerWidth! * 0.6).toString();

  bool isActive(FoSidebarItem item) => item == _activeItem;

  @override
  void ngAfterViewInit() {
    Future.delayed(const Duration(milliseconds: 100)).then((_) {
      showScrollIndicator = listContent!.clientHeight > list!.clientHeight;
      list!.onScroll.first.then((_) {
        showScrollIndicator = false;
      });
    });
  }

  @override
  void ngOnDestroy() {
    _onExpandedChangeController.close();
  }

  void scrollNavToBottom() {
    list!.scrollTo(0, list!.clientHeight);
  }

  void toggleExpanded() {
    expanded = !expanded;

    animating = true;
    Timer(const Duration(milliseconds: 100), () => animating = false);

    _onExpandedChangeController.add(expanded);
  }

  void _onRouteActivated(RouterState state) {
    _activeItem = null;

    var path = state.path;
    if (path.isEmpty) {
      path = 'index.html';
    }

    for (final category in categories) {
      _activeItem = category.items.firstWhere((i) => path.contains(i.url),
          orElse: () => category.items.first);
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
  FoSidebarItem(this.url, this.label, this.icon);
}
