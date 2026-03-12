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

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        showtime.theater,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.meeting_room, size: 16, color: Colors.grey[400]),
                          const SizedBox(width: 4),
                          Text(
                            showtime.room,
                            style: TextStyle(fontSize: 14, color: Colors.grey[400]),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      timeFormat.format(showtime.dateTime),
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.redAccent[400]),
                    ),
                    Text(
                      dateFormat.format(showtime.dateTime),
                      style: TextStyle(fontSize: 12, color: Colors.grey[400]),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: showtime.availableSeats > 10
                        ? Colors.green.withOpacity(0.2)
                        : Colors.orange.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.event_seat,
                        size: 14,
                        color: showtime.availableSeats > 10 ? Colors.green[300] : Colors.orange[300],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${showtime.availableSeats} vagas',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: showtime.availableSeats > 10 ? Colors.green[300] : Colors.orange[300],
                        ),
                      ),
                    ],
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
