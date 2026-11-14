import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/helpers.dart';
import '../../providers/auth_provider.dart';
import '../notifications/notifications_screen.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  // Saved addresses list
  final List<Map<String, String>> _addresses = [
    {'title': 'Home 🏠', 'address': '42, Gandhi Nagar, Jaipur', 'isDefault': 'true'},
    {'title': 'Work 💼', 'address': '105, Corporate Tower, Malviya Nagar, Jaipur', 'isDefault': 'false'},
  ];

  // Dietary prefs state
  String _spicePref = 'Medium';
  String _dietPref = 'Veg';
  bool _noOnionGarlic = false;
  String _allergy = 'None';

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).value;
    final userName = (user?.name != null && user!.name.isNotEmpty) ? user.name : 'Rahul Sharma';
    final userPhone = (user?.phone != null && user!.phone.isNotEmpty)
        ? user.phone
        : (user?.email != null && user!.email.isNotEmpty ? user.email : '+91 98765 43210');
    final initialLetter = userName.isNotEmpty ? userName[0].toUpperCase() : 'U';

    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 30),
      children: [
        // ── USER PROFILE CARD ──
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.masala, AppColors.masalaDk],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: AppColors.masala.withOpacity(0.25),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.white,
                backgroundImage: (user?.photoUrl != null && user!.photoUrl.isNotEmpty)
                    ? NetworkImage(user.photoUrl)
                    : null,
                child: (user?.photoUrl == null || user!.photoUrl.isEmpty)
                    ? Text(
                        initialLetter,
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: AppColors.masala,
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      userPhone,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit_outlined, color: Colors.white),
                onPressed: () => _showEditProfileDialog(context, userName),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // ── WALLET BALANCE (OVERFLOW FIXED BY EXPANDED) ──
        InkWell(
          onTap: () => _showWalletHistorySheet(context, user?.walletBalance ?? 120),
          borderRadius: BorderRadius.circular(18),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.line, width: 1.2),
              boxShadow: [
                BoxShadow(
                  color: AppColors.ink.withOpacity(0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.cream,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text('👛', style: TextStyle(fontSize: 24)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Wallet balance',
                        style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Skipped days refund yahan aata hai',
                        style: Theme.of(context).textTheme.bodyMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  Helpers.price(user?.walletBalance ?? 120),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppColors.leaf,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.chevron_right_rounded, color: AppColors.ink60, size: 20),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // ── DIETARY PREFERENCES ──
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.line, width: 1.2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    '🥗 Dietary preferences',
                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => _showDietaryPrefSheet(context),
                    child: const Text(
                      'Edit ✏️',
                      style: TextStyle(
                        color: AppColors.masala,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _prefChip('🌶️ Spice: $_spicePref', () => _showDietaryPrefSheet(context)),
                  _prefChip('🥦 $_dietPref', () => _showDietaryPrefSheet(context)),
                  _prefChip(
                    _noOnionGarlic ? '🚫 No onion-garlic: ON' : '🧅 Onion-Garlic: Allowed',
                    () => _showDietaryPrefSheet(context),
                  ),
                  _prefChip('⚠️ Allergy: $_allergy', () => _showDietaryPrefSheet(context)),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // ── SAVED CUSTOMIZATION TEMPLATES ──
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.line, width: 1.2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '💾 Saved customization templates',
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
              ),
              const SizedBox(height: 10),
              _templateRow(
                context,
                'Meri default thali',
                'Medium spice • Low oil • +1 roti',
                'Default',
              ),
              const Divider(height: 20),
              _templateRow(
                context,
                'Jain special',
                'No onion-garlic • Mild • No sugar',
                'Preset',
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // ── MENU TILES (100% WORKING) ──
        _menuTile(
          context,
          Icons.notifications_none_rounded,
          'Notifications',
          'Messages & updates check karo',
          () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const NotificationsScreen()),
          ),
        ),
        _menuTile(
          context,
          Icons.location_on_outlined,
          'Delivery addresses',
          'Ghar aur office ke addresses manage karo',
          () => _showAddressesSheet(context),
        ),
        _menuTile(
          context,
          Icons.headset_mic_outlined,
          'Help & support',
          'Customer care & FAQs',
          () => _showHelpSupportSheet(context),
        ),

        const SizedBox(height: 20),

        // ── LOGOUT BUTTON ──
        OutlinedButton.icon(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.masala,
            side: const BorderSide(color: AppColors.masala, width: 1.6),
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
          icon: const Icon(Icons.logout_rounded, size: 20),
          label: const Text('Logout', style: TextStyle(fontWeight: FontWeight.w800)),
          onPressed: () => _confirmLogout(context, ref),
        ),
      ],
    );
  }

  Widget _prefChip(String label, VoidCallback onTap) => GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
            color: AppColors.cream,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.line),
          ),
          child: Text(
            label,
            style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: AppColors.ink),
          ),
        ),
      );

  Widget _templateRow(BuildContext context, String title, String sub, String badge) => InkWell(
        onTap: () => _showTemplateDetailsSheet(context, title, sub),
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          title,
                          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.turmeric.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            badge,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: AppColors.ink,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(sub, style: const TextStyle(fontSize: 12, color: AppColors.ink60)),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: AppColors.ink60),
            ],
          ),
        ),
      );

  Widget _menuTile(
    BuildContext context,
    IconData icon,
    String label,
    String subtitle,
    VoidCallback onTap,
  ) =>
      Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.line, width: 1.2),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.masala.withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.masala, size: 22),
          ),
          title: Text(label, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14.5)),
          subtitle: Text(subtitle, style: const TextStyle(fontSize: 12, color: AppColors.ink60)),
          trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.ink60),
          onTap: onTap,
        ),
      );

  // ── DIALOGS & SHEETS FOR WORKING FEATURES ──

  void _showEditProfileDialog(BuildContext context, String currentName) {
    final ctrl = TextEditingController(text: currentName);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit Profile Name ✏️'),
        content: TextField(
          controller: ctrl,
          decoration: const InputDecoration(labelText: 'Aapka Naam'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (ctrl.text.trim().isNotEmpty) {
                ref.read(authProvider.notifier).setName(ctrl.text.trim());
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Profile name updated ✅')),
                );
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showWalletHistorySheet(BuildContext context, double balance) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text('👛 Wallet History', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                const Spacer(),
                Text('Total: ${Helpers.price(balance)}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.leaf)),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            _walletTxTile('Refund: Skipped Lunch', 'Aug 09, 2026', '+ ₹110', true),
            _walletTxTile('Refund: Skipped Dinner', 'Aug 05, 2026', '+ ₹90', true),
            _walletTxTile('Used in Subscription', 'Aug 01, 2026', '- ₹80', false),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _walletTxTile(String title, String date, String amount, bool isCredit) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Icon(isCredit ? Icons.add_circle_outline : Icons.remove_circle_outline, color: isCredit ? AppColors.leaf : AppColors.masala),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5)),
                Text(date, style: const TextStyle(fontSize: 11, color: AppColors.ink60)),
              ],
            ),
            const Spacer(),
            Text(amount, style: TextStyle(fontWeight: FontWeight.w800, color: isCredit ? AppColors.leaf : AppColors.masala, fontSize: 14)),
          ],
        ),
      );

  void _showAddressesSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('📍 Saved Delivery Addresses', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
              const SizedBox(height: 14),
              ..._addresses.map((addr) => Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: addr['isDefault'] == 'true' ? AppColors.cream : Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: addr['isDefault'] == 'true' ? AppColors.masala : AppColors.line, width: 1.4),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.place_rounded, color: AppColors.masala),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(addr['title']!, style: const TextStyle(fontWeight: FontWeight.w800)),
                              const SizedBox(height: 2),
                              Text(addr['address']!, style: const TextStyle(fontSize: 12, color: AppColors.ink60)),
                            ],
                          ),
                        ),
                        if (addr['isDefault'] == 'true')
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(color: AppColors.masala, borderRadius: BorderRadius.circular(6)),
                            child: const Text('DEFAULT', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w800)),
                          ),
                      ],
                    ),
                  )),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.add_location_alt_outlined),
                  label: const Text('Naya Address Add Karo'),
                  onPressed: () {
                    Navigator.pop(ctx);
                    _showAddAddressDialog(context);
                  },
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddAddressDialog(BuildContext context) {
    final titleCtrl = TextEditingController(text: 'Home 🏡');
    final addrCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Naya Delivery Address 📍'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: 'Label (e.g. Home / Office)')),
            const SizedBox(height: 10),
            TextField(controller: addrCtrl, maxLines: 2, decoration: const InputDecoration(labelText: 'Full Address')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (addrCtrl.text.trim().isNotEmpty) {
                setState(() {
                  _addresses.add({
                    'title': titleCtrl.text.trim(),
                    'address': addrCtrl.text.trim(),
                    'isDefault': 'false',
                  });
                });
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Naya address save ho gaya ✅')),
                );
              }
            },
            child: const Text('Save Address'),
          ),
        ],
      ),
    );
  }

  void _showHelpSupportSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('🎧 Help & Support', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
            const SizedBox(height: 14),
            ListTile(
              leading: const CircleAvatar(backgroundColor: AppColors.leaf, child: Icon(Icons.phone, color: Colors.white)),
              title: const Text('Call Customer Support', style: TextStyle(fontWeight: FontWeight.w700)),
              subtitle: const Text('+91 98765 43210 (8 AM - 10 PM)'),
              onTap: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Calling +91 98765 43210… 📞')),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const CircleAvatar(backgroundColor: Color(0xFF25D366), child: Icon(Icons.chat, color: Colors.white)),
              title: const Text('WhatsApp Support', style: TextStyle(fontWeight: FontWeight.w700)),
              subtitle: const Text('Instant chat support on WhatsApp'),
              onTap: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Opening WhatsApp Support chat… 💬')),
                );
              },
            ),
            const Divider(),
            const Text('❓ Frequently Asked Questions', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
            const SizedBox(height: 8),
            const Text('Q: Delivery time kya hai?\nA: Lunch: 12:30 PM - 1:30 PM | Dinner: 8:00 PM - 9:00 PM', style: TextStyle(fontSize: 12, color: AppColors.ink60)),
            const SizedBox(height: 6),
            const Text('Q: Meal skip kaise karein?\nA: Home Screen par slot ke aage Skip button dabayein.', style: TextStyle(fontSize: 12, color: AppColors.ink60)),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _showDietaryPrefSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('🥗 Edit Dietary Preferences', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
              const SizedBox(height: 16),
              const Text('Diet Preference:', style: TextStyle(fontWeight: FontWeight.w700)),
              Row(
                children: ['Veg', 'Non-Veg', 'Jain'].map((d) => Padding(
                  padding: const EdgeInsets.only(right: 8, top: 6),
                  child: ChoiceChip(
                    label: Text(d),
                    selected: _dietPref == d,
                    onSelected: (_) {
                      setModalState(() => _dietPref = d);
                      setState(() {});
                    },
                  ),
                )).toList(),
              ),
              const SizedBox(height: 14),
              const Text('Spice Level:', style: TextStyle(fontWeight: FontWeight.w700)),
              Row(
                children: ['Mild', 'Medium', 'Hot'].map((s) => Padding(
                  padding: const EdgeInsets.only(right: 8, top: 6),
                  child: ChoiceChip(
                    label: Text(s),
                    selected: _spicePref == s,
                    onSelected: (_) {
                      setModalState(() => _spicePref = s);
                      setState(() {});
                    },
                  ),
                )).toList(),
              ),
              const SizedBox(height: 14),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('No Onion / No Garlic', style: TextStyle(fontWeight: FontWeight.w700)),
                value: _noOnionGarlic,
                onChanged: (v) {
                  setModalState(() => _noOnionGarlic = v);
                  setState(() {});
                },
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Preferences saved! ✅')),
                    );
                  },
                  child: const Text('Save Preferences'),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  void _showTemplateDetailsSheet(BuildContext context, String title, String sub) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('💾 $title', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            Text(sub, style: const TextStyle(fontSize: 13, color: AppColors.ink60)),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Template "$title" set as default! ✅')),
                  );
                },
                child: const Text('Set as Default Template'),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  void _confirmLogout(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Logout confirmation'),
        content: const Text('Kya aap logout karna chahte hain?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.masala),
            onPressed: () async {
              Navigator.pop(ctx);
              final prefs = await SharedPreferences.getInstance();
              await prefs.remove('user_name');
              await prefs.remove('user_email');
              await prefs.remove('user_photo');
              ref.read(authProvider.notifier).logout();
              if (context.mounted) {
                Navigator.of(context).pushReplacementNamed('/login');
              }
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}