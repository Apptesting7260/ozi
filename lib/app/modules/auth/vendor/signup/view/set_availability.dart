import 'package:ozi/app/modules/auth/vendor/signup/view/identity_verification_screen.dart';
import '../../../../../core/appExports/app_export.dart';
import '../../../../../shared/widgets/custom_toggle_switch.dart';
import '../provider/availability_provider.dart';
import '../widget/vendor_custom_appbar.dart';

class SetAvailabilityScreen extends StatelessWidget {
  const SetAvailabilityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AvailabilityProvider(),
      child: const _SetAvailabilityContent(),
    );
  }
}

class _SetAvailabilityContent extends StatelessWidget {
  const _SetAvailabilityContent();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AvailabilityProvider>();

    return Scaffold(
      backgroundColor: AppColors.white,

      /// -------- BOTTOM BUTTON --------
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: CustomButton(
          isLoading: provider.submitLoading,
          text: "Continue",
          height: 54,
          borderRadius: BorderRadius.circular(60),
          onPressed: provider.submitLoading?(){}: () {
            print(provider.availability.toString());
            provider.saveAvailability();
          },
        ),
      ),

      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// -------- FIXED APP BAR --------
            VendorCustomAppBar(
              title: "Set Your Availability",
              columnChild: Text(
                "Step 3 of 6",
                style: AppFontStyle.text_12_400(AppColors.grey),
              ),
            ),

            hBox(20),

            /// -------- SCROLLABLE CONTENT --------
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ListView(
                  children: provider.availability.keys.map((day) {
                    final data = provider.availability[day]!;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _dayHeader(
                          day: day,
                          enabled: data.enabled,
                          onToggle: (val) => provider.toggleDay(day, val),
                          onAddSlot: () => provider.addSlot(day),
                        ),

                        if (data.enabled)
                          ...List.generate(
                            data.slots.length,
                                (index) => _timeSlot(
                              context: context,
                              day: day,
                              index: index,
                              slot: data.slots[index],
                              showRemove: data.slots.length > 1,
                              onRemove: () =>
                                  provider.removeSlot(day, index),
                              onFromTimeChange: (time) =>
                                  provider.updateSlotTime(
                                    day,
                                    index,
                                    from: time,
                                  ),
                              onToTimeChange: (time) =>
                                  provider.updateSlotTime(
                                    day,
                                    index,
                                    to: time,
                                  ),
                            ),
                          ),

                        const Divider(height: 24),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  // ---------------- DAY HEADER ----------------
  Widget _dayHeader({
    required String day,
    required bool enabled,
    required ValueChanged<bool> onToggle,
    required VoidCallback onAddSlot,
  }) {
    return Row(
      children: [
        CustomToggleSwitch(value: enabled, onChanged: onToggle),
        wBox(12),
        Expanded(
          child: Text(
            day,
            style: AppFontStyle.text_15_500(AppColors.darkText),
          ),
        ),
        if (enabled)
          GestureDetector(
            onTap: onAddSlot,
            child: Row(
              children: [
                CustomImage(path: ImageConstants.addIcon, height: 13, width: 13,),
                Text(
                  " Add slot",
                  style: AppFontStyle.text_14_500(AppColors.primary, fontFamily: AppFontFamily.medium),
                ),
              ],
            ),
          ),
      ],
    );
  }

  // ---------------- TIME SLOT ----------------
  Widget _timeSlot({
    required BuildContext context,
    required String day,
    required int index,
    required TimeSlot slot,
    required bool showRemove,
    required VoidCallback onRemove,
    required ValueChanged<String> onFromTimeChange,
    required ValueChanged<String> onToTimeChange,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: _timeBox(
              context: context,
              time: slot.from,
              onTimeSelected: onFromTimeChange,
            ),
          ),
          wBox(8),
          Text("To", style: AppFontStyle.text_12_400(AppColors.grey)),
          wBox(8),
          Expanded(
            child: _timeBox(
              context: context,
              time: slot.to,
              onTimeSelected: onToTimeChange,
            ),
          ),
          wBox(8),
          if (showRemove)
            GestureDetector(
              onTap: onRemove,
              child: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.lightRed,
                ),
                child: Icon(
                  Icons.close,
                  size: 16,
                  color: AppColors.red,
                ),
              ),
            )
          else
            SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _timeBox({
    required BuildContext context,
    required String time,
    required ValueChanged<String> onTimeSelected,
  }) {
    return GestureDetector(
      onTap: () async {
        final TimeOfDay? picked = await showTimePicker(
          context: context,
          initialTime: _parseTime(time),
          builder: (context, child) {
            return Theme(
              data: ThemeData.light().copyWith(
                primaryColor: AppColors.primary,
                colorScheme: ColorScheme.light(primary: AppColors.primary),
              ),
              child: child!,
            );
          },
        );

        if (picked != null) {
          final formattedTime = _formatTime(picked);
          onTimeSelected(formattedTime);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.lightGrey,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.access_time, size: 20, color: AppColors.darkText),
            wBox(6),
            Text(
              time,
              style: AppFontStyle.text_14_400(AppColors.darkText),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to parse time string to TimeOfDay
  TimeOfDay _parseTime(String time) {
    final parts = time.split(':');
    return TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );
  }

  // Helper method to format TimeOfDay to string
  String _formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}