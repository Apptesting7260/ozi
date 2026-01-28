import 'package:ozi/app/data/response/api_status.dart';

import '../../../../../core/appExports/app_export.dart';
import '../../../../../data/models/vendor_home_model.dart';
import '../../../../../shared/widgets/custom_app_bar.dart';
import '../../request_card/view/request_card_view.dart';
import '../provider/new_requests_provider.dart';

class NewRequestsScreen extends StatelessWidget {
  const NewRequestsScreen({super.key});

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
                            provider.requestModel.data?.requests==null || provider.requestModel.data?.requests?.length==0?
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
                                  onAccept: () {
                                    provider.acceptOrRejectRequest('accept',request.bookingId??'');
                                  },
                                  onReject: () {
                                    provider.acceptOrRejectRequest('reject',request.bookingId??'');
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

  // --------------------------------------------------------------------------
  // Widget _requestCard(
  //     BuildContext context,
  //     NewRequestsProvider provider,
  //     BookingRequest item,
  //     int index,
  //     ) {
  //   return Container(
  //     padding: const EdgeInsets.all(14),
  //     decoration: BoxDecoration(
  //       color: AppColors.white,
  //       borderRadius: BorderRadius.circular(16),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.black.withOpacity(0.05),
  //           blurRadius: 10,
  //           offset: const Offset(0, 4),
  //         ),
  //       ],
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         /// HEADER
  //         Row(
  //           children: [
  //             CircleAvatar(
  //               radius: 18,
  //               backgroundImage:
  //               const NetworkImage("https://i.pravatar.cc/150?img=3"),
  //             ),
  //             wBox(10),
  //             Expanded(
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Text(
  //                     item.name,
  //                     style: AppFontStyle.text_14_600(
  //                       AppColors.darkText,
  //                       fontFamily: AppFontFamily.semiBold,
  //                     ),
  //                   ),
  //                   Text(
  //                     item.service,
  //                     style: AppFontStyle.text_12_400(AppColors.grey),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //             _statusBadge(item.status),
  //           ],
  //         ),
  //
  //         hBox(12),
  //
  //         /// DETAILS
  //         _infoRow(Icons.calendar_today, "${item.date}"),
  //         hBox(6),
  //         _infoRow(Icons.access_time, item.time),
  //         hBox(6),
  //         _infoRow(Icons.location_on_outlined, item.address),
  //
  //         hBox(14),
  //
  //         /// PRICE + ACTIONS
  //         Row(
  //           children: [
  //             Text(
  //               "\$${item.price.toStringAsFixed(2)}",
  //               style: AppFontStyle.text_16_600(AppColors.primary),
  //             ),
  //             const Spacer(),
  //
  //             if (item.status == BookingStatus.newRequest) ...[
  //               CustomButton(
  //                 height: 34,
  //                 width: 80,
  //                 isOutlined: true,
  //                 color: AppColors.red,
  //                 text: "Reject",
  //                 textStyle: AppFontStyle.text_14_500(AppColors.red),
  //                 onPressed: () => provider.rejectRequest(index),
  //               ),
  //               wBox(8),
  //               CustomButton(
  //                 height: 34,
  //                 width: 80,
  //                 text: "Accept",
  //                 onPressed: () => provider.acceptRequest(index),
  //               ),
  //             ] else
  //               Container(
  //                 height: 34,
  //                 width: 34,
  //                 decoration:  BoxDecoration(
  //                   color: AppColors.primary,
  //                   shape: BoxShape.circle,
  //                 ),
  //                 child: const Icon(
  //                   Icons.phone,
  //                   color: Colors.white,
  //                   size: 18,
  //                 ),
  //               ),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // --------------------------------------------------------------------------
  Widget _statusBadge(BookingStatus status) {
    final isNew = status == BookingStatus.newRequest;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isNew
            ? AppColors.primary.withOpacity(0.12)
            : AppColors.lightBlue.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isNew ? "New Request" : "Confirmed",
        style: AppFontStyle.text_11_500(
          isNew ? AppColors.primary : AppColors.lightBlue,
        ),
      ),
    );
  }

  // --------------------------------------------------------------------------
  Widget _infoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppColors.grey),
        wBox(6),
        Expanded(
          child: Text(
            text,
            style: AppFontStyle.text_12_400(AppColors.grey),
          ),
        ),
      ],
    );
  }
}
