import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/availability_service.dart';

class AvailabilityViewModel extends StateNotifier<bool> {
  final AvailabilityService _availabilityService;

  AvailabilityViewModel(this._availabilityService) : super(false) {
    _loadAvailability();
  }

  // Load current availability status
  Future<void> _loadAvailability() async {
    try {
      final isAvailable = await _availabilityService.getAvailability();
      state = isAvailable;
    } catch (e) {
      // Keep default state (false) if loading fails
      print('Failed to load availability: $e');
    }
  }

  // Toggle availability
  Future<void> toggleAvailability() async {
    try {
      final newState = !state;
      await _availabilityService.toggleAvailability();
      state = newState;
    } catch (e) {
      print('Failed to toggle availability: $e');
      // Don't change state if API call fails
    }
  }

  // Get current availability status
  bool get isAvailable => state;
}

// Providers
final availabilityServiceProvider = Provider<AvailabilityService>((ref) {
  return AvailabilityService();
});

final availabilityViewModelProvider = StateNotifierProvider<AvailabilityViewModel, bool>((ref) {
  final availabilityService = ref.read(availabilityServiceProvider);
  return AvailabilityViewModel(availabilityService);
});



