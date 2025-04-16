import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intellectra/components/constants.dart';
// import 'package:intellectra/views/course/models/course_models.dart'; // Remove old import
import '../models/course.dart'; // Add correct import
import 'package:intellectra/views/course_details/screens/components/section_viewer.dart';
import 'package:intellectra/views/course_details/services/api_service.dart';
import 'components/section_menu.dart';
import 'components/navigation_buttons.dart';
import 'components/video_player_widget.dart';
import 'components/section_quiz.dart';

class CourseDetailPage extends StatefulWidget {
  final int courseId;

  const CourseDetailPage({super.key, required this.courseId});

  @override
  CourseDetailPageState createState() => CourseDetailPageState();
}

class CourseDetailPageState extends State<CourseDetailPage> {
  late Future<Course> _courseFuture;
  final ApiService _apiService = ApiService();
  int _currentSectionIndex = 0;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _courseFuture = _apiService.fetchCourseDetails(widget.courseId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          FutureBuilder<Course>(
            future: _courseFuture,
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data?.pdfInternalData != null) {
                return IconButton(
                  icon: Icon(Icons.menu),
                  onPressed:
                      () => SectionMenu.show(
                        context,
                        snapshot.data!,
                        _currentSectionIndex,
                        _pageController,
                        (index) => setState(() {
                          _currentSectionIndex = index;
                          _pageController.jumpToPage(index);
                        }),
                      ),
                );
              }
              return SizedBox.shrink();
            },
          ),
        ],
      ),
      body: FutureBuilder<Course>(
        future: _courseFuture,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Error loading course:\n${snapshot.error}',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.red.shade700),
                ),
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasData) {
            final course = snapshot.data!;
            final sectionCount = course.pdfInternalData!.sections.length - 1;
            final hasVideo = course.videos != null && course.videos!.isNotEmpty;

            return Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _currentSectionIndex = index;
                      });
                    },
                    itemCount: sectionCount + 2, // intro + sections + quiz
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        // Intro page
                        return SingleChildScrollView(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                course.title,
                                style: GoogleFonts.poppins(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                course.description,
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  color: Colors.black54,
                                ),
                              ),
                              if (hasVideo) ...[
                                const SizedBox(height: 20),
                                VideoPlayerWidget(videoUrl: course.videos!),
                              ],
                              const SizedBox(height: 20),
                              Text(
                                course.pdfInternalData!.sections[0].title,
                                style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  color: primaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                course.pdfInternalData!.sections[0].content,
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.justify,
                              ),
                            ],
                          ),
                        );
                      } else if (index == sectionCount + 1) {
                        // Quiz page
                        return SectionQuiz(
                          course: course,
                          pageController: _pageController,
                          onFinish: () {
                            Navigator.of(context).pop();
                          },
                        );
                      } else {
                        // Section pages (index 1 to sectionCount)
                        final section =
                            course.pdfInternalData!.sections[index - 1];
                        return SectionViewer(
                          course: course,
                          currentIndex: index,
                          pageController: _pageController,
                          onPageChanged: (newIndex) {
                            setState(() {
                              _currentSectionIndex = newIndex;
                            });
                          },
                        );
                      }
                    },
                  ),
                ),
                if (_currentSectionIndex != sectionCount + 1)
                  NavigationButtons(
                    currentIndex: _currentSectionIndex,
                    totalSections: sectionCount + 2,
                    onNext: () {
                      if (_currentSectionIndex < sectionCount + 1) {
                        _pageController.nextPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                    onPrevious: () {
                      if (_currentSectionIndex > 0) {
                        _pageController.previousPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                    isFinished: false,
                  ),
              ],
            );
          }

          return const Center(child: Text('No data available'));
        },
      ),
    );
  }
}
