import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/order_model.dart';

class OrderViewModel extends StateNotifier<List<Order>> {
  OrderViewModel() : super([]);

  // Demo data for testing
  void loadDemoData() {
    final demoOrders = [
      Order(
        id: 'ORD001',
        patientName: 'Ahmed Al Mansouri',
        patientPhone: '+971 50 123 4567',
        patientAddress: 'Dubai Marina, Dubai',
        patientAge: 35,
        patientGender: 'Male',
        symptoms: 'Fever, headache, and body aches for the past 2 days',
        category: OrderCategory.consultation,
        status: OrderStatus.pending,
        orderTime: DateTime.now().subtract(const Duration(hours: 1)),
        amount: 150.0,
      ),
      Order(
        id: 'ORD002',
        patientName: 'Fatima Al Zahra',
        patientPhone: '+971 55 987 6543',
        patientAddress: 'Palm Jumeirah, Dubai',
        patientAge: 28,
        patientGender: 'Female',
        symptoms: 'Severe chest pain and shortness of breath',
        category: OrderCategory.emergency,
        status: OrderStatus.accepted,
        orderTime: DateTime.now().subtract(const Duration(hours: 2)),
        acceptedTime: DateTime.now().subtract(const Duration(minutes: 30)),
        amount: 300.0,
      ),
      Order(
        id: 'ORD003',
        patientName: 'Omar Al Rashid',
        patientPhone: '+971 52 456 7890',
        patientAddress: 'Downtown Dubai',
        patientAge: 45,
        patientGender: 'Male',
        symptoms: 'Follow-up consultation for diabetes management',
        category: OrderCategory.followUp,
        status: OrderStatus.inProgress,
        orderTime: DateTime.now().subtract(const Duration(hours: 3)),
        acceptedTime: DateTime.now().subtract(const Duration(hours: 1)),
        amount: 200.0,
      ),
      Order(
        id: 'ORD004',
        patientName: 'Aisha Al Qasimi',
        patientPhone: '+971 54 321 0987',
        patientAddress: 'Sheikh Zayed Road, Dubai',
        patientAge: 22,
        patientGender: 'Female',
        symptoms: 'Regular health checkup and vaccination',
        category: OrderCategory.routine,
        status: OrderStatus.completed,
        orderTime: DateTime.now().subtract(const Duration(hours: 4)),
        acceptedTime: DateTime.now().subtract(const Duration(hours: 3)),
        completedTime: DateTime.now().subtract(const Duration(hours: 1)),
        amount: 120.0,
      ),
      Order(
        id: 'ORD005',
        patientName: 'Khalid Al Falasi',
        patientPhone: '+971 56 789 0123',
        patientAddress: 'Jumeirah Beach Residence',
        patientAge: 50,
        patientGender: 'Male',
        symptoms: 'Cardiology consultation for heart condition',
        category: OrderCategory.specialist,
        status: OrderStatus.pending,
        orderTime: DateTime.now().subtract(const Duration(hours: 5)),
        amount: 400.0,
      ),
    ];
    state = demoOrders;
  }

  // Get today's orders
  List<Order> get todayOrders {
    final today = DateTime.now();
    return state.where((order) {
      return order.orderTime.year == today.year &&
             order.orderTime.month == today.month &&
             order.orderTime.day == today.day;
    }).toList();
  }

  // Get order history (previous days)
  List<Order> get orderHistory {
    final today = DateTime.now();
    return state.where((order) {
      return order.orderTime.year < today.year ||
             order.orderTime.month < today.month ||
             order.orderTime.day < today.day;
    }).toList();
  }

  // Filter orders by category
  List<Order> filterByCategory(List<Order> orders, OrderCategory category) {
    return orders.where((order) => order.category == category).toList();
  }

  // Filter orders by status
  List<Order> filterByStatus(List<Order> orders, OrderStatus status) {
    return orders.where((order) => order.status == status).toList();
  }

  // Accept an order
  void acceptOrder(String orderId) {
    state = state.map((order) {
      if (order.id == orderId) {
        return Order(
          id: order.id,
          patientName: order.patientName,
          patientPhone: order.patientPhone,
          patientAddress: order.patientAddress,
          patientAge: order.patientAge,
          patientGender: order.patientGender,
          symptoms: order.symptoms,
          category: order.category,
          status: OrderStatus.accepted,
          orderTime: order.orderTime,
          acceptedTime: DateTime.now(),
          completedTime: order.completedTime,
          notes: order.notes,
          amount: order.amount,
        );
      }
      return order;
    }).toList();
  }

  // Start order (mark as in progress)
  void startOrder(String orderId) {
    state = state.map((order) {
      if (order.id == orderId) {
        return Order(
          id: order.id,
          patientName: order.patientName,
          patientPhone: order.patientPhone,
          patientAddress: order.patientAddress,
          patientAge: order.patientAge,
          patientGender: order.patientGender,
          symptoms: order.symptoms,
          category: order.category,
          status: OrderStatus.inProgress,
          orderTime: order.orderTime,
          acceptedTime: order.acceptedTime,
          completedTime: order.completedTime,
          notes: order.notes,
          amount: order.amount,
        );
      }
      return order;
    }).toList();
  }

  // Complete an order
  void completeOrder(String orderId) {
    state = state.map((order) {
      if (order.id == orderId) {
        return Order(
          id: order.id,
          patientName: order.patientName,
          patientPhone: order.patientPhone,
          patientAddress: order.patientAddress,
          patientAge: order.patientAge,
          patientGender: order.patientGender,
          symptoms: order.symptoms,
          category: order.category,
          status: OrderStatus.completed,
          orderTime: order.orderTime,
          acceptedTime: order.acceptedTime,
          completedTime: DateTime.now(),
          notes: order.notes,
          amount: order.amount,
        );
      }
      return order;
    }).toList();
  }

  // Cancel an order
  void cancelOrder(String orderId) {
    state = state.map((order) {
      if (order.id == orderId) {
        return Order(
          id: order.id,
          patientName: order.patientName,
          patientPhone: order.patientPhone,
          patientAddress: order.patientAddress,
          patientAge: order.patientAge,
          patientGender: order.patientGender,
          symptoms: order.symptoms,
          category: order.category,
          status: OrderStatus.cancelled,
          orderTime: order.orderTime,
          acceptedTime: order.acceptedTime,
          completedTime: order.completedTime,
          notes: order.notes,
          amount: order.amount,
        );
      }
      return order;
    }).toList();
  }
}

// Providers
final orderViewModelProvider = StateNotifierProvider<OrderViewModel, List<Order>>((ref) {
  final viewModel = OrderViewModel();
  viewModel.loadDemoData();
  return viewModel;
});

final todayOrdersProvider = Provider<List<Order>>((ref) {
  final orders = ref.watch(orderViewModelProvider);
  final viewModel = ref.read(orderViewModelProvider.notifier);
  return viewModel.todayOrders;
});

final orderHistoryProvider = Provider<List<Order>>((ref) {
  final orders = ref.watch(orderViewModelProvider);
  final viewModel = ref.read(orderViewModelProvider.notifier);
  return viewModel.orderHistory;
});
