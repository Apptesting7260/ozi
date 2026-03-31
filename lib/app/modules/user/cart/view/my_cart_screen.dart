import 'package:ozi/app/modules/user/cart/view/provider/cart_provider.dart';
import 'package:ozi/app/modules/user/cart/view/copponscreen.dart';
import 'package:ozi/app/modules/user/singleService/screen/singleservicescreen.dart';
import 'package:ozi/app/shared/widgets/custom_image_path_helper.dart';
import '../../../../core/appExports/app_export.dart';
import '../../../../core/constants/app_urls.dart';
import '../schedule_service/view/ScheduleServiceScreen.dart';
import 'model/cart_items_model.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CartProvider>().fetchCartItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    return const CartScreenContent();
  }
}

class CartScreenContent extends StatelessWidget {
  const CartScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
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
                            hBox(16),
                            _buildCouponContainer(context),
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

  Widget _buildCouponContainer(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cart, child) {
        final bool hasCoupon = cart.appliedCouponCode != null;
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.borderColor),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () async {
                    if (hasCoupon) {
                      // Flush bar(
                      //   message: 'Coupon already applied',
                      //   duration: const Duration(seconds: 2),
                      //   backgroundColor: AppColors.primary,
                      // ).show(context);
                      return;
                    }
                    final data = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CopponScreen()),
                    );

                    if (data == true) {
                      cart.fetchCartItems();
                    }
                  },
                  behavior: HitTestBehavior.opaque,
                  child: Row(
                    children: [
                      CustomImage(
                        path: 'assets/images/Group.png',
                        width: 24,
                        height: 24,
                      ),
                      wBox(12),
                      Expanded(
                        child: Text(
                          cart.appliedCouponCode ?? 'Apply Coupon Code',
                          style: AppFontStyle.text_16_500(
                            hasCoupon ? AppColors.primary : AppColors.darkText,
                            fontFamily: AppFontFamily.medium,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (hasCoupon)
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    if (kDebugMode) {
                      print('Cancel icon tapped');
                    }
                    cart.removeCoupon();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: cart.isRemoveLoading
                        ? SizedBox(
                            height: 15,
                            width: 15,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.primary,
                            ),
                          )
                        : Icon(
                            Icons.cancel,
                            size: 20,
                            color: AppColors.primary,
                          ),
                  ),
                )
              else
                Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.grey),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(color: Colors.white),
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
    return Consumer<CartProvider>(
      builder: (context, cart, child) {
        return InkWell(
          onTap: () async {
            // final result = await Navigator.push(
            //   context,
            //   // MaterialPageRoute(
            //   //   builder: (context) => singleServiceScreen(
            //   //     serviceId: int.parse(item.serviceId.toString()),
            //   //     isCart: true,
            //   //   ),
            //   // ),
            // );
            // if (result == true) {
            //   cart.fetchCartItems();
            // }
          },
          child: Container(
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
            child: GestureDetector(
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => singleServiceScreen(
                      serviceId: int.parse(item.serviceId.toString()),
                      isCart: true,
                    ),
                  ),
                );
                if (result == true) {
                  cart.fetchCartItems();
                }
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomImage(
                    path: ImagePathHelper.getFullImageUrl(
                      item.serviceImage,
                      AppUrls.imageBaseUrl,
                    ),
                    width: 80,
                    height: 80,
                    borderRadius: BorderRadius.circular(12),
                  ),

                  wBox(16),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                item.serviceName ?? '',
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

                        item.isservicedeleted == true ||
                                item.activeStatus == 'inactive'
                            ? SizedBox.shrink()
                            : Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                          border: Border.all(
                                            color: AppColors.primary,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            24,
                                          ),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 4,
                                          vertical: 4,
                                        ),
                                        child: SizedBox(
                                          width:
                                              MediaQuery.of(
                                                context,
                                              ).size.width *
                                              0.18,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  if (item.quantity! <= 1) {
                                                    cart.removeItem(
                                                      item.cartId!,
                                                    );
                                                  } else {
                                                    cart.updateQuantity(
                                                      item.cartId!,
                                                      -1,
                                                    );
                                                  }
                                                },
                                                child: Icon(
                                                  Icons.remove,
                                                  size: 16,
                                                  color: AppColors.primary,
                                                ),
                                              ),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                    ),
                                                child: Text(
                                                  '${item.quantity}',
                                                  style:
                                                      AppFontStyle.text_14_500(
                                                        AppColors.primary,
                                                        fontFamily:
                                                            AppFontFamily
                                                                .medium,
                                                      ),
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () =>
                                                    cart.updateQuantity(
                                                      item.cartId!,
                                                      1,
                                                    ),
                                                child: Icon(
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

                        hBox(12),
                        item.isservicedeleted == true ||
                                item.activeStatus == 'inactive'
                            ? Container(
                                padding: EdgeInsets.all(7),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: const Color.fromARGB(
                                    255,
                                    247,
                                    206,
                                    206,
                                  ),
                                ),
                                child: Text(
                                  "This service is not available",
                                  style: TextStyle(
                                    fontFamily: 'Mona Sans',
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.red,
                                  ),
                                ),
                              )
                            : SizedBox.shrink(),
                        // Spacer(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
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
              Text('Subtotal', style: AppFontStyle.text_14_400(AppColors.grey)),
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
          if (cart.discount > 0) ...[
            hBox(12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Discount',
                  style: AppFontStyle.text_14_400(AppColors.grey),
                ),
                Text(
                  '-\$${(cart.discount / 1).toStringAsFixed(2)}',
                  style: AppFontStyle.text_14_600(
                    AppColors.primary,
                    fontFamily: AppFontFamily.semiBold,
                  ),
                ),
              ],
            ),
          ],
          hBox(10),
          Divider(),
          hBox(10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: AppFontStyle.text_18_600(
                  AppColors.darkText,
                  fontFamily: AppFontFamily.semiBold,
                ),
              ),
              Text(
                '\$${cart.total.toString()}',
                style: AppFontStyle.text_22_600(
                  AppColors.primary,
                  // fontFamily: AppFontFamily.bold,
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
        onPressed: () {
          // Check if there are any items that are marked as deleted/unavailable
          final bool hasUnavailableItems = cart.items.any(
            (item) =>
                item.isservicedeleted == true ||
                item.activeStatus == 'inactive',
          );

          if (hasUnavailableItems) {
            // Show toast message to the user
            errorToast(
              context,
              'Please remove the unavailable service from your cart.',
            );
            // Get.showToast(
            //   "Please remove the unavailable service from your cart",
            //   type: ToastType.error,
            // );
            return; // Stop execution, don't navigate
          }

          // If everything is valid, proceed to schedule
          if (cart.items.isNotEmpty) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ScheduleServiceScreen()),
            );
          } else {
            errorToast(context, 'Your cart is empty');
          }
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
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
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
          Icon(Icons.error_outline, size: 80, color: Colors.red),
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
