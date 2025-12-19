import 'package:flutter/material.dart';
import '../../data/models/models.dart';

class MedicationItem extends StatelessWidget {
  final Medication medication;
  final String time;
  final bool isTaken;
  final VoidCallback? onTap;
  final VoidCallback? onMarkTaken;

  const MedicationItem({
    super.key,
    required this.medication,
    required this.time,
    required this.isTaken,
    this.onTap,
    this.onMarkTaken,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isTaken ? Colors.green.withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isTaken
              ? Colors.green.withOpacity(0.3)
              : Theme.of(context).colorScheme.primary.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Medication Icon with status indicator
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isTaken
                      ? Colors.green.withOpacity(0.1)
                      : Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.medication,
                  color: isTaken
                      ? Colors.green
                      : Theme.of(context).colorScheme.primary,
                  size: 20,
                ),
              ),
              if (isTaken)
                Positioned(
                  top: -2,
                  right: -2,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 10,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),
          // Medication Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  medication.name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.primary,
                    decoration: isTaken ? TextDecoration.lineThrough : null,
                    decorationColor: Colors.green,
                    decorationThickness: 2,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.schedule,
                      size: 12,
                      color: Theme.of(context)
                          .colorScheme
                          .secondary
                          .withOpacity(0.7),
                    ),
                    const SizedBox(width: 2),
                    Text(
                      time,
                      style: TextStyle(
                        fontSize: 11,
                        color: Theme.of(context).colorScheme.secondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.local_pharmacy,
                      size: 12,
                      color: Theme.of(context)
                          .colorScheme
                          .secondary
                          .withOpacity(0.7),
                    ),
                    const SizedBox(width: 2),
                    Text(
                      medication.dosage,
                      style: TextStyle(
                        fontSize: 11,
                        color: Theme.of(context).colorScheme.secondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Status/Action Button
          ElevatedButton(
            onPressed: isTaken ? null : onMarkTaken,
            style: ElevatedButton.styleFrom(
              backgroundColor: isTaken
                  ? Colors.green
                  : Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: isTaken ? 0 : 2,
            ),
            child: Text(
              isTaken ? '✓ Taken' : 'Take Now',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
