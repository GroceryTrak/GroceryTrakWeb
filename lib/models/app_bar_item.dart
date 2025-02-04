class AppBarItem {
  String name;
  String path;

  AppBarItem({
    required this.name,
    required this.path
  });

  static List<AppBarItem> getMenuItems() 
  {
    List<AppBarItem> menu = [];

    menu.add(AppBarItem(name: 'scan', path: ''));
    menu.add(AppBarItem(name: 'profile', path: ''));
    menu.add(AppBarItem(name: 'log out', path: ''));

    return menu;
  }
}