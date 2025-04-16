// import 'package:flutter/material.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';
// import 'package:intellectra/models/user.dart';
// import 'package:intellectra/views/course_details/models/course.dart';
// import 'package:intellectra/views/course_details/services/api_service.dart';

// // Placeholder for getting user data and token - replace with your actual implementation
// Future<Map<String, dynamic>> getUserData() async {
//   // Replace with your logic to get user ID and token
//   await Future.delayed(Duration(milliseconds: 100)); // Simulate async operation
//   return {
//     'userId': 1,
//     'token': 'your_auth_token',
//     'userFirstName': 'TestUser',
//   }; // Example data
// }

// class SuccessCourseScreen extends StatefulWidget {
//   final Course course;

//   const SuccessCourseScreen({super.key, required this.course});

//   @override
//   _SuccessCourseScreenState createState() => _SuccessCourseScreenState();
// }

// class _SuccessCourseScreenState extends State<SuccessCourseScreen> {
//   final ApiService _apiService = ApiService();
//   double ratingValue = 3.0;
//   TextEditingController reviewController = TextEditingController();
//   int? userId;
//   String? token;
//   String? userFirstName;
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _loadUserData();
//   }

//   Future<void> _loadUserData() async {
//     try {
//       final userData = await getUserData();
//       if (mounted) {
//         setState(() {
//           userId = userData['userId'];
//           token = userData['token'];
//           userFirstName = userData['userFirstName'];
//           isLoading = false;
//         });
//       }
//     } catch (e) {
//       if (mounted) {
//         setState(() {
//           isLoading = false;
//         });
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(SnackBar(content: Text('Error loading user data: $e')));
//       }
//     }
//   }

//   @override
//   void dispose() {
//     reviewController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           onPressed: () => Navigator.pop(context),
//           icon: const Icon(Icons.arrow_back_ios),
//         ),
//         title: const Text('Success'),
//         centerTitle: true,
//       ),
//       body: SafeArea(
//         minimum: const EdgeInsets.all(24),
//         child:
//             isLoading
//                 ? Center(child: CircularProgressIndicator())
//                 : SingleChildScrollView(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       const SizedBox(height: 32),
//                       Image.asset(
//                         'assets/image/success.png',
//                         width: MediaQuery.of(context).size.width / 1.5,
//                       ),
//                       const SizedBox(height: 24),
//                       Text(
//                         'Congratulations, ${userFirstName ?? 'Student'}!',
//                         textAlign: TextAlign.center,
//                         style: const TextStyle(
//                           fontSize: 24,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       const Text(
//                         'You have successfully enrolled in this course.',
//                         textAlign: TextAlign.center,
//                         style: TextStyle(color: Colors.black54),
//                       ),
//                       const SizedBox(height: 32),
//                       SizedBox(
//                         width: double.infinity,
//                         child: ElevatedButton(
//                           onPressed: () {
//                             showDialog(
//                               context: context,
//                               builder: (BuildContext context) {
//                                 return StatefulBuilder(
//                                   builder: (context, setDialogState) {
//                                     return AlertDialog(
//                                       title: const Text('Rate this Course'),
//                                       content: Column(
//                                         mainAxisSize: MainAxisSize.min,
//                                         children: [
//                                           Text(
//                                             'Course: ${widget.course.title}',
//                                           ),
//                                           Slider(
//                                             value: ratingValue,
//                                             min: 1.0,
//                                             max: 5.0,
//                                             divisions: 4,
//                                             label:
//                                                 ratingValue.round().toString(),
//                                             onChanged: (double value) {
//                                               setDialogState(() {
//                                                 ratingValue = value;
//                                               });
//                                             },
//                                           ),
//                                           TextField(
//                                             controller: reviewController,
//                                             decoration: const InputDecoration(
//                                               hintText:
//                                                   'Write your review here...',
//                                             ),
//                                             minLines: 3,
//                                             keyboardType:
//                                                 TextInputType.multiline,
//                                             maxLines: 5,
//                                           ),
//                                         ],
//                                       ),
//                                       actions: [
//                                         TextButton(
//                                           child: const Text('CANCEL'),
//                                           onPressed:
//                                               () => Navigator.of(context).pop(),
//                                         ),
//                                         ElevatedButton(
//                                           onPressed:
//                                               (userId == null || token == null)
//                                                   ? null
//                                                   : () async {
//                                                     if (!mounted) return;
//                                                     try {
//                                                       await _apiService
//                                                           .createReview(
//                                                             widget.course.id,
//                                                             userId!,
//                                                             ratingValue,
//                                                             reviewController
//                                                                 .text,
//                                                             token!,
//                                                           );
//                                                       if (!mounted) return;
//                                                       Navigator.of(
//                                                         context,
//                                                       ).pop();
//                                                       ScaffoldMessenger.of(
//                                                         context,
//                                                       ).showSnackBar(
//                                                         SnackBar(
//                                                           content: Text(
//                                                             'Review Submitted!',
//                                                           ),
//                                                         ),
//                                                       );
//                                                     } catch (e) {
//                                                       if (!mounted) return;
//                                                       Navigator.of(
//                                                         context,
//                                                       ).pop();
//                                                       ScaffoldMessenger.of(
//                                                         context,
//                                                       ).showSnackBar(
//                                                         SnackBar(
//                                                           content: Text(
//                                                             'Failed to submit review: $e',
//                                                           ),
//                                                         ),
//                                                       );
//                                                     }
//                                                   },
//                                           child: const Text('SUBMIT'),
//                                         ),
//                                       ],
//                                     );
//                                   },
//                                 );
//                               },
//                             );
//                           },
//                           child: const Text('RATE COURSE'),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//       ),
//     );
//   }
// }
