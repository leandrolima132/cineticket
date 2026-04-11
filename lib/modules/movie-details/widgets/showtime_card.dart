import 'package:cineticket/core/theme/app_colors.dart';
import 'package:cineticket/data/models/showtime.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ShowtimeCard extends StatelessWidget {
  final Showtime showtime;
  final VoidCallback? onTap;

  const ShowtimeCard({super.key, required this.showtime, this.onTap});

  @override
  Widget build(BuildContext context) {
    final timeFormat = DateFormat('HH:mm');
    final dateFormat = DateFormat('dd/MM/yyyy');

    final plenty = showtime.availableSeats > 10;
    final availabilityColor = plenty ? AppColors.success : AppColors.spotlight;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: AppColors.surfaceElevated.withOpacity(0.75),
              border: Border.all(
                color: AppColors.outline.withOpacity(0.4),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.voidBlack.withOpacity(0.35),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    width: 5,
                    decoration: const BoxDecoration(
                      color: AppColors.accent,
                      borderRadius: BorderRadius.horizontal(
                        left: Radius.circular(15),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 14, 12, 14),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  showtime.theater,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    const Icon(Icons.meeting_room_rounded,
                                        size: 16, color: AppColors.textMuted),
                                    const SizedBox(width: 6),
                                    Text(
                                      'Sala ${showtime.room}',
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: AppColors.textSecondary,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                timeFormat.format(showtime.dateTime),
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.spotlightSoft,
                                  height: 1,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                dateFormat.format(showtime.dateTime),
                                textAlign: TextAlign.end,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textMuted,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 12),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: availabilityColor.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: availabilityColor.withOpacity(0.35),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.event_seat_rounded,
                                      size: 14,
                                      color: availabilityColor,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${showtime.availableSeats}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w800,
                                        color: availabilityColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Icon(
                                Icons.chevron_right_rounded,
                                color: AppColors.textMuted,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
