import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/order_model.dart';

class StaffOrdersViewModel extends StateNotifier<StaffOrdersState> {
  StaffOrdersViewModel() : super(StaffOrdersState()) {
    _loadAvailabilityFromStorage();
  }

  static const String _availabilityKey = 'staff_availability_status';

  // Load availability status from SharedPreferences
  Future<void> _loadAvailabilityFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isAvailable = prefs.getBool(_availabilityKey) ?? false;
      state = state.copyWith(isAvailable: isAvailable);
      print('📱 Loaded availability from storage: $isAvailable');
    } catch (e) {
      print('❌ Error loading availability from storage: $e');
    }
  }

  // Save availability status to SharedPreferences
  Future<void> _saveAvailabilityToStorage(bool isAvailable) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_availabilityKey, isAvailable);
      print('💾 Saved availability to storage: $isAvailable');
    } catch (e) {
      print('❌ Error saving availability to storage: $e');
    }
  }

  void setSelectedCategory(OrderCategory? category) {
    state = state.copyWith(selectedCategory: category);
  }

  Future<void> setAvailability(bool isAvailable) async {
    state = state.copyWith(isAvailable: isAvailable);
    await _saveAvailabilityToStorage(isAvailable);
  }

  void setTabController(int index) {
    state = state.copyWith(currentTabIndex: index);
  }

  // Toggle availability and save to storage
  Future<void> toggleAvailability() async {
    final newAvailability = !state.isAvailable;
    await setAvailability(newAvailability);
  }
}

class StaffOrdersState {
  final OrderCategory? selectedCategory;
  final bool isAvailable;
  final int currentTabIndex;

  StaffOrdersState({
    this.selectedCategory,
    this.isAvailable = false,
    this.currentTabIndex = 0,
  });

  StaffOrdersState copyWith({
    OrderCategory? selectedCategory,
    bool? isAvailable,
    int? currentTabIndex,
  }) {
    return StaffOrdersState(
      selectedCategory: selectedCategory ?? this.selectedCategory,
      isAvailable: isAvailable ?? this.isAvailable,
      currentTabIndex: currentTabIndex ?? this.currentTabIndex,
    );
  }
}

// Provider for staff orders state
final staffOrdersViewModelProvider = StateNotifierProvider<StaffOrdersViewModel, StaffOrdersState>((ref) {
  return StaffOrdersViewModel();
});
