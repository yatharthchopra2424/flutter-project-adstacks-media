import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math' show min;

void main() {
  runApp(const MyApp());
}

// Data Models
class Employee {
  final String id;
  final String name;
  final String role;
  final String avatar;
  final DateTime? birthday;
  final DateTime? anniversary;
  final int projectsCompleted;
  final int artworks;
  final double rating;

  Employee({
    required this.id,
    required this.name,
    required this.role,
    required this.avatar,
    this.birthday,
    this.anniversary,
    this.projectsCompleted = 0,
    this.artworks = 0,
    this.rating = 0.0,
  });
}

class Project {
  final String id;
  String title;
  String description;
  DateTime deadline;
  ProjectStatus status;
  final DateTime createdAt;

  Project({
    required this.id,
    required this.title,
    required this.description,
    required this.deadline,
    required this.status,
    required this.createdAt,
  });
}

enum ProjectStatus {
  pending,
  inProgress,
  completed,
  overdue,
}

class YearlyPerformance {
  final int year;
  final int projectsDone;
  final int pendingClose;

  YearlyPerformance({
    required this.year,
    required this.projectsDone,
    required this.pendingClose,
  });
}

// Sample Data Generator
class DataService {
  static List<Employee> employees = [
    Employee(
      id: '1',
      name: 'Pooja Mishra',
      role: 'Admin',
      avatar: 'PM',
      birthday: DateTime(1990, 11, 7),
      anniversary: DateTime(2020, 3, 15),
      projectsCompleted: 45,
      artworks: 9821,
      rating: 4.9,
    ),
    Employee(
      id: '2',
      name: 'Madison Cooper',
      role: 'Designer',
      avatar: 'MC',
      birthday: DateTime(1992, 11, 7),
      artworks: 9821,
      rating: 4.8,
    ),
    Employee(
      id: '3',
      name: 'Karl Williams',
      role: 'Developer',
      avatar: 'KW',
      anniversary: DateTime(2019, 11, 8),
      artworks: 7032,
      rating: 4.7,
    ),
    Employee(
      id: '4',
      name: 'Sarah Johnson',
      role: 'Designer',
      avatar: 'SJ',
      artworks: 5204,
      rating: 4.6,
    ),
    Employee(
      id: '5',
      name: 'Mike Davis',
      role: 'Developer',
      avatar: 'MD',
      artworks: 4309,
      rating: 4.5,
    ),
  ];

  static List<Project> projects = [
    Project(
      id: '1',
      title: 'Technology behind the Blockchain',
      description: 'See project details',
      deadline: DateTime.now().subtract(const Duration(days: 2)),
      status: ProjectStatus.overdue,
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
    ),
    Project(
      id: '2',
      title: 'AI Machine Learning Platform',
      description: 'This project will be released on ${DateTime.now().add(const Duration(days: 30)).toString().split(' ')[0]}',
      deadline: DateTime.now().add(const Duration(days: 30)),
      status: ProjectStatus.inProgress,
      createdAt: DateTime.now().subtract(const Duration(days: 15)),
    ),
    Project(
      id: '3',
      title: 'Mobile App Development',
      description: 'This project will be released on ${DateTime.now().add(const Duration(days: 45)).toString().split(' ')[0]}',
      deadline: DateTime.now().add(const Duration(days: 45)),
      status: ProjectStatus.pending,
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
    ),
  ];

  static List<YearlyPerformance> performanceData = [
    YearlyPerformance(year: 2015, projectsDone: 35, pendingClose: 20),
    YearlyPerformance(year: 2016, projectsDone: 25, pendingClose: 30),
    YearlyPerformance(year: 2017, projectsDone: 45, pendingClose: 25),
    YearlyPerformance(year: 2018, projectsDone: 30, pendingClose: 40),
    YearlyPerformance(year: 2019, projectsDone: 55, pendingClose: 35),
    YearlyPerformance(year: 2020, projectsDone: 40, pendingClose: 45),
  ];

  static List<Employee> getTodayBirthdays() {
    final today = DateTime.now();
    return employees.where((e) {
      return e.birthday != null &&
          e.birthday!.month == today.month &&
          e.birthday!.day == today.day;
    }).toList();
  }

  static List<Employee> getUpcomingAnniversaries() {
    final today = DateTime.now();
    return employees.where((e) {
      if (e.anniversary == null) return false;
      final diff = DateTime(today.year, e.anniversary!.month, e.anniversary!.day)
          .difference(today)
          .inDays;
      return diff >= 0 && diff <= 7;
    }).toList();
  }

  static List<Employee> getTopCreators({String sortBy = 'artworks'}) {
    final sorted = List<Employee>.from(employees);
    if (sortBy == 'artworks') {
      sorted.sort((a, b) => b.artworks.compareTo(a.artworks));
    } else if (sortBy == 'rating') {
      sorted.sort((a, b) => b.rating.compareTo(a.rating));
    } else {
      sorted.sort((a, b) => a.name.compareTo(b.name));
    }
    return sorted.take(4).toList();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dashboard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Roboto',
      ),
      home: const Dashboard(),
    );
  }
}

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int selectedMenuIndex = 0;
  String selectedWorkspace = 'Adstacks';
  DateTime selectedDate = DateTime.now();
  String creatorsSortBy = 'artworks';
  String searchQuery = '';
  bool showNotifications = false;
  
  // Data
  late List<Project> projects;
  late List<Employee> employees;
  late List<YearlyPerformance> performanceData;
  
  @override
  void initState() {
    super.initState();
    projects = List.from(DataService.projects);
    employees = List.from(DataService.employees);
    performanceData = List.from(DataService.performanceData);
  }
  
  void addProject() {
    showDialog(
      context: context,
      builder: (context) => AddProjectDialog(
        onAdd: (project) {
          setState(() {
            projects.add(project);
          });
        },
      ),
    );
  }
  
  void editProject(Project project) {
    showDialog(
      context: context,
      builder: (context) => EditProjectDialog(
        project: project,
        onSave: (updatedProject) {
          setState(() {
            final index = projects.indexWhere((p) => p.id == project.id);
            if (index != -1) {
              projects[index] = updatedProject;
            }
          });
        },
        onDelete: () {
          setState(() {
            projects.removeWhere((p) => p.id == project.id);
          });
        },
      ),
    );
  }
  
  void showWishingDialog(String type, List<Employee> people) {
    showDialog(
      context: context,
      builder: (context) => WishingDialog(type: type, people: people),
    );
  }
  
  List<Project> get filteredProjects {
    if (searchQuery.isEmpty) return projects;
    return projects.where((p) => 
      p.title.toLowerCase().contains(searchQuery.toLowerCase())
    ).toList();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: Row(
        children: [
          // Left Sidebar
          _buildSidebar(),
          
          // Main Content
          Expanded(
            child: Column(
              children: [
                _buildTopBar(),
                Expanded(
                  child: Row(
                    children: [
                      // Center Content Area
                      Expanded(
                        flex: 7,
                        child: _buildMainContent(),
                      ),
                      // Right Sidebar (Calendar & Events)
                      Expanded(
                        flex: 3,
                        child: _buildRightSidebar(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar() {
    return Container(
      width: 240,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(2, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          // Logo
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFF6B9D), Color(0xFFC06C84)],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.rocket_launch, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Adstacks',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3748),
                  ),
                ),
              ],
            ),
          ),
          
          // Scrollable Content
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Profile Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF7FAFC),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 28,
                            backgroundColor: Colors.grey[300],
                            child: const Icon(Icons.person, size: 32, color: Colors.white),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Pooja Mishra',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF2D3748),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[300]!),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'Admin',
                              style: TextStyle(
                                fontSize: 11,
                                color: Color(0xFF718096),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Menu Items
                  _buildMenuItem(Icons.home_rounded, 'Home', 0),
                  _buildMenuItem(Icons.people_outline, 'Employees', 1),
                  _buildMenuItem(Icons.event_note, 'Attendance', 2),
                  _buildMenuItem(Icons.bar_chart_rounded, 'Summary', 3),
                  _buildMenuItem(Icons.info_outline, 'Information', 4),
                  
                  const SizedBox(height: 20),
                  
                  // Workspaces Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'WORKSPACES',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF718096),
                                letterSpacing: 0.5,
                              ),
                            ),
                            Icon(Icons.add, size: 16, color: Colors.grey[600]),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _buildWorkspaceItem('Adstacks', true),
                        _buildWorkspaceItem('Finance', false),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 60), // Extra space before bottom items
                ],
              ),
            ),
          ),
          
          // Bottom Menu (Fixed at bottom)
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.05),
                  spreadRadius: 0,
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildBottomMenuItem(Icons.settings_outlined, 'Setting'),
                _buildBottomMenuItem(Icons.logout, 'Logout'),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, int index) {
    final isSelected = selectedMenuIndex == index;
    return InkWell(
      onTap: () {
        setState(() {
          selectedMenuIndex = index;
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF6C5CE7).withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected ? const Color(0xFF6C5CE7) : const Color(0xFF718096),
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? const Color(0xFF6C5CE7) : const Color(0xFF718096),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkspaceItem(String name, bool isExpanded) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            isExpanded ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_right,
            size: 16,
            color: Colors.grey[600],
          ),
          const SizedBox(width: 8),
          Text(
            name,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Color(0xFF2D3748),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomMenuItem(IconData icon, String title) {
    return InkWell(
      onTap: () {},
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(icon, size: 20, color: const Color(0xFF718096)),
            const SizedBox(width: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF718096),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 32),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const Text(
            'Home',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2D3748),
            ),
          ),
          const Spacer(),
          
          // Search Bar
          Container(
            width: 300,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF2D3748),
              borderRadius: BorderRadius.circular(20),
            ),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
              style: const TextStyle(color: Colors.white, fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Search projects...',
                hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 14),
                prefixIcon: Icon(Icons.search, color: Colors.white.withValues(alpha: 0.5), size: 20),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),
          
          const SizedBox(width: 20),
          
          // Icons
          _buildIconButton(Icons.shopping_bag_outlined, onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Shopping bag feature coming soon!')),
            );
          }),
          const SizedBox(width: 16),
          _buildIconButton(Icons.notifications_outlined, badge: true, onTap: () {
            setState(() {
              showNotifications = !showNotifications;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('You have ${DataService.getTodayBirthdays().length} birthday notifications!'),
                duration: const Duration(seconds: 2),
              ),
            );
          }),
          const SizedBox(width: 16),
          _buildIconButton(Icons.logout, onTap: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Logout'),
                content: const Text('Are you sure you want to logout?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Logged out successfully!')),
                      );
                    },
                    child: const Text('Logout'),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(width: 16),
          
          // Profile
          CircleAvatar(
            radius: 18,
            backgroundColor: const Color(0xFF6C5CE7),
            child: const Text(
              'PM',
              style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton(IconData icon, {bool badge = false, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFF7FAFC),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 20, color: const Color(0xFF2D3748)),
          ),
          if (badge)
            Positioned(
              top: -4,
              right: -4,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hero Card - Full Width
          Row(
            children: [
              Expanded(
                child: _buildHeroCard(),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 6,
                child: Column(
                  children: [
                    // Projects Section
                    _buildProjectsSection(),
                  ],
                ),
              ),
              
              const SizedBox(width: 24),
              
              // Top Creators
              Expanded(
                flex: 4,
                child: _buildTopCreatorsCard(),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Performance Chart - Full Width
          Row(
            children: [
              Expanded(
                child: _buildPerformanceChart(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeroCard() {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF9D7CE8),
            Color(0xFFE8A1C8),
            Color(0xFFB4A3F0),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          // Decorative shapes
          Positioned(
            right: 20,
            top: 20,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          Positioned(
            right: 50,
            top: 30,
            child: Transform.rotate(
              angle: 0.3,
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF4ECDC4).withValues(alpha: 0.8),
                      const Color(0xFF44A08D).withValues(alpha: 0.8),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          'EMPLOYEE OF',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Top Rating\nProject',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Promoting projects and high ratings\nhas never been easier for teams',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 6),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6C5CE7),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Learn More',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 120), // Space for decorative shapes
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectsSection() {
    final displayProjects = filteredProjects.take(3).toList();
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF2D3748),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'All Projects',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle_outline, color: Colors.white),
                onPressed: addProject,
                tooltip: 'Add New Project',
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (displayProjects.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  'No projects found',
                  style: TextStyle(color: Colors.white70),
                ),
              ),
            )
          else
            ...displayProjects.map((project) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildProjectCard(project),
            )).toList(),
        ],
      ),
    );
  }

  Widget _buildProjectCard(Project project) {
    Color statusColor = Colors.grey[700]!;
    if (project.status == ProjectStatus.overdue) {
      statusColor = Colors.red;
    } else if (project.status == ProjectStatus.completed) {
      statusColor = Colors.green;
    } else if (project.status == ProjectStatus.inProgress) {
      statusColor = Colors.orange;
    }
    
    return InkWell(
      onTap: () => editProject(project),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1A202C),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                project.status == ProjectStatus.completed 
                  ? Icons.check_circle 
                  : Icons.auto_awesome,
                color: statusColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    project.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    project.description,
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.edit_outlined, color: Colors.grey[600], size: 18),
          ],
        ),
      ),
    );
  }

  Widget _buildTopCreatorsCard() {
    final topCreators = DataService.getTopCreators(sortBy: creatorsSortBy);
    
    return Container(
      height: 340, // Match the approximate height of All Projects section
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF2D3748),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Top Creators',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              _buildTabButton('name', creatorsSortBy == 'name'),
              const SizedBox(width: 8),
              _buildTabButton('artworks', creatorsSortBy == 'artworks'),
              const SizedBox(width: 8),
              _buildTabButton('rating', creatorsSortBy == 'rating'),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: List.generate(topCreators.length, (index) {
                final creator = topCreators[index];
                return _buildCreatorItem(creator, index + 1);
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(String sortType, bool isActive) {
    return InkWell(
      onTap: () {
        setState(() {
          creatorsSortBy = sortType;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF6C5CE7).withValues(alpha: 0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          sortType[0].toUpperCase() + sortType.substring(1),
          style: TextStyle(
            color: isActive ? const Color(0xFF9D7CE8) : Colors.grey[500],
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildCreatorItem(Employee creator, int rank) {
    final colors = [Colors.purple, Colors.blue, Colors.orange, Colors.grey];
    final color = colors[min(rank - 1, colors.length - 1)];
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: color.withValues(alpha: 0.2),
            child: Text(
              '#$rank',
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  creator.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  creatorsSortBy == 'rating' 
                    ? '${creator.rating} ⭐'
                    : '${creator.artworks} artworks',
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 60,
            height: 6,
            decoration: BoxDecoration(
              color: Colors.grey[700],
              borderRadius: BorderRadius.circular(3),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: (5 - rank) / 4,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [color, color.withValues(alpha: 0.6)],
                  ),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceChart() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Over All Performance\nThe Years',
                style: TextStyle(
                  color: Color(0xFF2D3748),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  height: 1.3,
                ),
              ),
              const Spacer(),
              _buildLegendItem('Pending\nClose', Colors.red),
              const SizedBox(width: 16),
              _buildLegendItem('Project\nDone', const Color(0xFF6C5CE7)),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 20,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.grey[200]!,
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 20,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 11,
                          ),
                        );
                      },
                      reservedSize: 30,
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const years = ['2015', '2016', '2017', '2018', '2019', '2020'];
                        if (value.toInt() >= 0 && value.toInt() < years.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              years[value.toInt()],
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 11,
                              ),
                            ),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: 5,
                minY: 0,
                maxY: 80,
                lineBarsData: [
                  // Purple line (Project Done)
                  LineChartBarData(
                    spots: const [
                      FlSpot(0, 35),
                      FlSpot(1, 25),
                      FlSpot(2, 45),
                      FlSpot(3, 30),
                      FlSpot(4, 55),
                      FlSpot(5, 40),
                    ],
                    isCurved: true,
                    gradient: const LinearGradient(
                      colors: [Color(0xFF6C5CE7), Color(0xFF9D7CE8)],
                    ),
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF6C5CE7).withOpacity(0.1),
                          const Color(0xFF6C5CE7).withOpacity(0.0),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                  // Red line (Pending Close)
                  LineChartBarData(
                    spots: const [
                      FlSpot(0, 20),
                      FlSpot(1, 30),
                      FlSpot(2, 25),
                      FlSpot(3, 40),
                      FlSpot(4, 35),
                      FlSpot(5, 45),
                    ],
                    isCurved: true,
                    gradient: const LinearGradient(
                      colors: [Colors.red, Colors.redAccent],
                    ),
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(show: false),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String text, Color color) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 10,
            height: 1.2,
          ),
        ),
      ],
    );
  }

  Widget _buildRightSidebar() {
    final todayBirthdays = DataService.getTodayBirthdays();
    final upcomingAnniversaries = DataService.getUpcomingAnniversaries();
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Calendar
          _buildCalendar(),
          
          const SizedBox(height: 20),
          
          // Birthday Card
          _buildEventCard(
            'Today Birthday',
            todayBirthdays,
            Colors.orange,
            Icons.cake,
          ),
          
          const SizedBox(height: 16),
          
          // Anniversary Card
          _buildEventCard(
            'Anniversary',
            upcomingAnniversaries,
            Colors.purple,
            Icons.celebration,
          ),
        ],
      ),
    );
  }

  Widget _buildCalendar() {
    final now = DateTime.now();
    final firstDayOfMonth = DateTime(now.year, now.month, 1);
    final lastDayOfMonth = DateTime(now.year, now.month + 1, 0);
    final daysInMonth = lastDayOfMonth.day;
    final startWeekday = firstDayOfMonth.weekday % 7;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF2D3748),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'GENERAL 10:00 AM TO 7:00 PM',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Weekday headers
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'].map((day) {
              return SizedBox(
                width: 28,
                child: Center(
                  child: Text(
                    day,
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          
          const SizedBox(height: 12),
          
          // Calendar grid
          ...List.generate((daysInMonth + startWeekday + 6) ~/ 7, (weekIndex) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(7, (dayIndex) {
                  final dayNumber = weekIndex * 7 + dayIndex - startWeekday + 1;
                  
                  if (dayNumber < 1 || dayNumber > daysInMonth) {
                    return const SizedBox(width: 28, height: 28);
                  }
                  
                  final isToday = dayNumber == now.day;
                  final isSelected = selectedDate.day == dayNumber && 
                                    selectedDate.month == now.month &&
                                    selectedDate.year == now.year;
                  
                  return InkWell(
                    onTap: () {
                      setState(() {
                        selectedDate = DateTime(now.year, now.month, dayNumber);
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Selected: ${selectedDate.toString().split(' ')[0]}'),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(6),
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: isToday
                            ? const Color(0xFF6C5CE7)
                            : (isSelected ? const Color(0xFF9D7CE8).withValues(alpha: 0.3) : Colors.transparent),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Center(
                        child: Text(
                          dayNumber.toString(),
                          style: TextStyle(
                            color: isToday ? Colors.white : Colors.white70,
                            fontSize: 12,
                            fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildEventCard(String title, List<Employee> people, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color,
            color.withValues(alpha: 0.7),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.white, size: 24),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Avatar row with initials
          Row(
            children: List.generate(
              people.length > 3 ? 3 : people.length,
              (index) => Padding(
                padding: EdgeInsets.only(left: index == 0 ? 0 : 8),
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.white.withValues(alpha: 0.3),
                  child: Text(
                    people[index].avatar,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          Row(
            children: [
              const Text(
                'Total',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  people.length.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          ElevatedButton(
            onPressed: people.isNotEmpty ? () => showWishingDialog(title, people) : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white.withValues(alpha: 0.2),
              foregroundColor: Colors.white,
              disabledBackgroundColor: Colors.white.withValues(alpha: 0.1),
              disabledForegroundColor: Colors.white54,
              minimumSize: const Size(double.infinity, 36),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
            ),
            child: Text(
              title == 'Today Birthday' ? 'Birthday Wishing' : 'Anniversary Wishing',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

// Dialog Widgets

class AddProjectDialog extends StatefulWidget {
  final Function(Project) onAdd;

  const AddProjectDialog({super.key, required this.onAdd});

  @override
  State<AddProjectDialog> createState() => _AddProjectDialogState();
}

class _AddProjectDialogState extends State<AddProjectDialog> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  DateTime deadline = DateTime.now().add(const Duration(days: 30));
  ProjectStatus status = ProjectStatus.pending;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add New Project'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Project Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('Deadline'),
              subtitle: Text(deadline.toString().split(' ')[0]),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: deadline,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (picked != null) {
                  setState(() {
                    deadline = picked;
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<ProjectStatus>(
              value: status,
              decoration: const InputDecoration(
                labelText: 'Status',
                border: OutlineInputBorder(),
              ),
              items: ProjectStatus.values.map((s) {
                return DropdownMenuItem(
                  value: s,
                  child: Text(s.toString().split('.').last),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    status = value;
                  });
                }
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (titleController.text.isNotEmpty) {
              final project = Project(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                title: titleController.text,
                description: descriptionController.text,
                deadline: deadline,
                status: status,
                createdAt: DateTime.now(),
              );
              widget.onAdd(project);
              Navigator.pop(context);
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}

class EditProjectDialog extends StatefulWidget {
  final Project project;
  final Function(Project) onSave;
  final VoidCallback onDelete;

  const EditProjectDialog({
    super.key,
    required this.project,
    required this.onSave,
    required this.onDelete,
  });

  @override
  State<EditProjectDialog> createState() => _EditProjectDialogState();
}

class _EditProjectDialogState extends State<EditProjectDialog> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late DateTime deadline;
  late ProjectStatus status;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.project.title);
    descriptionController = TextEditingController(text: widget.project.description);
    deadline = widget.project.deadline;
    status = widget.project.status;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Project'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Project Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('Deadline'),
              subtitle: Text(deadline.toString().split(' ')[0]),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: deadline,
                  firstDate: DateTime.now().subtract(const Duration(days: 365)),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (picked != null) {
                  setState(() {
                    deadline = picked;
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<ProjectStatus>(
              value: status,
              decoration: const InputDecoration(
                labelText: 'Status',
                border: OutlineInputBorder(),
              ),
              items: ProjectStatus.values.map((s) {
                return DropdownMenuItem(
                  value: s,
                  child: Text(s.toString().split('.').last),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    status = value;
                  });
                }
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Delete Project'),
                content: const Text('Are you sure you want to delete this project?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    onPressed: () {
                      widget.onDelete();
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: const Text('Delete'),
                  ),
                ],
              ),
            );
          },
          child: const Text('Delete', style: TextStyle(color: Colors.red)),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (titleController.text.isNotEmpty) {
              final updatedProject = Project(
                id: widget.project.id,
                title: titleController.text,
                description: descriptionController.text,
                deadline: deadline,
                status: status,
                createdAt: widget.project.createdAt,
              );
              widget.onSave(updatedProject);
              Navigator.pop(context);
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}

class WishingDialog extends StatelessWidget {
  final String type;
  final List<Employee> people;

  const WishingDialog({
    super.key,
    required this.type,
    required this.people,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('$type Wishes'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Send wishes to ${people.length} ${people.length == 1 ? 'person' : 'people'}:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...people.map((person) => Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: CircleAvatar(
                  child: Text(person.avatar),
                ),
                title: Text(person.name),
                subtitle: Text(person.role),
                trailing: IconButton(
                  icon: const Icon(Icons.send, color: Colors.blue),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Wish sent to ${person.name}! 🎉'),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                ),
              ),
            )).toList(),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
        ElevatedButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Wishes sent to all ${people.length} people! 🎊'),
                duration: const Duration(seconds: 2),
              ),
            );
            Navigator.pop(context);
          },
          child: const Text('Send to All'),
        ),
      ],
    );
  }
}
