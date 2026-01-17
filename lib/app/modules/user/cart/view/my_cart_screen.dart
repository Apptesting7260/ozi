import 'package:ozi/app/modules/user/cart/view/provider/cart_provider.dart';
import 'package:ozi/app/shared/widgets/custom_image_path_helper.dart';
import '../../../../core/appExports/app_export.dart';
import '../../../../core/constants/app_urls.dart';
import '../../../../data/repository/repository.dart';
import '../schedule_service/view/ScheduleServiceScreen.dart';
import 'model/cart_items_model.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CartProvider(repository: Repository())..fetchCartItems(),
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
              child: Consumer<CartProvider>(
                builder: (context, cart, child) {
                  if (cart.isLoading) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    );
                  }

                  // Show error message
                  if (cart.errorMessage != null) {
                    return _buildError(context, cart.errorMessage!);
                  }

                  // Show empty cart widget when no items
                  if (cart.items.isEmpty) {
                    return _buildEmptyCart(context);
                  }

                  // Show cart items when available
                  return RefreshIndicator(
                    onRefresh: () => cart.fetchCartItems(),
                    color: AppColors.primary,
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: SingleChildScrollView(
                        physics: AlwaysScrollableScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              children: cart.items
                                  .map((item) => _buildCartItem(context, item))
                                  .toList(),
                            ),
                            hBox(24),
                            _buildOrderSummary(context),
                            hBox(20),
                            _buildBottomButton(context),
                            hBox(10),
                          ],
                        ),
                      ),
                    ),
                  );
                },
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
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'My Cart',
            style: AppFontStyle.text_26_600(
              AppColors.black,
              fontFamily: AppFontFamily.semiBold,
            ),
          ),
          Consumer<CartProvider>(
            builder: (context, cart, child) {
              return Text(
                '${cart.itemCount} items',
                style: AppFontStyle.text_16_400(AppColors.primary),
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
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomImage(
            path: ImagePathHelper.getFullImageUrl(item.serviceImage, AppUrls.imageBaseUrl,),
            width: 80,
            height: 80,
            borderRadius: BorderRadius.circular(12),
          ),

          wBox(16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        item.serviceName??'',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppFontStyle.text_14_500(
                          AppColors.darkText,
                          fontFamily: AppFontFamily.medium,
                        ),
                      ),
                    ),
                    wBox(8),

                    Consumer<CartProvider>(
                      builder: (context, cart, child) {
                        return InkWell(
                          onTap: () => cart.removeItem(item.cartId!),
                          child: CustomImage(
                            path: ImageConstants.bin,
                            width: 13,
                            height: 15,
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
                      '\$${(item.servicePrice! / 1).toStringAsFixed(2)}',
                      style: AppFontStyle.text_16_600(
                        AppColors.primary,
                        fontFamily: AppFontFamily.bold,
                      ),
                    ),

                    Consumer<CartProvider>(
                      builder: (context, cart, child) {
                        return Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.primary),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 4,
                          ),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.17,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: () {
                                    if (item.quantity! <= 1) {
                                      cart.removeItem(item.cartId!);
                                    } else {
                                      cart.updateQuantity(item.cartId!, -1);
                                    }
                                  },
                                  child:  Icon(
                                    Icons.remove,
                                    size: 16,
                                    color: AppColors.primary,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  child: Text(
                                    '${item.quantity}',
                                    style: AppFontStyle.text_14_500(
                                      AppColors.primary,
                                      fontFamily: AppFontFamily.medium,
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () => cart.updateQuantity(item.cartId!, 1),
                                  child:  Icon(
                                    Icons.add,
                                    size: 16,
                                    color: AppColors.primary,
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
              style: AppFontStyle.text_16_600(
                AppColors.darkText,
                fontFamily: AppFontFamily.semiBold,
              ),
            ),
            hBox(16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Subtotal',
                  style: AppFontStyle.text_14_400(AppColors.grey),
                ),
                Text(
                  '\$${(cart.subtotal / 1).toStringAsFixed(2)}',
                  style: AppFontStyle.text_14_500(
                    AppColors.darkText,
                    fontFamily: AppFontFamily.medium,
                  ),
                ),
              ],
            ),
            hBox(12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Service Fee',
                  style: AppFontStyle.text_14_400(AppColors.grey),
                ),
                Text(
                  '\$${(cart.serviceFee / 1).toStringAsFixed(2)}',
                  style: AppFontStyle.text_14_500(
                    AppColors.darkText,
                    fontFamily: AppFontFamily.medium,
                  ),
                ),
              ],
            ),
            hBox(10),
            Divider(),
            hBox(10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                 Text(
                  'Total',
                  style:  AppFontStyle.text_18_600(
                    AppColors.darkText,
                    fontFamily: AppFontFamily.semiBold,
                  ),
                ),
                Text(
                  '\$${(cart.total / 1).toStringAsFixed(2)}',
                  style:  AppFontStyle.text_24_700(
                    AppColors.primary,
                    fontFamily: AppFontFamily.bold,
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
        return CustomButton(
          onPressed: cart.items.isEmpty?() {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ScheduleServiceScreen(),
              ),
            );
          }:() {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ScheduleServiceScreen(),
              ),
            );
          },
          text: 'Continue to Book · \$${(cart.total / 1).toStringAsFixed(2)}',
        );
      },
    );
  }

  Widget _buildEmptyCart(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 100,
                    color: AppColors.primary,
                  ),
                  SizedBox(height: 24),
                  Text(
                    "Your Cart is Empty",
                    style: AppFontStyle.text_20_600(
                      AppColors.darkText,
                      fontFamily: AppFontFamily.semiBold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Add services to get started",
                    style: AppFontStyle.text_16_400(AppColors.black),
                  ),
                  SizedBox(height: 32),
                  Consumer<CartProvider>(
                    builder: (context, cart, child) {
                      return TextButton(
                        onPressed: () => cart.fetchCartItems(),
                        child: Text(
                          'Refresh Cart',
                          style: AppFontStyle.text_16_400(AppColors.primary),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildError(BuildContext context, String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 80,
              color: Colors.red,
            ),
            SizedBox(height: 16),
            Text(
              'Error Loading Cart',
              style: AppFontStyle.text_20_600(
                AppColors.darkText,
                fontFamily: AppFontFamily.semiBold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              error,
              textAlign: TextAlign.center,
              style: AppFontStyle.text_14_400(AppColors.grey),
            ),
            SizedBox(height: 24),
            Consumer<CartProvider>(
              builder: (context, cart, child) {
                return CustomButton(
                  onPressed: () => cart.fetchCartItems(),
                  text: 'Retry',
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}