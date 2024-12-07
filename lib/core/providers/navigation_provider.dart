import 'package:flutter_riverpod/flutter_riverpod.dart';

final navigationProvider = StateNotifierProvider<NavigationNotifier, int>((ref) {
  return NavigationNotifier();
});

final bottomNavVisibilityProvider = StateProvider<bool>((ref) => true);

class NavigationNotifier extends StateNotifier<int> {
  NavigationNotifier() : super(0);
  void setIndex(int index) => state = index;
} 