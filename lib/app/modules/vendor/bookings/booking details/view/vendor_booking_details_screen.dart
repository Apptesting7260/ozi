
import '../../../../../core/appExports/app_export.dart';
import '../../provider/vendor_mybookings_provider.dart';
import '../provider/vendor_booking_details_provider.dart';

class VendorBookingDetailsScreen extends StatelessWidget {
  final BookingModel booking;

  const VendorBookingDetailsScreen({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => VendorBookingDetailsProvider(booking),
      child: const _BookingDetailsContent(),
    );
  }
}

class _BookingDetailsContent extends StatelessWidget {
  const _BookingDetailsContent();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<VendorBookingDetailsProvider>();
    final booking = provider.booking;

    return Scaffold(
      backgroundColor: Colors.white,

      bottomNavigationBar: _buildBottomButton(context, provider),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// APP BAR
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.arrow_back, size: 20),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    "Booking Details",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              /// BOOKING ID + TOTAL
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Booking ID",
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      Text(
                        booking.id,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        "Total",
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      Text(
                        "\$${booking.total.toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF00BFA6),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 8),

              _StatusChip(status: booking.status),

              const SizedBox(height: 16),

              /// SERVICE
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      booking.imageUrl ??
                          "https://images.unsplash.com/photo-1522335789203-aabd1fc54bc9",
                      height: 60,
                      width: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          booking.service,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "\$${booking.price.toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF00BFA6),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              /// CUSTOMER DETAILS
              _sectionTitle("Customer Details"),
              const SizedBox(height: 12),

              Row(
                children: [
                  const CircleAvatar(
                    radius: 22,
                    backgroundImage:
                    NetworkImage("https://i.pravatar.cc/150?img=3"),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          booking.name,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),
                        Text(
                          booking.phone,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: provider.callCustomer,
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: const BoxDecoration(
                        color: Color(0xFF00BFA6),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.call,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              /// BOOKING DETAILS
              _sectionTitle("Booking Details"),
              const SizedBox(height: 12),

              _infoRow("Date", booking.date),
              _infoRow("Time", booking.time),
              _infoRow("Address", booking.address),

              const SizedBox(height: 16),

              /// NAVIGATE BUTTON
              SizedBox(
                width: double.infinity,
                height: 46,
                child: OutlinedButton(
                  onPressed: provider.navigateToCustomer,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF00BFA6)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    "Navigate to Customer",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF00BFA6),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              /// PAYMENT METHOD
              _sectionTitle("Payment Method"),
              const SizedBox(height: 8),
              Text(
                booking.paymentMethod,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF1A1A1A),
                ),
              ),

              const SizedBox(height: 24),

              /// PAYMENT SUMMARY
              _sectionTitle("Payment Summary"),
              const SizedBox(height: 12),

              _amountRow("Subtotal", booking.price),
              _amountRow("Service Fee", booking.serviceFee),
              const Divider(),
              _amountRow("Total", booking.total, bold: true),

              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  Widget? _buildBottomButton(
      BuildContext context,
      VendorBookingDetailsProvider provider,
      ) {
    if (provider.isOngoing) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          width: double.infinity,
          height: 54,
          child: ElevatedButton(
            onPressed: provider.isProcessing
                ? null
                : () => provider.completeJob(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00BFA6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(60),
              ),
              elevation: 0,
            ),
            child: provider.isProcessing
                ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            )
                : const Text(
              "Complete Job",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
      );
    }

    if (provider.isUpcoming) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          width: double.infinity,
          height: 54,
          child: ElevatedButton(
            onPressed: provider.isProcessing
                ? null
                : () => provider.startJob(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00BFA6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(60),
              ),
              elevation: 0,
            ),
            child: provider.isProcessing
                ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            )
                : const Text(
              "Start Job",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
      );
    }

    return null;
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Color(0xFF1A1A1A),
      ),
    );
  }

  Widget _infoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 70,
            child: Text(
              title,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF1A1A1A),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _amountRow(String title, double amount, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 13, color: Colors.grey),
          ),
          Text(
            "\$${amount.toStringAsFixed(2)}",
            style: TextStyle(
              fontSize: bold ? 14 : 13,
              fontWeight: bold ? FontWeight.w600 : FontWeight.w400,
              color: const Color(0xFF1A1A1A),
            ),
          ),
        ],
      ),
    );
  }


}
class _StatusChip extends StatelessWidget {
  final String status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    Color bg;
    String text;
    Color textColor;

    switch (status) {
      case "in_progress":
        bg = Colors.orange.withValues(alpha: 0.15);
        text = "In Progress";
        textColor = Colors.orange;
        break;
      case "confirmed":
        bg = Colors.blue.withValues(alpha: 0.15);
        text = "Confirmed";
        textColor = Colors.blue;
        break;
      case "completed":
        bg = Colors.green.withValues(alpha: 0.15);
        text = "Completed";
        textColor = Colors.green;
        break;
      case "cancelled":
        bg = Colors.red.withValues(alpha: 0.15);
        text = "Cancelled";
        textColor = Colors.red;
        break;
      default:
        bg = const Color(0xFFF5F5F5);
        text = status;
        textColor = const Color(0xFF1A1A1A);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: AppFontStyle.text_11_500(AppColors.black, fontFamily: AppFontFamily.medium)
      ),
    );
  }
}
