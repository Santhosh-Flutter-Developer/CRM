part of 'main_screen.dart';

class DesktopMainScreen extends StatefulWidget {
  final bool isAdmin;
  final String? selectedMenu;
  const DesktopMainScreen({
    super.key,
    required this.isAdmin,
    this.selectedMenu,
  });

  @override
  State<DesktopMainScreen> createState() => _DesktopMainScreenState();
}

class _DesktopMainScreenState extends State<DesktopMainScreen> {
  bool _isSidebarCollapsed = false;
  bool _userToggledSidebar = false;
  bool _wasBelowBreakpoint = false;
  static const double collapseWidth = 1100;

  late Future _future;
  late String _currentUserUid;
  String? _companyLogo;

  final List<Map<String, dynamic>> items = [
    {"icon": Iconsax.message, "label": "Messenger"},
    {"icon": Iconsax.graph, "label": "Leads"},
    {"icon": Iconsax.grid_lock, "label": "Deals"},
    {"icon": Iconsax.menu, "label": "Menu"},
  ];

  @override
  void initState() {
    _future = _init();
    _selectedMenu = widget.selectedMenu ?? 'Dashboard';
    // WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    // WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // @override
  // void didChangeMetrics() {
  //   final width =
  //       WidgetsBinding
  //           .instance
  //           .platformDispatcher
  //           .views
  //           .first
  //           .physicalSize
  //           .width /
  //       WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;

  //   final shouldCollapse = width < collapseWidth;

  //   if (shouldCollapse != _isSidebarCollapsed) {
  //     setState(() {
  //       _isSidebarCollapsed = shouldCollapse;
  //     });
  //   }

  //   debugPrint('Window width: $width | collapsed: $shouldCollapse');
  // }

  Future<void> _init() async {
    try {
      _currentUserUid = await Spdb.getUid() ?? '';
      _companyLogo = await Spdb.getCompanyLogo();
    } catch (e, st) {
      await ErrorService.recordError(e, st);
    }
  }

  String _selectedMenu = 'Dashboard';

  void _onMenuItemSelected(String title) async {
    setState(() {
      _selectedMenu = title;
    });
    RecentActivityService().addActivity(page: _selectedMenu);
  }

  Widget _buildMainContent() {
    switch (_selectedMenu) {
      case 'Dashboard':
        return BlocProvider(
          create: (context) => DashboardBloc(
            dashboard: DashboardService(),
            userId: _currentUserUid,
            isAdmin: widget.isAdmin,
          )..add(LoadDashboardEvent(filter: '')),
          child: Dashboard(isAdmin: widget.isAdmin),
        );
      case 'Admin':
        return const AdminListing();
      case 'Role':
        return const RolesListing();
      case 'Designation':
        return const DesignationListing();
      case 'Department':
        return const DepartmentListing();
      case 'Sub Department':
        return const SubDepartmentListing();
      case 'Employees':
        return const EmployeeListing();
      case 'Lead Category':
        return const LeadCategoryListing();
      case 'Lead Status':
        return const LeadStatusListing();
      case 'Lead Source':
        return const LeadSourceListing();
      case 'Lead Priority':
        return const LeadPriorityListing();
      case 'Deal Status':
        return const DealStatusListing();
      case 'Leads':
        return const LeadsListing();
      case 'Deals':
        return const DealsListing();
      case 'Contact':
        return const ClientsListing(section: ClientSection.contacts);
      case 'Company':
        return const ClientCompanyListing(section: ClientSection.company);
      // case 'Companies':
      //   return const CompaniesListing();
      case 'Projects':
        return const ProjectsListing();
      case 'Tasks':
        return const TasksListing();
      case 'Tickets':
        return const TicketsListing();
      case 'Chats':
        return ChatListing(currentUserUid: _currentUserUid);
      case 'Calendar':
        return const CalendarEventScreen();
      case 'Developer Area':
        return const Developer(showAppbar: false);
      case 'Settings':
        return Settings(showAppbar: false);
      case 'Login Logs':
        return const LoginLogsListing(showAppbar: false);
      case 'Activity Logs':
        return const ActivityLogsListing(showAppbar: false);
      case 'Downloads':
        return BlocProvider(
          create: (context) => DownloadHistoryBloc(),
          child: const DownloadHistory(showAppbar: false),
        );

      case 'Feed':
        return BlocProvider(
          create: (context) => FeedBloc(),
          child: const FeedListing(),
        );

      default:
        return Center(
          child: Text(
            "Content for $_selectedMenu",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const WaitingLoading();
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Sync Error: ${snapshot.error}',
                style: const TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }
          return LayoutBuilder(
            builder: (context, constraints) {
              final isBelowBreakpoint = constraints.maxWidth < collapseWidth;

              // final shouldCollapse = constraints.maxWidth < collapseWidth;

              // /// AUTO collapse ONLY if user has NOT manually toggled
              // if (!_userToggledSidebar &&
              //     _isSidebarCollapsed != shouldCollapse) {
              //   _isSidebarCollapsed = shouldCollapse;
              // }

              // /// RESET manual override when window grows
              // if (_userToggledSidebar &&
              //     constraints.maxWidth >= collapseWidth) {
              //   _userToggledSidebar = false;
              //   _isSidebarCollapsed = false;
              // }

              /// AUTO collapse ONLY when breakpoint is crossed
              if (!_userToggledSidebar &&
                  isBelowBreakpoint != _wasBelowBreakpoint) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted) {
                    setState(() {
                      _isSidebarCollapsed = isBelowBreakpoint;
                    });
                  }
                });
              }

              /// Reset manual override ONLY when window expands back
              if (_userToggledSidebar &&
                  !isBelowBreakpoint &&
                  _wasBelowBreakpoint) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted) {
                    setState(() {
                      _userToggledSidebar = false;
                      _isSidebarCollapsed = false;
                    });
                  }
                });
              }

              /// update last width state
              _wasBelowBreakpoint = isBelowBreakpoint;

              return Row(
                children: [
                  DesktopSidebar(
                    isCollapsed: _isSidebarCollapsed,
                    onCollapseChanged: (v) {
                      setState(() {
                        _isSidebarCollapsed = v;
                        _userToggledSidebar = true;
                      });
                    },
                    selectedMenu: _selectedMenu,
                    onMenuSelected: _onMenuItemSelected,
                    isAdmin: widget.isAdmin,
                    companyLogo: _companyLogo,
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Header(selectedMenu: _selectedMenu),
                        Expanded(
                          // No Scrollbar here: this wraps whichever screen
                          // `_buildMainContent()` returns, and each of those
                          // screens (Dashboard, the listing pages, etc.)
                          // already owns its own scroll view + ScrollController
                          // and renders its own working, draggable Scrollbar.
                          // A Scrollbar here had no controller to attach to
                          // (it can't see a descendant screen's own
                          // ScrollController through that screen's Scaffold),
                          // so it rendered a thumb that looked interactive but
                          // couldn't actually be dragged.
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: _buildMainContent(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}