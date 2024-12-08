// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../providers/navigation_provider.dart';

// class AppBottomNavBar extends ConsumerWidget {
//   const AppBottomNavBar({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final currentIndex = ref.watch(navigationProvider);
//     final isVisible = ref.watch(bottomNavVisibilityProvider);

//     if (!isVisible) return const SizedBox.shrink();

//     return BottomNavigationBar(
//       currentIndex: currentIndex,
//       onTap: (index) => ref.read(navigationProvider.notifier).setIndex(index),
//       selectedItemColor: const Color(0xFF1B5E20),
//       unselectedItemColor: Colors.grey,
//       items: const [
//         BottomNavigationBarItem(
//           icon: Icon(Icons.dashboard),
//           label: 'Dashboard',
//         ),
//         BottomNavigationBarItem(
//           icon: Icon(Icons.analytics),
//           label: 'Analytics',
//         ),
//         BottomNavigationBarItem(
//           icon: Icon(Icons.notifications),
//           label: 'Notifications',
//         ),
//       ],
//     );
//   }
// }
