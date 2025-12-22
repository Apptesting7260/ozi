import 'package:ozi/core/appExports/app_export.dart';
import 'package:ozi/shared/widgets/custom_button.dart';
import '../provider/CartProvider.dart';
import '../schedule_service/view/ScheduleServiceScreen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CartProvider(),
      child: const CartScreenContent(),
    );
  }
}

class CartScreenContent extends StatelessWidget {
  const CartScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: Padding(
                padding:  EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Consumer<CartProvider>(
                      builder: (context, cart, child) {
                        return Column(
                          children: cart.items
                              .map((item) => _buildCartItem(context, item))
                              .toList(),
                        );
                      },
                    ),

                    const SizedBox(height: 24),

                    // Order Summary
                    _buildOrderSummary(context),

                    hBox(20),
                    _buildBottomButton(context),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
           Text(
            'My Cart',
            style: AppFontStyle.text_26_600( AppColors.black, fontFamily: AppFontFamily.semiBold,
            ),
          ),
          Consumer<CartProvider>(
            builder: (context, cart, child) {
              return Text(
                '${cart.itemCount} items',
                style:  AppFontStyle.text_16_400(AppColors.primary
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(BuildContext context, CartItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              item.imageUrl,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 80,
                  height: 80,
                  color: AppColors.grey,
                  child:  Icon(Icons.image, color: AppColors.grey),
                );
              },
            ),
          ),

      wBox(16),

          // Product Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        maxLines: 2,
                        item.name,
                        style: AppFontStyle.text_14_500(AppColors.darkText, fontFamily: AppFontFamily.medium
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Consumer<CartProvider>(
                      builder: (context, cart, child) {
                        return InkWell(
                          onTap: () => cart.removeItem(item.id),
                          child:  CustomImage(path: ImageConstants.bin,
                          ),
                        );
                      },
                    ),
                  ],
                ),

                hBox(8),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '\$${item.price.toStringAsFixed(2)}',
                      style:  AppFontStyle.text_16_600(
                         AppColors.primary,
                         fontFamily: AppFontFamily.bold
                         ),
                    ),

                    Consumer<CartProvider>(
                      builder: (context, cart, child) {
                        return Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppColors.primary,
                            ),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 4,
                          ),
                          child: SizedBox(
                            width: 90,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                InkWell(
                                  onTap: () => cart.updateQuantity(item.id, -1),
                                  child: Container(
                                    width: 28,
                                    height: 28,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child:  Icon(
                                      Icons.remove,
                                      size: 16,
                                      color: AppColors.primary,),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  child: Text(
                                    '${item.quantity}',
                                    style: AppFontStyle.text_14_500(AppColors.primary, fontFamily: AppFontFamily.medium
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () => cart.updateQuantity(item.id, 1),
                                  child: Container(
                                    width: 28,
                                    height: 28,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child:  Icon(
                                      Icons.add,
                                      size: 16,
                                      color: AppColors.primary,  ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 12),

              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummary(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cart, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Text(
              'Order Summary',
              style: AppFontStyle.text_16_600(AppColors.darkText, fontFamily: AppFontFamily.semiBold
              ),
            ),

            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                 Text(
                  'Subtotal',
                  style: AppFontStyle.text_14_400(AppColors.grey,
                  ),
                ),
                Text(
                  '\$${cart.subtotal.toStringAsFixed(2)}',
                  style: AppFontStyle.text_14_500(AppColors.darkText, fontFamily: AppFontFamily.medium
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                 Text(
                  'Service Fee',
                  style: AppFontStyle.text_14_400(AppColors.grey,
                  ),
                ),
                Text(
                  '\$${cart.serviceFee.toStringAsFixed(2)}',
                  style: AppFontStyle.text_14_500(AppColors.darkText, fontFamily: AppFontFamily.medium
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            Container(
              height: 1,
              color: const Color(0xFFE5E7EB),
            ),

            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111827),
                  ),
                ),
                Text(
                  '\$${cart.total.toStringAsFixed(2)}',
                  style:  TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF10B981),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildBottomButton(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cart, child) {
        return  CustomButton(onPressed: (){
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ScheduleServiceScreen(),
            ),
          );

        },
            text: 'Continue to Book · \$${cart.total.toStringAsFixed(2)}',
        );
      },
    );
  }
}