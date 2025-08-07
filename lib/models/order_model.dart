import 'package:flutter/material.dart';

enum OrderStatus {
  pending,
  accepted,
  inProgress,
  completed,
  cancelled,
}

enum OrderCategory {
  consultation,
  emergency,
  followUp,
  routine,
  specialist;

  String get categoryText {
    switch (this) {
      case OrderCategory.consultation:
        return 'Consultation';
      case OrderCategory.emergency:
        return 'Emergency';
      case OrderCategory.followUp:
        return 'Follow Up';
      case OrderCategory.routine:
        return 'Routine';
      case OrderCategory.specialist:
        return 'Specialist';
    }
  }

  Color get categoryColor {
    switch (this) {
      case OrderCategory.consultation:
        return Colors.blue;
      case OrderCategory.emergency:
        return Colors.red;
      case OrderCategory.followUp:
        return Colors.green;
      case OrderCategory.routine:
        return Colors.orange;
      case OrderCategory.specialist:
        return Colors.purple;
    }
  }
}

class Order {
  final String id;
  final String patientName;
  final String patientPhone;
  final String patientAddress;
  final int patientAge;
  final String patientGender;
  final String symptoms;
  final OrderCategory category;
  final OrderStatus status;
  final DateTime orderTime;
  final DateTime? acceptedTime;
  final DateTime? completedTime;
  final String? notes;
  final double? amount;

  Order({
    required this.id,
    required this.patientName,
    required this.patientPhone,
    required this.patientAddress,
    required this.patientAge,
    required this.patientGender,
    required this.symptoms,
    required this.category,
    required this.status,
    required this.orderTime,
    this.acceptedTime,
    this.completedTime,
    this.notes,
    this.amount,
  });

  // Helper methods
  String get statusText {
    switch (status) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.accepted:
        return 'Accepted';
      case OrderStatus.inProgress:
        return 'In Progress';
      case OrderStatus.completed:
        return 'Completed';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }

  Color get statusColor {
    switch (status) {
      case OrderStatus.pending:
        return Colors.orange;
      case OrderStatus.accepted:
        return Colors.blue;
      case OrderStatus.inProgress:
        return Colors.purple;
      case OrderStatus.completed:
        return Colors.green;
      case OrderStatus.cancelled:
        return Colors.red;
    }
  }

  String get categoryText => category.categoryText;
  Color get categoryColor => category.categoryColor;

  // Factory constructor for demo data
  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] ?? '',
      patientName: json['patient_name'] ?? '',
      patientPhone: json['patient_phone'] ?? '',
      patientAddress: json['patient_address'] ?? '',
      patientAge: json['patient_age'] ?? 0,
      patientGender: json['patient_gender'] ?? '',
      symptoms: json['symptoms'] ?? '',
      category: OrderCategory.values.firstWhere(
        (e) => e.toString().split('.').last == json['category'],
        orElse: () => OrderCategory.consultation,
      ),
      status: OrderStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
        orElse: () => OrderStatus.pending,
      ),
      orderTime: DateTime.parse(json['order_time'] ?? DateTime.now().toIso8601String()),
      acceptedTime: json['accepted_time'] != null 
          ? DateTime.parse(json['accepted_time']) 
          : null,
      completedTime: json['completed_time'] != null 
          ? DateTime.parse(json['completed_time']) 
          : null,
      notes: json['notes'],
      amount: json['amount']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patient_name': patientName,
      'patient_phone': patientPhone,
      'patient_address': patientAddress,
      'patient_age': patientAge,
      'patient_gender': patientGender,
      'symptoms': symptoms,
      'category': category.toString().split('.').last,
      'status': status.toString().split('.').last,
      'order_time': orderTime.toIso8601String(),
      'accepted_time': acceptedTime?.toIso8601String(),
      'completed_time': completedTime?.toIso8601String(),
      'notes': notes,
      'amount': amount,
    };
  }
}
