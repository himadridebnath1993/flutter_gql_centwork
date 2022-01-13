import 'package:flutter/material.dart';

import 'model.dart';

List<ActionMenu> get menuList => const [
      const ActionMenu(id: 0, text: "Filter", icon: Icons.filter_alt_outlined),
      const ActionMenu(id: 1, text: "Reload", icon: Icons.cached),
      const ActionMenu(
          id: 2, text: "Account", icon: Icons.account_circle_outlined),
      const ActionMenu(id: 3, text: "alarm", icon: Icons.access_alarm),
      const ActionMenu(id: 4, text: "Accessibility", icon: Icons.accessibility),
      const ActionMenu(id: 5, text: "Admin", icon: Icons.admin_panel_settings),
      const ActionMenu(
          id: 6, text: "Airplanemode", icon: Icons.airplanemode_on),
      const ActionMenu(id: 7, text: "Microwave", asset: 'ic_rupee.png'),
      const ActionMenu(id: 8, text: "Vehicle", asset: 'ic_vehicles.png'),
      const ActionMenu(id: 9, text: "Driver", asset: 'ic_driver.png')
    ];

List<ActionMenu> get tabmenuList => const [
      const ActionMenu(id: 0, text: "Filter", icon: Icons.filter_alt_outlined),
      const ActionMenu(id: 1, text: "Reload", icon: Icons.cached),
      const ActionMenu(
          id: 2, text: "Account", icon: Icons.account_circle_outlined),
      const ActionMenu(id: 9, text: "Driver", asset: 'ic_driver.png'),
      // const ActionMenu(id: 4, text: "Accessibility", icon: Icons.accessibility),
    ];
