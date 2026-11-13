import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UpgradeDialog extends StatefulWidget {
  const UpgradeDialog({super.key});

  @override
  _UpgradeDialogState createState() => _UpgradeDialogState();
}

class _UpgradeDialogState extends State<UpgradeDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 450),
      vsync: this,
    )..forward();

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: ScaleTransition(
        scale: _animation,
        child: AlertDialog(
          // Max width constraint for responsiveness (e.g., limit dialog size)
          // maxWidth: MediaQuery.of(context).size.width * 0.85,
          backgroundColor: Colors.white,
          elevation: 12,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
          contentPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),

          title: Column(
            children: [
              Container(
                height: 6,
                width: 60,
                decoration: BoxDecoration(
                  color: Colors.deepOrange,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Upgrade Plan",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Colors.black87,
                ),
              ),
            ],
          ),

          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 4),
              const Text(
                "This feature is available on our premium plan. Upgrade now to unlock full reports, enhanced insights, and priority support.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.4,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 20),

              // *** RESPONSIVENESS IMPROVEMENT: Use Wrap instead of Row ***
              // Wrap handles overflowing items by moving them to a new line,
              // which is ideal for benefit icons on small screens.
              Wrap(
                alignment:
                    WrapAlignment.center, // Center the items when they wrap
                spacing: 16.0, // Horizontal space between items
                runSpacing: 12.0, // Vertical space between lines if wrapped
                children: const [
                  _BenefitItem(icon: Icons.star, label: "Premium Access"),
                  _BenefitItem(icon: Icons.insights, label: "Detailed Reports"),
                  _BenefitItem(icon: Icons.security, label: "Priority Support"),
                ],
              ),
            ],
          ),

          actionsPadding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
          actions: <Widget>[
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.deepOrange),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                      "Maybe Later",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.deepOrange,
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrange,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                      "Upgrade Now",
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    onPressed: () {
                      // Navigator.push(
                      //   context,
                      //   NavigationHelper.pushToIos(PricingPlansScreen()),
                      // );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _BenefitItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _BenefitItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // Constraining the width slightly for safety when used in a Wrap
      width: 85,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.deepOrange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 20, color: Colors.deepOrange),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            textAlign: TextAlign.center, // Center text in case it wraps
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.black54,
              overflow: TextOverflow.ellipsis, // Safety for long labels
            ),
          ),
        ],
      ),
    );
  }
}
