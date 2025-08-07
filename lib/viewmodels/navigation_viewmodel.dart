import 'package:flutter_riverpod/flutter_riverpod.dart';

class NavigationViewModel extends StateNotifier<int> {
  NavigationViewModel() : super(0);

  void setCurrentIndex(int index) {
    state = index;
  }

  int get currentIndex => state;
}

// Provider for navigation state
final navigationViewModelProvider = StateNotifierProvider<NavigationViewModel, int>((ref) {
  return NavigationViewModel();
});
