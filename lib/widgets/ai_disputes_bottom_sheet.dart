// import 'package:cirril/providers/core/ai_mail_create_provider.dart';
// import 'package:cirril/utils/async_notifier.dart';
// import 'package:cirril/views/ai/ai_mail_list_screen.dart';
// import 'package:cirril/widgets/navigation_helper.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
//
// import '../utils/async_notifier.dart';
// import 'navigation_helper.dart';
//
// class AiDisputeBottomSheet {
//   static void show(
//     BuildContext context, {
//     required String accountNumber,
//     required String bureau,
//   }) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.white,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
//       ),
//       builder: (_) => ProviderScope(
//         child: _AiDisputeSheetContent(
//           accountNumber: accountNumber,
//           bureau: bureau,
//         ),
//       ),
//     );
//   }
// }
//
// class _AiDisputeSheetContent extends ConsumerStatefulWidget {
//   final String accountNumber;
//   final String bureau;
//
//   const _AiDisputeSheetContent({
//     required this.accountNumber,
//     required this.bureau,
//   });
//
//   @override
//   ConsumerState<_AiDisputeSheetContent> createState() =>
//       _AiDisputeSheetContentState();
// }
//
// class _AiDisputeSheetContentState
//     extends ConsumerState<_AiDisputeSheetContent> {
//   String? _selectedItem;
//
//   // --- STATIC DATA (UNCHANGED) ---
//   final Map<String, List<String>> disputeCategories = {
//     "Loan Accounts Error Issues (Form No: 6-11)": [
//       "Duplicate Loan Account / Duplicate Credit Card Account",
//       "Incorrect Loan Account / Incorrect Credit Card Account",
//       "Loan Account / Credit Card Account Multiple Times Reflecting",
//       "Loan Account / Credit Card Account Doesn’t Belong to Me",
//       "Closed Loan Accounts / Credit Card Accounts, But Reflecting as Active",
//       "Loan Account is running as Standard and Active",
//     ],
//     "Credit Facility Status – Error Issues (Form No: 12-26 & 59-67)": [
//       "First Payment Default",
//       "Amount Overdue",
//       "Settled",
//       "Written-Off",
//       "Post Written-Off Settled",
//       "Willful Default",
//       "Suit Filed",
//       "Written-Off Amount (Total)",
//       "Written-Off Amount (Principal)",
//       "Settlement Amount",
//       "Restructured – Govt Mandate",
//       "Restructured – Natural Calamity",
//       "Restructured – Due To Covid-19",
//       "Written Off and Account Sold",
//       "Settled and Account Sold",
//       "SF",
//       "WD",
//       "WO",
//       "SET",
//       "RES",
//     ],
//     "Rural / Agriculture Credit Facility Status (Form No: 69-111)": [
//       "CGTMSE Loans",
//       "NSIC Loans",
//       "SIDBI Loans",
//       "MSME / SME Loans",
//       "MUDRA LOANS",
//       "DWACRA LOANS",
//       "SELF-HELP-GROUP Loans",
//       "Kisan Credit Card (KCC)",
//       "Crop Loan",
//       "Short-Term Crop Loans",
//       "Medium-term Agricultural Loans",
//       "Long-Term Crop Loans",
//       "Agriculture Term Loan",
//       "Farms Mechanization Loans",
//       "Agri Lands Development Loans",
//       "Agriculture Marketing Loans",
//       "Agriculture Stocks Storage and Marketing Loans",
//       "Horticulture and Plantation Loans",
//       "Horticulture and Agro-Forestry Loans",
//       "Agriculture Infrastructure Fund (AIF)",
//       "Farmer Long-Term Debt Financing Facility",
//       "Irrigation Loans",
//       "Agri Gold Loan",
//       "Warehouse Receipt Loans",
//       "Business Loan – Priority Sector – Agriculture",
//       "Mudra Loans – Shishu / Kishor / Tarun",
//       "Priority Sector – Gold Loan",
//       "Dairy Farm Loans",
//       "Goat-Sheep Farm Loans",
//       "Poultry Farm Loans",
//       "Fisheries and Beekeeping Loans",
//       "Mantri Matsya Sampada Yojana (PMMSY)",
//       "Sweet Kranti (Honey Mission)",
//       "Livestock Loans",
//       "National Livestock Mission (NLM)",
//       "Farm Equipment Loan",
//       "Earth Moving Equipment Loan",
//       "Medical Equipment Loan",
//       "Warehouse Construction",
//       "Cold Storage Construction Loans",
//       "RIDF (NABARD)",
//       "Solar Agri-Pump Loans",
//       "Agriculture – Irrigation – Systems",
//       "PM-KUSUM-Scheme Loans",
//       "Solar Roof-top Loans",
//       "PM-Surya-Ghar-Scheme",
//       "Modified Interest Subvention Scheme (MISS)",
//       "Short-term Agricultural Loans",
//     ],
//     "Loan Amount Sanctioned – But Not Disbursed (Form No: 114)": [
//       "Loan Amount Sanctioned – But Not Disbursed",
//     ],
//     "Auctioned Loans Accounts (Form No: 115-120)": [
//       "Auctioned and Settled",
//       "Auctioned and Sold",
//       "Auctioned and Overdue",
//       "Auctioned and Written-Off",
//       "Auctioned and Willful-Default",
//       "Auctioned and Suit-Filed",
//     ],
//     "PMRY / PMEGP Govt Scheme Loans (Form No: 121-124)": [
//       "PMRY – Prime Minister's Rozgar Yojana",
//       "PMMY – Pradhan Mantri Mudra Yojana",
//       "REGP – Rural Employment Generation Programme",
//       "KVIC – Khadi & Village Industries Commission",
//     ],
//     "Student Education Loans (Form No: 125-126)": [
//       "Education Loan – Secured Loan",
//       "Education Loan – Unsecured Loan",
//     ],
//   };
//
//   @override
//   Widget build(BuildContext context) {
//     final height = MediaQuery.of(context).size.height * 0.85;
//     final state = ref.watch(aiMailCreateProvider);
//
//     return SizedBox(
//       height: height,
//       child: Column(
//         children: [
//           Container(
//             margin: const EdgeInsets.only(top: 10, bottom: 12),
//             height: 5,
//             width: 60,
//             decoration: BoxDecoration(
//               color: Colors.grey.shade400,
//               borderRadius: BorderRadius.circular(10),
//             ),
//           ),
//           const Text(
//             "Select Dispute Category",
//             style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
//           ),
//           const SizedBox(height: 10),
//           Expanded(
//             child: ListView(
//               padding: const EdgeInsets.symmetric(horizontal: 18),
//               children: disputeCategories.entries
//                   .map((e) => _buildGroup(e.key, e.value))
//                   .toList(),
//             ),
//           ),
//           _buildBottomButton(context, state),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildGroup(String title, List<String> items) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const SizedBox(height: 14),
//         Text(
//           title,
//           style: const TextStyle(
//             fontSize: 15,
//             fontWeight: FontWeight.w700,
//             color: Colors.black87,
//           ),
//         ),
//         const SizedBox(height: 8),
//         ...items.map((item) {
//           final selected = _selectedItem == item;
//           return InkWell(
//             onTap: () => setState(() => _selectedItem = item),
//             child: Container(
//               margin: const EdgeInsets.only(bottom: 10),
//               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
//               decoration: BoxDecoration(
//                 color: selected
//                     ? Colors.deepOrange.withOpacity(.1)
//                     : Colors.grey.shade100,
//                 borderRadius: BorderRadius.circular(12),
//                 border: Border.all(
//                   color: selected ? Colors.deepOrange : Colors.grey.shade300,
//                   width: selected ? 2 : 1,
//                 ),
//               ),
//               child: Text(
//                 item,
//                 style: TextStyle(
//                   fontSize: 14,
//                   fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
//                 ),
//               ),
//             ),
//           );
//         }),
//       ],
//     );
//   }
//
//   Widget _buildBottomButton(BuildContext context, AsyncState state) {
//     return Container(
//       padding: const EdgeInsets.all(18),
//       width: double.infinity,
//       child: ElevatedButton(
//         onPressed: _selectedItem == null || state.isLoading
//             ? null
//             : () async {
//                 await ref
//                     .read(aiMailCreateProvider.notifier)
//                     .createMail(
//                       bureau: widget.bureau,
//                       issue: _selectedItem!,
//                       accountNumber: widget.accountNumber,
//                     );
//
//                 final result = ref.read(aiMailCreateProvider);
//
//                 if (result.error == null && mounted) {
//                   Navigator.pop(context);
//                   Navigator.push(
//                     context,
//                     NavigationHelper.pushToIos(const AiMailListScreen()),
//                   );
//                 }
//               },
//         style: ElevatedButton.styleFrom(
//           backgroundColor: _selectedItem != null
//               ? Colors.deepOrange
//               : Colors.grey.shade400,
//           foregroundColor: Colors.white,
//           padding: const EdgeInsets.symmetric(vertical: 14),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//         ),
//         child: state.isLoading
//             ? const SizedBox(
//                 height: 20,
//                 width: 20,
//                 child: CircularProgressIndicator(
//                   strokeWidth: 2,
//                   color: Colors.white,
//                 ),
//               )
//             : const Text(
//                 "Start AI Dispute Mailing",
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
//               ),
//       ),
//     );
//   }
// }
