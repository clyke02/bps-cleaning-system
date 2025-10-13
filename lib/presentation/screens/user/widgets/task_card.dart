import 'package:flutter/material.dart';

class TaskCard extends StatelessWidget {
  final String title;
  final String area;
  final String status;
  final List<String> tasks;
  final DateTime deadline;
  final VoidCallback? onTap;
  final VoidCallback? onStart;
  final VoidCallback? onComplete;

  const TaskCard({
    super.key,
    required this.title,
    required this.area,
    required this.status,
    required this.tasks,
    required this.deadline,
    this.onTap,
    this.onStart,
    this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.1),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            area,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    _buildStatusBadge(),
                  ],
                ),

                const SizedBox(height: 12),

                // Tasks Preview
                Text(
                  'Tugas (${tasks.length} item):',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 4),
                ...tasks
                    .take(2)
                    .map(
                      (task) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Row(
                          children: [
                            Container(
                              width: 4,
                              height: 4,
                              decoration: BoxDecoration(
                                color: Colors.grey[500],
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                task,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                if (tasks.length > 2)
                  Text(
                    '... dan ${tasks.length - 2} tugas lainnya',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[500],
                      fontStyle: FontStyle.italic,
                    ),
                  ),

                const SizedBox(height: 12),

                // Deadline
                Row(
                  children: [
                    Icon(
                      Icons.schedule_outlined,
                      size: 14,
                      color: _getDeadlineColor(),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Deadline: ${_formatDeadline()}',
                      style: TextStyle(
                        fontSize: 11,
                        color: _getDeadlineColor(),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Action Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (status == 'pending' && onStart != null)
                      _buildActionButton(
                        'Mulai',
                        Icons.play_arrow,
                        const Color(0xFF4CAF50),
                        onStart!,
                      ),
                    if (status == 'in_progress' && onComplete != null) ...[
                      const SizedBox(width: 8),
                      _buildActionButton(
                        'Selesai',
                        Icons.check,
                        Colors.blue,
                        onComplete!,
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge() {
    Color color;
    String label;

    switch (status) {
      case 'pending':
        color = Colors.orange;
        label = 'Menunggu';
        break;
      case 'in_progress':
        color = Colors.blue;
        label = 'Sedang Dikerjakan';
        break;
      case 'completed':
        color = Colors.green;
        label = 'Selesai';
        break;
      case 'overdue':
        color = Colors.red;
        label = 'Terlambat';
        break;
      default:
        color = Colors.grey;
        label = 'Unknown';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
    );
  }

  Widget _buildActionButton(
    String label,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDeadline() {
    final now = DateTime.now();
    final difference = deadline.difference(now);

    if (difference.isNegative) {
      return 'Terlambat ${difference.inDays.abs()} hari';
    } else if (difference.inDays == 0) {
      return 'Hari ini';
    } else if (difference.inDays == 1) {
      return 'Besok';
    } else {
      return '${difference.inDays} hari lagi';
    }
  }

  Color _getDeadlineColor() {
    final now = DateTime.now();
    final difference = deadline.difference(now);

    if (difference.isNegative) {
      return Colors.red;
    } else if (difference.inDays <= 1) {
      return Colors.orange;
    } else {
      return Colors.grey[600]!;
    }
  }
}
