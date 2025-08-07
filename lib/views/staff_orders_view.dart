import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/order_model.dart';
import '../viewmodels/order_viewmodel.dart';
import '../viewmodels/availability_viewmodel.dart';
import '../viewmodels/staff_orders_viewmodel.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';
import '../widgets/widgets.dart';

class StaffOrdersView extends ConsumerStatefulWidget {
  const StaffOrdersView({super.key});

  @override
  ConsumerState<StaffOrdersView> createState() => _StaffOrdersViewState();
}

class _StaffOrdersViewState extends ConsumerState<StaffOrdersView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _toggleAvailability() async {
    try {
      // Get current state
      final currentState = ref.read(staffOrdersViewModelProvider);
      final staffOrdersViewModel = ref.read(staffOrdersViewModelProvider.notifier);
      
      // Call API to toggle availability
      final availabilityService = ref.read(availabilityServiceProvider);
      await availabilityService.toggleAvailability();
      
      // Update local state and storage
      await staffOrdersViewModel.toggleAvailability();
      
      print('✅ Availability toggled successfully');
    } catch (e) {
      print('❌ Error toggling availability: $e');
      // Show error snackbar
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update availability: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final todayOrders = ref.watch(todayOrdersProvider);
    final orderHistory = ref.watch(orderHistoryProvider);
    final orderViewModel = ref.read(orderViewModelProvider.notifier);
    final staffOrdersState = ref.watch(staffOrdersViewModelProvider);
    final staffOrdersViewModel = ref.read(staffOrdersViewModelProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header with availability switch
            _buildHeader(staffOrdersState.isAvailable),
            
            // Category filters
            _buildCategoryFilters(staffOrdersState.selectedCategory, staffOrdersViewModel),
            
            // Tab bar
            Container(
              color: AppColors.surface,
              child: TabBar(
                controller: _tabController,
                labelColor: AppColors.primary,
                unselectedLabelColor: AppColors.textSecondary,
                indicatorColor: AppColors.primary,
                tabs: const [
                  Tab(text: 'Today\'s Orders'),
                  Tab(text: 'Order History'),
                ],
              ),
            ),
            
            // Tab content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildOrdersList(todayOrders, orderViewModel, 'today', staffOrdersState.selectedCategory),
                  _buildOrdersList(orderHistory, orderViewModel, 'history', staffOrdersState.selectedCategory),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isAvailable) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Staff Orders',
                  style: AppTextStyles.h4.copyWith(
                    color: AppColors.textWhite,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Manage patient orders and availability',
                  style: AppTextStyles.b2.copyWith(
                    color: AppColors.textWhite.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              Text(
                'Availability',
                style: AppTextStyles.label2.copyWith(
                  color: AppColors.textWhite,
                ),
              ),
              const SizedBox(height: 8),
              Switch(
                value: isAvailable,
                onChanged: (value) => _toggleAvailability(),
                activeColor: AppColors.success,
                activeTrackColor: AppColors.success.withOpacity(0.3),
                inactiveThumbColor: AppColors.textWhite,
                inactiveTrackColor: AppColors.textWhite.withOpacity(0.3),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilters(OrderCategory? selectedCategory, StaffOrdersViewModel viewModel) {
    final categories = OrderCategory.values;
    
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length + 1, // +1 for "All" option
        itemBuilder: (context, index) {
          if (index == 0) {
            // "All" option
            final isSelected = selectedCategory == null;
            return _buildCategoryChip(
              'All',
              null,
              isSelected,
              () {
                viewModel.setSelectedCategory(null);
              },
            );
          } else {
            final category = categories[index - 1];
            final isSelected = selectedCategory == category;
            return _buildCategoryChip(
              category.categoryText,
              category,
              isSelected,
              () {
                viewModel.setSelectedCategory(category);
              },
            );
          }
        },
      ),
    );
  }

  Widget _buildCategoryChip(
    String label,
    OrderCategory? category,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(
          label,
          style: AppTextStyles.label2.copyWith(
            color: isSelected ? AppColors.textWhite : AppColors.textPrimary,
          ),
        ),
        selected: isSelected,
        onSelected: (_) => onTap(),
        backgroundColor: AppColors.surface,
        selectedColor: category?.categoryColor ?? AppColors.primary,
        checkmarkColor: AppColors.textWhite,
        side: BorderSide(
          color: isSelected 
              ? (category?.categoryColor ?? AppColors.primary)
              : AppColors.border,
        ),
        elevation: isSelected ? 2 : 0,
      ),
    );
  }

  Widget _buildOrdersList(
    List<Order> orders,
    OrderViewModel orderViewModel,
    String type,
    OrderCategory? selectedCategory,
  ) {
    // Filter orders by selected category
    List<Order> filteredOrders = orders;
    if (selectedCategory != null) {
      filteredOrders = orderViewModel.filterByCategory(orders, selectedCategory);
    }

    if (filteredOrders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.assignment_outlined,
              size: 64,
              color: AppColors.textLight,
            ),
            const SizedBox(height: 16),
            Text(
              type == 'today' 
                  ? 'No orders for today'
                  : 'No order history',
              style: AppTextStyles.h6.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              type == 'today'
                  ? 'New orders will appear here'
                  : 'Completed orders will appear here',
              style: AppTextStyles.b2.copyWith(
                color: AppColors.textLight,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredOrders.length,
      itemBuilder: (context, index) {
        final order = filteredOrders[index];
        return _buildOrderCard(order, orderViewModel);
      },
    );
  }

  Widget _buildOrderCard(Order order, OrderViewModel orderViewModel) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header with order ID and status
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: order.statusColor.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order #${order.id}',
                        style: AppTextStyles.h6.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: order.statusColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          order.statusText,
                          style: AppTextStyles.label3.copyWith(
                            color: AppColors.textWhite,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: order.categoryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: order.categoryColor.withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    order.categoryText,
                    style: AppTextStyles.label3.copyWith(
                      color: order.categoryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Patient details
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Patient name and age
                Row(
                  children: [
                    Icon(
                      Icons.person,
                      size: 20,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        order.patientName,
                        style: AppTextStyles.h6.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    Text(
                      '${order.patientAge} years, ${order.patientGender}',
                      style: AppTextStyles.b2.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 12),
                
                // Phone number
                Row(
                  children: [
                    Icon(
                      Icons.phone,
                      size: 16,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      order.patientPhone,
                      style: AppTextStyles.b2.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 8),
                
                // Address
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 16,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        order.patientAddress,
                        style: AppTextStyles.b2.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 12),
                
                // Symptoms
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.medical_services,
                      size: 16,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        order.symptoms,
                        style: AppTextStyles.b2.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 12),
                
                // Order time and amount
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 16,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Ordered: ${_formatDateTime(order.orderTime)}',
                      style: AppTextStyles.b3.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const Spacer(),
                    if (order.amount != null)
                      Text(
                        'AED ${order.amount!.toStringAsFixed(2)}',
                        style: AppTextStyles.h6.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          
          // Action buttons
          if (order.status == OrderStatus.pending)
            _buildActionButtons(order, orderViewModel),
        ],
      ),
    );
  }

  Widget _buildActionButtons(Order order, OrderViewModel orderViewModel) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: AppButton(
              text: 'Accept',
              onPressed: () {
                orderViewModel.acceptOrder(order.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Order ${order.id} accepted'),
                    backgroundColor: AppColors.success,
                  ),
                );
              },
              backgroundColor: AppColors.success,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: AppButton(
              text: 'Decline',
              onPressed: () {
                orderViewModel.cancelOrder(order.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Order ${order.id} declined'),
                    backgroundColor: AppColors.error,
                  ),
                );
              },
              backgroundColor: AppColors.error,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }
}
