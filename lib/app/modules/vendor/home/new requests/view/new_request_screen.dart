import 'package:ozi/app/data/response/api_status.dart';

import '../../../../../core/appExports/app_export.dart';
import '../../../../../data/models/vendor_home_model.dart';
import '../../../../../shared/widgets/custom_app_bar.dart';
import '../../../bookings/booking details/view/vendor_booking_details_screen.dart';
import '../../provider/vendor_home_provider.dart';
import '../../request_card/view/request_card_view.dart';
import '../provider/new_requests_provider.dart';

class NewRequestsScreen extends StatelessWidget {
  const NewRequestsScreen({super.key});


  void _showRejectWarning(
      BuildContext context,
      VoidCallback onConfirm,
      ) {
    showDialog(
      context: context,
      builder: (context) {
        return  Dialog(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
            ),
            child: Consumer<VendorHomeProvider>(
              builder: (context, provider, _) {
                if (provider.popupLoading) {
                  return const SizedBox(
                    height: 100,
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Reject Request",
                      textAlign: TextAlign.center,
                      style: AppFontStyle.text_22_600(
                        Color.fromRGBO(28, 29, 33, 1),
                      ),
                    ),

                    const SizedBox(height: 12),

                    Text(
                      maxLines: 5,
                      "Are you sure you want to reject this request?\nThis action cannot be undone.",
                      textAlign: TextAlign.center,
                      style: AppFontStyle.text_16_300(
                        Color.fromRGBO(112, 108, 108, 1),
                      ),
                    ),

                    const SizedBox(height: 28),

                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              height: 48,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                  color: Colors.grey.shade400,
                                ),
                              ),
                              child: Text(
                                "Cancel",
                                style: AppFontStyle.text_16_600(
                                  const Color.fromRGBO(112, 108, 108, 1),
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 16),

                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              Navigator.pop(context);
                              onConfirm();
                            },
                            child: Container(
                              height: 48,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: AppColors.red,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Text(
                                "Reject",
                                style: AppFontStyle.text_16_600(
                                  const Color.fromRGBO(255, 255, 255, 1),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NewRequestsProvider(),
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                const CustomAppBar(title: "New Requests"),
                hBox(16),
                Expanded(
                  child: Consumer<NewRequestsProvider>(
                    builder: (context, provider, _) {
                      switch (provider.requestModel.status) {
                        //  ApiStatus.loading =>
                        // return Center(child: CircularProgressIndicator()),
                        //
                        // ApiStatus.completed =>
                        //     ,
                        //
                        // ApiStatus.error =>
                        // const Center(child: Text('Something went wrong')),
                        //
                        // _ =>

                        case ApiStatus.loading:
                          // TODO: Handle this case.
                          return Center(child: CircularProgressIndicator());
                        case ApiStatus.completed:
                          // TODO: Handle this case.
                          return
                            provider.requestModel.data?.requests==null || provider.requestModel.data?.requests?.length == 0?
                            SizedBox(
                              height: MediaQuery.of(context).size.height*0.2,
                              child: Center(
                                child: Text(
                                  "No new requests available",
                                  style: AppFontStyle.text_16_500(AppColors.grey),
                                ),
                              ),
                            )
                                :
                            ListView.separated(
                            itemCount: provider.requestModel.data?.requests?.length??0,
                            separatorBuilder: (_, __) => hBox(14),
                            itemBuilder: (context, index) {
                              VendorHomeRequests request = provider.requestModel.data!.requests![index];
                              return RequestCard(
                                  onAccept: () async {
                                    final success =
                                    await provider.acceptOrRejectRequest(
                                      'accept',
                                      request.bookingId ?? '',
                                    );

                                    if (success && context.mounted) {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) => VendorBookingDetailsScreen(
                                            bookingId: request.bookingId.toString(),
                                          ),
                                        ),
                                      );
                                    }
                                  },

                                  onReject: () async {

                                    _showRejectWarning(context, () async{
                                      await provider.acceptOrRejectRequest(
                                        'reject',
                                        request.bookingId ?? '',
                                      );
                                    });
                                  },
                                  request: request
                              );

                              //   _requestCard(
                              //   context,
                              //   provider,
                              //   item,
                              //   index,
                              // );
                            },
                          );
                        case ApiStatus.error:
                          return const Center(child: Text('Something went wrong'));
                        case null:
                          return const Center(child: Text('Something went wrong'));
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}
